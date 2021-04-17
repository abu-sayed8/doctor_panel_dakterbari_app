import 'package:doctor_panel/widgets/custom_app_bar.dart';
import 'package:doctor_panel/widgets/button_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doctor_panel/providers/forum_provider.dart';
import 'package:doctor_panel/providers/doctor_provider.dart';
import 'package:doctor_panel/widgets/notification_widget.dart';
import 'package:doctor_panel/pages/subpage/forum_answers_page.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:expandable_text/expandable_text.dart';

class ForumPage extends StatefulWidget {
  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  final _scaffoldKey= GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: customAppBarDesign(context, 'Public Forum'),
      body: _bodyUI(),
    );
  }

  Widget _bodyUI() {
    Size size = MediaQuery.of(context).size;
    return Consumer<ForumProvider>(
      builder: (context, forumProvider, child){
        return Container(
          height: size.height,
          width: size.width,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: size.height * .06,
                width: size.width,
                color: Colors.white,
                child: Row(
                  children: [
                    Stack(alignment: Alignment.center, children: [
                      Container(
                        height: size.height * .04,
                        width: size.height * .04,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.white,
                        size:  size.width*.039,
                      ),
                    ]),
                    SizedBox(width: 10),
                    Text(
                      "Question For You",
                      style: TextStyle(fontSize: size.width*.036, color: Colors.grey[800]),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Divider(color: Theme.of(context).primaryColor),
              ),


              Expanded(
                child: RefreshIndicator(
                  backgroundColor: Colors.white,
                  onRefresh: ()=>forumProvider.getAllQuestionList(),
                  child: AnimationLimiter(
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: forumProvider.allQuesList.length,
                      itemBuilder: (context, index){
                          return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 500),
                              child: SlideAnimation(
                                verticalOffset: 400.0,
                                child: FadeInAnimation(
                                    child: QuestionBuilder(index,_scaffoldKey)),
                              ));
                          },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ignore: must_be_immutable
class QuestionBuilder extends StatefulWidget {
  int index;
  GlobalKey<ScaffoldState> _scaffoldKey;
  QuestionBuilder(this.index,this._scaffoldKey);

  @override
  _QuestionBuilderState createState() => _QuestionBuilderState();
}

class _QuestionBuilderState extends State<QuestionBuilder> {
  bool _isAns = false;
  int tempIndex;
  final _formKey= GlobalKey<FormState>();

  TextEditingController _ansController= TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final DoctorProvider drProvider = Provider.of<DoctorProvider>(context);

    return Consumer<ForumProvider>(
      builder: (context, forumProvider, child){
        return InkWell(
          onTap: ()async{
            forumProvider.loadingMgs='Please wait...';
            showLoadingDialog(context,forumProvider);
            await forumProvider.getForumAnswer(forumProvider.allQuesList[widget.index].id).then((value){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ForumAnswers(
                question: forumProvider.allQuesList[widget.index].question,
              )));
            });
          },
          child: Container(
            margin: EdgeInsets.only(
              bottom: 10,
            ),
            padding: EdgeInsets.only(left: 10, right: 10),
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                //Title Section...
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: size.width * .86,
                      //color: Colors.red,
                      child: ExpandableText(
                        forumProvider.allQuesList[widget.index].question,
                        expandText: 'more',
                        collapseText: 'less',
                        maxLines: 3,
                        linkColor: Theme.of(context).primaryColor,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontSize: size.width*.035,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[900]),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      width: size.width * .07,
                      //color: Colors.green,
                      child: GestureDetector(
                        onTap: (){
                          forumProvider.removeQuestionFromList(widget.index);
                        },
                        child: Icon(
                          CupertinoIcons.clear,
                          size: size.width*.04,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ],
                ),

                //Middle Section..
                Container(
                  width: size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "${forumProvider.allQuesList[widget.index].totalAns??'0'} Answers · ",
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: size.width*.033,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700]),
                      ),
                      Text(
                        forumProvider.allQuesList[widget.index].quesDate,
                        maxLines: 1,
                        style: TextStyle(fontSize: size.width*.033, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),

                //Bottom Section...
                InkWell(
                  onTap: () {
                    setState(() {
                      _isAns = !_isAns;
                      tempIndex = widget.index;
                    });
                  },
                  splashColor: Colors.red,
                  child: Row(
                    children: [
                      _isAns && widget.index == tempIndex
                          ? Icon(Icons.edit,
                          size: 20, color: Theme.of(context).primaryColor)
                          : Icon(Icons.edit, size: 20, color: Colors.grey[700]),
                      _isAns && widget.index == tempIndex
                          ? Text(
                        "Answer",
                        style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).primaryColor),
                      )
                          : Text(
                        "Answer",
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey[800]),
                      )
                    ],
                  ),
                ),
                SizedBox(width: 20),

                //Answer Section
                _isAns && widget.index == tempIndex
                    ? Form(
                  key: _formKey,
                      child: Column(
                  children: [
                      TextFormField(
                        controller: _ansController,
                        keyboardType: TextInputType.text,
                        maxLines: 2,
                        validator: (val)=> val.isEmpty?'Answer can\'t be empty':null,
                        decoration: InputDecoration(
                            hintText: 'White your answer',
                            hintStyle: TextStyle(fontSize: 13)),
                      ),
                      SizedBox(height: 5),
                      //
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () async{
                              if(_formKey.currentState.validate()){
                                forumProvider.loadingMgs='Submitting answer...';
                                showLoadingDialog(context,forumProvider);
                                await forumProvider.submitForumAnswer(forumProvider.allQuesList[widget.index].id, _ansController.text,
                                    forumProvider.allQuesList[widget.index].totalAns,widget.index, drProvider, context, widget._scaffoldKey).then((value){
                                      _ansController.clear();
                                });
                              }
                            },
                            splashColor: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: miniOutlineButton(context, 'Answer',
                                Theme.of(context).primaryColor),
                          )
                        ],
                      ),
                  ],
                ),
                    )
                    : Container(),

                _isAns && widget.index == tempIndex
                    ? Container()
                    : Divider(
                  color: Colors.grey[900],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

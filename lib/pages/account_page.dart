import 'package:doctor_panel/pages/login_page.dart';
import 'package:doctor_panel/pages/subpage/contact_us_page.dart';
import 'package:doctor_panel/pages/subpage/faq_page.dart';
import 'package:doctor_panel/pages/subpage/update_profile_page.dart';
import 'package:doctor_panel/pages/terms_and_condition.dart';
import 'package:doctor_panel/providers/article_provider.dart';
import 'package:doctor_panel/widgets/custom_app_bar.dart';
import 'package:doctor_panel/widgets/notification_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:doctor_panel/providers/doctor_provider.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {

  @override
  Widget build(BuildContext context) {
    // final FirebaseOperation operation = Provider.of<FirebaseOperation>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      //backgroundColor: Color(0xffAAF1E8),
      appBar: customAppBarDesign(context, "My Account"),
      body: _bodyUI(),
    );
  }

  Widget _bodyUI() {
    Size size = MediaQuery.of(context).size;
    final DoctorProvider operation = Provider.of<DoctorProvider>(context);
    return Column(
      children: [
        ///Account Section...
        Container(
          padding: EdgeInsets.all(10),
          color: Colors.white,
          height: size.height * .28,
          width: size.width,
          child: Row(
            children: [
              Container(
                width: size.width * .46,
                alignment: Alignment.topLeft,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Color(0xffAAF1E8),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: operation.doctorList[0].photoUrl==null?
                Image.asset("assets/male.png", width: size.width*.45)
                    :ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: CachedNetworkImage(
                    imageUrl: operation.doctorList[0].photoUrl,
                    placeholder: (context, url) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('assets/loadingimage.gif',width: size.width * .46,
                        fit: BoxFit.cover,),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    width: size.width * .46,
                    height: size.height * .28,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                width: size.width * .42,
                margin: EdgeInsets.only(left: 10, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      operation.doctorList.isEmpty?'Your Name':operation.doctorList[0].fullName,
                      maxLines: 3,
                      style:
                      TextStyle(fontSize: size.width*.06, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: size.width / 15),
                    Text(
                      operation.doctorList.isEmpty?'Phone Number':operation.doctorList[0].id,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: size.width*.05,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),

        ///Account Options Section...
        Expanded(
          child: Container(
            width: size.width,
            padding: EdgeInsets.only(top: 10, left: 10,right: 10),
            color: Color(0xffF4F7F5),
            child: AnimationLimiter(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: size.width / 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.7),
                itemCount: 5,
                itemBuilder: (context,index){
                  return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 500),
                      child: SlideAnimation(
                        verticalOffset: 400,
                        child: FadeInAnimation(
                            child: FunctionBuilder(index: index)),
                      )
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class FunctionBuilder extends StatelessWidget {
  int index;
  FunctionBuilder({this.index});

  @override
  Widget build(BuildContext context) {
    final DoctorProvider drProvider=Provider.of<DoctorProvider>(context);
    final ArticleProvider articleProvider=Provider.of<ArticleProvider>(context);
    Size size=MediaQuery.of(context).size;
    return InkWell(
      splashColor: Theme.of(context).primaryColor,
      onTap: ()async {
        if (index == 0) {
          drProvider.loadingMgs='Please wait...';
          showLoadingDialog(context,drProvider);
          Future.delayed(Duration(milliseconds: 500)).then((value){
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => UpdateProfile()));
          });

        }
        if (index == 1) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ContactUs()));
        }
        if (index == 2) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TermsAndCondition(
                    tc: "tc",
                  )));
        }
        if (index == 3) {

          Navigator.push(
              context, MaterialPageRoute(builder: (context) => FAQPage()));
        }
        if (index == 4) {
          drProvider.loadingMgs = 'Logging out...';
          showLoadingDialog(context, drProvider);
          await FirebaseAuth.instance.signOut().then((value)async{
             SharedPreferences pref = await SharedPreferences.getInstance();
             pref.setString('id', null);
             drProvider.doctorDetails=null;
            articleProvider.clearAllArticleList();
            Navigator.pop(context);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LogIn()),
                    (route) => false);
          });

        }
      },

      child: Container(
        padding: EdgeInsets.only(left: 20),
        margin: EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8)),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey, offset: Offset(.2, .5), blurRadius: 2)
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              index==0?Icons.account_box_outlined
                  :index==1?Icons.email_outlined
                  :index==2?Icons.article_outlined
                  :index==3?Icons.announcement_outlined
                  :Icons.logout,
              color: Color(0xff00D5BA),
            ),
            Text(
              index==0?'My Profile'
                  :index==1?'Contact Us'
                  :index==2?'T&C'
                  :index==3?'FAQ\'s'
                  :'Logout',
              style: TextStyle(
                  fontSize: size.width*.052,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800]),
            ),
            SizedBox(height: 10),
            Text(
                index==0?'Setup profile'
                    :index==1?'Let us help you'
                    :index==2?'Company polies'
                    :index==3?'Quick answer'
                    :'See you again',
              style: TextStyle(color: Colors.grey[600],fontSize: size.width*.04),
            )
          ],
        ),
      ),
    );
  }
}

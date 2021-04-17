import 'package:doctor_panel/providers/doctor_provider.dart';
import 'package:doctor_panel/widgets/custom_app_bar.dart';
import 'package:doctor_panel/shared/form_decoration.dart';
import 'package:doctor_panel/widgets/button_widgets.dart';
import 'package:doctor_panel/widgets/notification_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateFAQ extends StatefulWidget {
  @override
  _UpdateFAQState createState() => _UpdateFAQState();
}

class _UpdateFAQState extends State<UpdateFAQ> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _counter=0;
  TextEditingController one = TextEditingController();
  TextEditingController two = TextEditingController();
  TextEditingController three = TextEditingController();
  TextEditingController four = TextEditingController();
  TextEditingController five = TextEditingController();
  TextEditingController six = TextEditingController();
  TextEditingController seven = TextEditingController();
  TextEditingController eight = TextEditingController();
  TextEditingController nine = TextEditingController();
  TextEditingController ten = TextEditingController();

  _initializeFaq(DoctorProvider operation){
    setState(()=>_counter++);

    one.text = operation.faqList.isEmpty?"":operation.faqList[0].one;
    two.text = operation.faqList.isEmpty?"":operation.faqList[0].two;
    three.text = operation.faqList.isEmpty?"":operation.faqList[0].three;
    four.text = operation.faqList.isEmpty?"":operation.faqList[0].four;
    five.text = operation.faqList.isEmpty?"":operation.faqList[0].five;
    six.text = operation.faqList.isEmpty?"":operation.faqList[0].six;
    seven.text = operation.faqList.isEmpty?"":operation.faqList[0].seven;
    eight.text = operation.faqList.isEmpty?"":operation.faqList[0].eight;
    nine.text = operation.faqList.isEmpty?"":operation.faqList[0].nine;
    ten.text = operation.faqList.isEmpty?"":operation.faqList[0].ten;

    operation.faqModel.one = operation.faqList.isEmpty?"":operation.faqList[0].one;
    operation.faqModel.two = operation.faqList.isEmpty?"":operation.faqList[0].two;
    operation.faqModel.three = operation.faqList.isEmpty?"":operation.faqList[0].three;
    operation.faqModel.four = operation.faqList.isEmpty?"":operation.faqList[0].four;
    operation.faqModel.five= operation.faqList.isEmpty?"":operation.faqList[0].five;
    operation.faqModel.six = operation.faqList.isEmpty?"":operation.faqList[0].six;
    operation.faqModel.seven = operation.faqList.isEmpty?"":operation.faqList[0].seven;
    operation.faqModel.eight = operation.faqList.isEmpty?"":operation.faqList[0].eight;
    operation.faqModel.nine= operation.faqList.isEmpty?"":operation.faqList[0].nine;
    operation.faqModel.ten = operation.faqList.isEmpty?"":operation.faqList[0].ten;
  }

  @override
  Widget build(BuildContext context) {
    final DoctorProvider operation = Provider.of<DoctorProvider>(context);
    if(_counter==0) _initializeFaq(operation);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: customAppBarDesign(context, 'Update Your FAQ'),
      body:_bodyUI(operation),
    );
  }
  
  Widget _bodyUI(DoctorProvider operation){
    Size size = MediaQuery.of(context).size;
    return Container(
      child: ListView(
        children: [
          _textFormBuilder('How much experience of you in ${operation.doctorList[0].specification}?',1,operation),
          _textFormBuilder('How can I book an online appointment with you, ${operation.doctorList[0].specification}?',2,operation),
          _textFormBuilder('What are the consultation charge of you?',3,operation),
          _textFormBuilder('What is the location of the hospital/clinic/chamber in ${operation.doctorList[0].state?? 'your area'}?',4,operation),
          _textFormBuilder('Can I view the OPD schedule, fee, and other details of you?',5,operation),
          _textFormBuilder('Are you available at any other hospital?',6,operation),
          _textFormBuilder('What is your fee?',7,operation),
          _textFormBuilder("What are your's speciality interest?",8,operation),
          _textFormBuilder('Where can I consult with you?',9,operation),
          _textFormBuilder('What societies is you a member of?',10,operation),
          SizedBox(height: 20),
          Container(
              margin: EdgeInsets.only(left: 10,right:10),
              child: InkWell(
                onTap: ()=> _checkValidation(operation),
                borderRadius: BorderRadius.all(Radius.circular(10)),
                splashColor: Theme.of(context).primaryColor,
                  child: bigOutlineIconButton(context, Icons.update_rounded, 'Update FAQ', Theme.of(context).primaryColor)
              )
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
  
  Widget _textFormBuilder(String question,int serialNo,DoctorProvider operation){
    return Container(
      margin: EdgeInsets.only(left: 10,right: 10,bottom: 30),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$serialNo. $question',style: TextStyle(color: Colors.grey[800]),),
          SizedBox(height: 5),
          TextFormField(
            controller: serialNo==1? one:serialNo==2? two:serialNo==3? three:serialNo==4? four:serialNo==5? five
                :serialNo==6? six:serialNo==7? seven:serialNo==8? eight:serialNo==9? nine:ten,
            onChanged: (val){

              if(serialNo==1) operation.faqModel.one=one.text;
              if(serialNo==2) operation.faqModel.two=two.text;
              if(serialNo==3) operation.faqModel.three=three.text;
              if(serialNo==4) operation.faqModel.four=four.text;
              if(serialNo==5) operation.faqModel.five=five.text;
              if(serialNo==6) operation.faqModel.six=six.text;
              if(serialNo==7) operation.faqModel.seven=seven.text;
              if(serialNo==8) operation.faqModel.eight=eight.text;
              if(serialNo==9) operation.faqModel.nine=nine.text;
              if(serialNo==10) operation.faqModel.ten=ten.text;
              print(operation.faqModel.one);
            },
            decoration: FormDecorationWithoutPrefix.copyWith(
              labelText: 'Ans:',
              fillColor: Color(0xffF4F7F5)
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _checkValidation(DoctorProvider operation)async{
    if(operation.faqModel.one.isNotEmpty && operation.faqModel.two.isNotEmpty && operation.faqModel.three.isNotEmpty
    && operation.faqModel.four.isNotEmpty && operation.faqModel.five.isNotEmpty && operation.faqModel.six.isNotEmpty
    && operation.faqModel.seven.isNotEmpty && operation.faqModel.eight.isNotEmpty && operation.faqModel.nine.isNotEmpty
    && operation.faqModel.ten.isNotEmpty){
      operation.loadingMgs="Updating FAQ...";
      showLoadingDialog(context, operation);
      await operation.updateFaq(operation, _scaffoldKey, context);
    }else showSnackBar(_scaffoldKey, 'Field can\'t be empty', Colors.deepOrange);
  }
}

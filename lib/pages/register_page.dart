import 'package:country_code_picker/country_code_picker.dart';
import 'package:doctor_panel/pages/terms_and_condition.dart';
import 'package:doctor_panel/providers/reg_auth_provider.dart';
import 'package:doctor_panel/widgets/custom_app_bar.dart';
import 'package:doctor_panel/shared/form_decoration.dart';
import 'package:doctor_panel/shared/static_variable_page.dart';
import 'package:doctor_panel/widgets/button_widgets.dart';
import 'package:doctor_panel/widgets/notification_widget.dart';
import 'package:doctor_panel/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doctor_panel/providers/doctor_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController minController = TextEditingController();
  TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    minController = TextEditingController(text: '15 min');
  }

  void _initializeDoctorData(RegAuth regAuth){
    regAuth.doctorDetails.provideTeleService=false;
    regAuth.doctorDetails.phone='';
    regAuth.doctorDetails.fullName='';
    regAuth.doctorDetails.password='';
    regAuth.doctorDetails.degree='';
    regAuth.doctorDetails.bmdcNumber='';
    regAuth.doctorDetails.appFee='';
    regAuth.doctorDetails.teleFee='';
    regAuth.doctorDetails.countryCode='';
    //Initialize teleService date
    regAuth.doctorDetails.sat=[false,TimeOfDay.now(),TimeOfDay.now()];
    regAuth.doctorDetails.sun=[false,TimeOfDay.now(),TimeOfDay.now()];
    regAuth.doctorDetails.mon=[false,TimeOfDay.now(),TimeOfDay.now()];
    regAuth.doctorDetails.tue=[false,TimeOfDay.now(),TimeOfDay.now()];
    regAuth.doctorDetails.wed=[false,TimeOfDay.now(),TimeOfDay.now()];
    regAuth.doctorDetails.thu=[false,TimeOfDay.now(),TimeOfDay.now()];
    regAuth.doctorDetails.fri=[false,TimeOfDay.now(),TimeOfDay.now()];
  }

  @override
  Widget build(BuildContext context) {
    final DoctorProvider operation = Provider.of<DoctorProvider>(context);
    return Consumer<RegAuth>(
      builder: (context, regAuth, child){
        if(regAuth.doctorDetails.sat==null || regAuth.doctorDetails.provideTeleService==null ||regAuth.doctorDetails.phone==null){
          _initializeDoctorData(regAuth);
        }
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor:Colors.white,
          //resizeToAvoidBottomInset: false,
          appBar: customAppBarDesign(context, "Register Now"),
          body:_BodyUI(context,regAuth,operation),
          //bottomNavigationBar: _bottomNavigation(),
        );
      },
    );
  }

  // ignore: non_constant_identifier_names
  Widget _BodyUI(BuildContext context, RegAuth regAuth,DoctorProvider operation) {
    Size size = MediaQuery.of(context).size;
    return Container(
      //margin: EdgeInsets.only(left: 20, right: 20),
      height: size.height,
      width: size.width,
      child: ListView(
        children: [
          Column(
            children: [
              Text(
                "Your phone number is not recognized yet.",
                style: TextStyle(
                    color: Colors.grey[700], fontSize: size.width / 21),
              ),
              Text(
                "Let us know basic details for registration.",
                style: TextStyle(
                    color: Colors.grey[700], fontSize: size.width / 21),
              ),
            ],
          ),
          SizedBox(height: size.width / 8),

          //Registration Form
          Container(
            padding:EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                //Mobile number with country code
                Container(
                  width: size.width,
                  height: 58,
                  decoration: BoxDecoration(
                    color: Color(0xffF4F7F5),
                    borderRadius:  BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width:size.width*.35,
                          child: _countryCodePicker(regAuth)
                      ),
                      Container(
                          width:size.width*.58,
                          child: _textFieldBuilder('Phone Number',regAuth)),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                //Full name
                _textFieldBuilder('Full Name',regAuth),
                SizedBox(height: size.width / 20),

                //Password
                _textFieldBuilder('Password',regAuth),
                SizedBox(height: size.width / 20),

                _dropDownBuilder('Select Gender',regAuth),
                SizedBox(height: size.width / 20),

                _dropDownBuilder('Select Speciality & Services',regAuth),
                SizedBox(height: size.width / 20),

                _textFieldBuilder('Degree',regAuth),
                SizedBox(height: size.width / 20),

                _textFieldBuilder('BMDC Registration Number',regAuth),
                SizedBox(height: size.width / 20),

                //Appointment Fee
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xffF4F7F5),
                    borderRadius:  BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    children: [
                      Container(
                          width:size.width*.44,
                          child: _dropDownBuilder('Select Currency', regAuth)),

                      Container(
                          width:size.width*.48,
                          child: _textFieldBuilder('Appointment Fee',regAuth)),
                    ],
                  ),
                ),
                SizedBox(height: size.width / 30),

                //Telemedicine Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                              child: Text("If provide telemedicine service",
                                style: TextStyle(color: Colors.grey[700],fontSize: size.width*.036),
                              )
                          ),
                        ],
                      ),
                    ),
                    Switch(value: regAuth.doctorDetails.provideTeleService, onChanged: (newValue)=>
                      setState(()=>regAuth.doctorDetails.provideTeleService = newValue))
                  ],
                ),
                SizedBox(height: size.width / 40),
                regAuth.doctorDetails.provideTeleService? Text(
                  "Telemedicine schedule",
                  style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: size.width*.04,
                      fontWeight: FontWeight.w500),
                ):Container(),
                regAuth.doctorDetails.provideTeleService? Divider(color: Theme.of(context).primaryColor):Container(),

                regAuth.doctorDetails.provideTeleService? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _availability('Sat',regAuth),
                    _availability('Sun',regAuth),
                    _availability('Mon',regAuth),
                    _availability('Tue',regAuth),
                    _availability('Wed',regAuth),
                    _availability('Thu',regAuth),
                    _availability('Fri',regAuth),
                    Padding(
                      padding: EdgeInsets.only(left: 14),
                      child: Text('Minimum Telemedicine service duration 15 min',style: TextStyle(fontSize: size.width*.04, color: Color(0xffF0A732)),),
                    ),
                    SizedBox(height: 5),
                    //Tele Fee
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xffF4F7F5),
                        borderRadius:  BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                        children: [
                          Container(
                              width:size.width*.44,
                              child: _dropDownBuilder('Select Currency', regAuth)),

                          Container(
                              width:size.width*.48,
                              child: _textFieldBuilder('Tele Service Fee',regAuth)),
                        ],
                      ),
                    ),
                    //Text("With tax if applicable",style: TextStyle(color: Colors.grey[700],fontSize: 13),),
                    SizedBox(height: 5),
                    Divider(color: Theme.of(context).primaryColor,)
                  ],
                ):Container(),

                //T&C row
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: regAuth.agreeChk,
                      onChanged: (bool checkedValue)=> regAuth.agreeChk = checkedValue,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                              child: Text("I've read & agree to this agreement",
                                  style: TextStyle(fontSize:size.width*.036,color: Colors.grey[700]))),
                          GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TermsAndCondition())),
                              child: Text(
                                " read...",
                                style: TextStyle(
                                  fontSize: size.width*.04,
                                    color: Theme.of(context).primaryColor),
                              )),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: size.width / 20),

                //Continue Button
                GestureDetector(
                  onTap: ()=>_checkValidity(regAuth, operation),
                  child: Button(context, "Continue"),
                ),
                SizedBox(height: size.width / 15),

                //Back to sign in button
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Text(
                    "Back to sign in",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: size.width*.04,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: size.width / 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _availability(String day,RegAuth regAuth){
    Size size = MediaQuery.of(context).size;
    return Container(
        width: size.width,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Day Check Button
            Row(
              children: [
                Checkbox(
                  value: day=='Sat'?regAuth.doctorDetails.sat[0]:day=='Sun'?regAuth.doctorDetails.sun[0]:day=='Mon'?regAuth.doctorDetails.mon[0]:
                  day=='Tue'?regAuth.doctorDetails.tue[0]:day=='Wed'?regAuth.doctorDetails.wed[0]:day=='Thu'?regAuth.doctorDetails.thu[0]:
                  regAuth.doctorDetails.fri[0],
                  onChanged: (bool checkedValue) {
                    setState(() =>
                    day=='Sat'?regAuth.doctorDetails.sat[0] = checkedValue:
                    day=='Sun'?regAuth.doctorDetails.sun[0]= checkedValue:
                    day=='Mon'?regAuth.doctorDetails.mon[0]= checkedValue:
                    day=='Tue'?regAuth.doctorDetails.tue[0]= checkedValue:
                    day=='Wed'?regAuth.doctorDetails.wed[0]= checkedValue:
                    day=='Thu'?regAuth.doctorDetails.thu[0]= checkedValue: regAuth.doctorDetails.fri[0]= checkedValue);
                  },
                ),
                Text(
                  day,
                  style: TextStyle(
                      fontSize: size.width*.032,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800]),
                )
              ],
            ),

            //Time Button
            Container(
              child: Row(
                children: [
                  FlatButton(
                    onPressed: (){
                      _selectTime(context, 'from', day,regAuth);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      height: 30,
                      decoration: BoxDecoration(
                          color: Color(0xffF4F7F5),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      child: Row(
                        children: [
                          Text(day=="Sat"?'${regAuth.doctorDetails.sat[1].hour}:${regAuth.doctorDetails.sat[1].minute}':
                          day=="Sun"?'${regAuth.doctorDetails.sun[1].hour}:${regAuth.doctorDetails.sun[1].minute}':
                          day=="Mon"?'${regAuth.doctorDetails.mon[1].hour}:${regAuth.doctorDetails.mon[1].minute}':
                          day=="Tue"?'${regAuth.doctorDetails.tue[1].hour}:${regAuth.doctorDetails.tue[1].minute}':
                          day=="Wed"?'${regAuth.doctorDetails.wed[1].hour}:${regAuth.doctorDetails.wed[1].minute}':
                          day=="Thu"?'${regAuth.doctorDetails.thu[1].hour}:${regAuth.doctorDetails.thu[1].minute}':
                          '${regAuth.doctorDetails.fri[1].hour}:${regAuth.doctorDetails.fri[1].minute}',
                            style: TextStyle(fontSize: size.width*.03,),),

                          Icon(Icons.arrow_drop_down_outlined,color: Theme.of(context).primaryColor)
                        ],
                      ),
                    ),
                  ),
                  Text("to",style: TextStyle(fontSize: size.width*.04),),
                  FlatButton(
                    onPressed: (){
                      _selectTime(context, 'to', day, regAuth);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      height: 30,
                      decoration: BoxDecoration(
                          color: Color(0xffF4F7F5),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      child: Row(
                        children: [
                          Text(day=="Sat"?'${regAuth.doctorDetails.sat[2].hour}:${regAuth.doctorDetails.sat[2].minute}':
                          day=="Sun"?'${regAuth.doctorDetails.sun[2].hour}:${regAuth.doctorDetails.sun[2].minute}':
                          day=="Mon"?'${regAuth.doctorDetails.mon[2].hour}:${regAuth.doctorDetails.mon[2].minute}':
                          day=="Tue"?'${regAuth.doctorDetails.tue[2].hour}:${regAuth.doctorDetails.tue[2].minute}':
                          day=="Wed"?'${regAuth.doctorDetails.wed[2].hour}:${regAuth.doctorDetails.wed[2].minute}':
                          day=="Thu"?'${regAuth.doctorDetails.thu[2].hour}:${regAuth.doctorDetails.thu[2].minute}':
                          '${regAuth.doctorDetails.fri[2].hour}:${regAuth.doctorDetails.fri[2].minute}',
                            style: TextStyle(fontSize: size.width*.03,),),

                          Icon(Icons.arrow_drop_down_outlined,color: Theme.of(context).primaryColor)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //Expanded(child: Text('15 min',style: TextStyle(fontSize: size.width*.03),))
          ],
        ),
      );
  }

  Future<Null> _selectTime(BuildContext context, String identifier,String day,RegAuth regAuth) async{
    if(identifier=="from"){
      switch(day){
        case 'Sat':
          final TimeOfDay picked = await showTimePicker(
            context: context,
            initialTime: regAuth.doctorDetails.sat[1],
          );
          if(picked!=null && picked!=regAuth.doctorDetails.sat[1]){
            setState(() =>regAuth.doctorDetails.sat[1] = picked);
          }
          break;
        case 'Sun':
          final TimeOfDay picked = await showTimePicker(
            context: context,
            initialTime: regAuth.doctorDetails.sun[1],
          );
          if(picked!=null && picked!=regAuth.doctorDetails.sun[1]){
            setState(() =>regAuth.doctorDetails.sun[1] = picked);
          }
          break;
        case 'Mon':
          final TimeOfDay picked = await showTimePicker(
            context: context,
            initialTime: regAuth.doctorDetails.mon[1],
          );
          if(picked!=null && picked!=regAuth.doctorDetails.mon[1]){
            setState(() =>regAuth.doctorDetails.mon[1] = picked);
          }
          break;
        case 'Tue':
          final TimeOfDay picked = await showTimePicker(
            context: context,
            initialTime: regAuth.doctorDetails.tue[1],
          );
          if(picked!=null && picked!=regAuth.doctorDetails.tue[1]){
            setState(() =>regAuth.doctorDetails.tue[1] = picked);
          }
          break;
        case 'Wed':
          final TimeOfDay picked = await showTimePicker(
            context: context,
            initialTime: regAuth.doctorDetails.wed[1],
          );
          if(picked!=null && picked!=regAuth.doctorDetails.wed[1]){
            setState(() =>regAuth.doctorDetails.wed[1] = picked);
          }
          break;
        case 'Thu':
          final TimeOfDay picked = await showTimePicker(
            context: context,
            initialTime: regAuth.doctorDetails.thu[1],
          );
          if(picked!=null && picked!=regAuth.doctorDetails.thu[1]){
            setState(() =>regAuth.doctorDetails.thu[1] = picked);
          }
          break;
        default:
          final TimeOfDay picked = await showTimePicker(
            context: context,
            initialTime: regAuth.doctorDetails.fri[1],
          );
          if(picked!=null && picked!=regAuth.doctorDetails.fri[1]){
            setState(() =>regAuth.doctorDetails.fri[1] = picked);
          }
          break;

      }
    }else{
      switch(day){
        case 'Sat':
          final TimeOfDay picked = await showTimePicker(
            context: context,
            initialTime: regAuth.doctorDetails.sat[2],
          );
          if(picked!=null && picked!=regAuth.doctorDetails.sat[2]){
            setState(() =>regAuth.doctorDetails.sat[2] = picked);
          }
          break;
        case 'Sun':
          final TimeOfDay picked = await showTimePicker(
            context: context,
            initialTime: regAuth.doctorDetails.sun[2],
          );
          if(picked!=null && picked!=regAuth.doctorDetails.sun[2]){
            setState(() =>regAuth.doctorDetails.sun[2] = picked);
          }
          break;
        case 'Mon':
          final TimeOfDay picked = await showTimePicker(
            context: context,
            initialTime: regAuth.doctorDetails.mon[2],
          );
          if(picked!=null && picked!=regAuth.doctorDetails.mon[2]){
            setState(() =>regAuth.doctorDetails.mon[2] = picked);
          }
          break;
        case 'Tue':
          final TimeOfDay picked = await showTimePicker(
            context: context,
            initialTime: regAuth.doctorDetails.tue[2],
          );
          if(picked!=null && picked!=regAuth.doctorDetails.tue[2]){
            setState(() =>regAuth.doctorDetails.tue[2] = picked);
          }
          break;
        case 'Wed':
          final TimeOfDay picked = await showTimePicker(
            context: context,
            initialTime: regAuth.doctorDetails.wed[2],
          );
          if(picked!=null && picked!=regAuth.doctorDetails.wed[2]){
            setState(() =>regAuth.doctorDetails.wed[2] = picked);
          }
          break;
        case 'Thu':
          final TimeOfDay picked = await showTimePicker(
            context: context,
            initialTime: regAuth.doctorDetails.thu[2],
          );
          if(picked!=null && picked!=regAuth.doctorDetails.thu[2]){
            setState(() =>regAuth.doctorDetails.thu[2] = picked);
          }
          break;
        default:
          final TimeOfDay picked = await showTimePicker(
            context: context,
            initialTime: regAuth.doctorDetails.fri[2],
          );
          if(picked!=null && picked!=regAuth.doctorDetails.fri[2]){
            setState(() =>regAuth.doctorDetails.fri[2] = picked);
          }
          break;

      }
    }
  }

  Widget _dropDownBuilder(String hint,RegAuth regAuth){
    Size size=MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12,vertical: 5),
      decoration: BoxDecoration(
          color: Color(0xffF4F7F5),
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      width: MediaQuery.of(context).size.width,
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: hint=="Select Gender"? regAuth.doctorDetails.gender
              : hint=="Select Currency"? regAuth.doctorDetails.currency
              :regAuth.doctorDetails.specification,
          isExpanded: true,
          hint: Text(hint,style: TextStyle(
              color: Colors.grey[700],
              fontSize: size.width*.033)),
          items: hint=='Select Gender'?
          StaticVariables.genderItems.map((gender){
            return DropdownMenuItem(
              child: Text(gender,style: TextStyle(
                color: Colors.grey[900],
                fontSize: size.width*.033,)),
              value: gender,
            );
          }).toList()
          :hint=='Select Currency'?
          StaticVariables.currency.map((currency){
            return DropdownMenuItem(
              child: Text(currency,style: TextStyle(
                color: Colors.grey[900],
                fontSize: size.width*.033,)),
              value: currency,
            );
          }).toList()
          //for service category
              :StaticVariables.serviceCategoryItems.map((category){
            return DropdownMenuItem(
              child: Text(category,style: TextStyle(
                color: Colors.grey[900],
                fontSize: size.width*.033,)),
              value: category,
            );
          }).toList(),
          onChanged: (newValue){
            setState(() {
              hint=="Select Gender"? regAuth.doctorDetails.gender = newValue
              :hint=="Select Currency"? regAuth.doctorDetails.currency = newValue
                  :regAuth.doctorDetails.specification=newValue;
            });
          },

          dropdownColor: Colors.white,
        ),
      ),
    );
  }

  Widget _textFieldBuilder(String hint,RegAuth regAuth){
    Size size=MediaQuery.of(context).size;
    return TextFormField(
      style: TextStyle(
        fontSize: size.width*.04,
      ),
      obscureText:hint=='Password'? regAuth.obscure:false,
      keyboardType: hint=='Phone Number'? TextInputType.phone
          :hint=='Full Name'?TextInputType.text
          :hint=='BMDC Registration Number'?TextInputType.text
          :hint=='Degree'?TextInputType.text
          :hint=='Password'?TextInputType.text
          :TextInputType.number,
      onChanged: (val){
        setState(() {
          hint=='Phone Number'? regAuth.doctorDetails.phone=val
              :hint=='Full Name'? regAuth.doctorDetails.fullName=val
              :hint=='Appointment Fee'?regAuth.doctorDetails.appFee=val
              :hint=='Password'?regAuth.doctorDetails.password=val
              :hint=='Degree'? regAuth.doctorDetails.degree=val
              :hint=='BMDC Registration Number'? regAuth.doctorDetails.bmdcNumber=val
              :regAuth.doctorDetails.teleFee=val;
        });
      },
      decoration: FormDecoration.copyWith(
          labelText: hint,
          labelStyle: TextStyle(
            fontSize: size.width*.033,
          ),
          hintStyle: TextStyle(fontSize: 14),
          fillColor: Color(0xffF4F7F5),
          prefixIcon:hint=='Full Name'?Icon(Icons.person_outline,size: 28)
              :hint=='Phone Number'?null
              :hint=='Password'?Icon(Icons.security_outlined)
              :hint=='Degree'? Icon(CupertinoIcons.archivebox)
              :hint=='BMDC Registration Number'? Icon(CupertinoIcons.number)
              : null,

          suffixIcon: hint=='Password'? IconButton(
              icon: regAuth.obscure
                  ? Icon(Icons.visibility_off_rounded)
                  : Icon(Icons.remove_red_eye),
              onPressed: () =>
                  setState(() => regAuth.obscure = !regAuth.obscure)):null
      ),
    );
  }

  Widget _countryCodePicker(RegAuth regAuth){
    Size size=MediaQuery.of(context).size;
    return CountryCodePicker(
      comparator: (a, b) =>
          b.name.compareTo(a.name),
      onChanged: (val) {
        regAuth.doctorDetails.countryCode = val.dialCode;
        //print(countryCode);
      },
      onInit: (code) {
        regAuth.doctorDetails.countryCode = code.dialCode;
        //print(countryCode);
      },
      textStyle: TextStyle(
        fontSize: size.width*.033,
      ),
      favorite: ['+880', 'BD'],
      initialSelection: 'BD',
      showCountryOnly: false,
      showFlag: true,
      showOnlyCountryWhenClosed: false,
      showDropDownButton: true,
      padding: EdgeInsets.only(left: 10),
    );
  }

  Future<void> _checkValidity(RegAuth regAuth,DoctorProvider operation) async{
    if(regAuth.doctorDetails.provideTeleService){
      if(regAuth.doctorDetails.phone.isNotEmpty && regAuth.doctorDetails.fullName.isNotEmpty && regAuth.doctorDetails.password.isNotEmpty &&
          regAuth.doctorDetails.gender!=null &&regAuth.doctorDetails.currency!=null &&regAuth.doctorDetails.appFee.isNotEmpty&& regAuth.doctorDetails.specification!=null &&
          regAuth.doctorDetails.teleFee.isNotEmpty && regAuth.doctorDetails.degree.isNotEmpty){
        if(regAuth.agreeChk){
          regAuth.loadingMgs = 'Please wait...';
          showLoadingDialog(context, regAuth);
          bool isRegistered = await regAuth.isDoctorRegistered(regAuth.doctorDetails.countryCode+regAuth.doctorDetails.phone);
          bool isPatientRegistered =await regAuth.isPatientRegistered(regAuth.doctorDetails.countryCode+regAuth.doctorDetails.phone);
          if(!isRegistered){
              if(!isPatientRegistered) _OTPVerification(regAuth,operation);
              else{
                Navigator.pop(context);
                showSnackBar(_scaffoldKey,'A patient is registered with this phone number', Colors.deepOrange);
              }
          }else{
            Navigator.pop(context);
          showSnackBar(_scaffoldKey,'A doctor is registered with this phone number', Colors.deepOrange);
          }
        }else showSnackBar(_scaffoldKey,'Check agreement', Colors.deepOrange);
      }else showSnackBar(_scaffoldKey,'Complete all the required fields', Colors.deepOrange);
    }else{
      if(regAuth.doctorDetails.phone.isNotEmpty && regAuth.doctorDetails.fullName.isNotEmpty && regAuth.doctorDetails.password.isNotEmpty &&
          regAuth.doctorDetails.gender!=null &&regAuth.doctorDetails.currency!=null &&regAuth.doctorDetails.appFee.isNotEmpty&& regAuth.doctorDetails.specification!=null &&
          regAuth.doctorDetails.degree.isNotEmpty){
        if(regAuth.agreeChk){
          regAuth.loadingMgs = 'Please wait...';
          showLoadingDialog(context, regAuth);
          bool isRegistered= await regAuth.isDoctorRegistered(regAuth.doctorDetails.countryCode+regAuth.doctorDetails.phone);
          bool isPatientRegistered =await regAuth.isPatientRegistered(regAuth.doctorDetails.countryCode+regAuth.doctorDetails.phone);
          if(!isRegistered){
            if(!isPatientRegistered) _OTPVerification(regAuth,operation);
            else{
              Navigator.pop(context);
              showSnackBar(_scaffoldKey,'A patient is registered with this phone number', Colors.deepOrange);
            }
          }else{
            Navigator.pop(context);
            showSnackBar(_scaffoldKey,'A doctor is registered with this phone number', Colors.deepOrange);
          }
        }else showSnackBar(_scaffoldKey,'Check agreement', Colors.deepOrange);
      }else showSnackBar(_scaffoldKey,'Complete all the required fields', Colors.deepOrange);
    }
  }

  // ignore: non_constant_identifier_names
  Future<void> _OTPVerification(RegAuth regAuth,DoctorProvider operation)async{
    FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.verifyPhoneNumber(
      phoneNumber: regAuth.doctorDetails.countryCode+regAuth.doctorDetails.phone,
      //Automatic verify....
      verificationCompleted: (PhoneAuthCredential credential) async{
        await _auth.signInWithCredential(credential).then((value) async{
          if(value.user!=null){
            bool result = await regAuth.registerUser(regAuth.doctorDetails);
            if(result){
              //save data to local
              SharedPreferences pref = await SharedPreferences.getInstance();
              pref.setString('id', regAuth.doctorDetails.countryCode+regAuth.doctorDetails.phone);
              pref.setStringList('likeId', []);

              //clear all list
              operation.clearDoctorList();
              operation.clearHospitalList();
              operation.clearFaqList();
              await operation.getDoctor().then((value)async{
                await operation.getHospitals();
                Navigator.pop(context);
                regAuth.doctorDetails =null;
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomePage()), (route) => false);
              });
            }
            else{
              Navigator.pop(context);
              showSnackBar(_scaffoldKey,'Error register doctor. Try again', Colors.deepOrange);
            }
          }
        });
      },
      verificationFailed: (FirebaseAuthException e){
        if (e.code == 'invalid-phone-number') {
          Navigator.pop(context);
          showSnackBar(_scaffoldKey,'The provided phone number is not valid', Colors.deepOrange);
        }
      },
      codeSent: (String verificationId, int resendToken){
        regAuth.verificationCode = verificationId;
        Navigator.pop(context);
        _OTPDialog(regAuth,operation);
      },
      codeAutoRetrievalTimeout: (String verificationId){
        regAuth.verificationCode = verificationId;
        Navigator.pop(context);
        _OTPDialog(regAuth,operation);
      },
      timeout: Duration(seconds: 120),

    );
  }

  // ignore: non_constant_identifier_names
  void _OTPDialog(RegAuth regAuth,DoctorProvider operation){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          Size size=MediaQuery.of(context).size;
          return AlertDialog(
            scrollable: true,
            contentPadding: EdgeInsets.all(20),
            title: Text("Phone Verification", style:TextStyle(fontSize: size.width*.04),textAlign: TextAlign.center),
            content: Container(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Container(
                    child: Text(
                      "We've sent OTP verification code on your given number.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[700],fontSize: size.width*.034),
                    ),
                  ),
                  SizedBox(height: 25),
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: size.width*.04),
                    decoration: FormDecoration.copyWith(
                        labelText: "Enter OTP here",
                        labelStyle: TextStyle(
                          fontSize: size.width*.033,
                        ),
                        fillColor: Colors.grey[100],
                        prefixIcon: Icon(Icons.security)),
                  ),
                  SizedBox(height: 10),
                  Consumer<DoctorProvider>(
                    builder: (context, operation, child){
                      return GestureDetector(
                        onTap: ()async{
                          regAuth.loadingMgs = 'Verifying OTP...';
                          showLoadingDialog(context, regAuth);
                          try{
                            await FirebaseAuth.instance.signInWithCredential(PhoneAuthProvider.credential(
                                verificationId: regAuth.verificationCode, smsCode: _otpController.text)).then((value)async{
                              if(value.user!=null){
                                bool result = await regAuth.registerUser(regAuth.doctorDetails);
                                if(result){

                                  //Save data to local
                                  SharedPreferences pref = await SharedPreferences.getInstance();
                                  pref.setString('id', regAuth.doctorDetails.countryCode+regAuth.doctorDetails.phone);

                                  pref.setStringList('likeId', []);
                                  //clear all list
                                  operation.clearDoctorList();
                                  operation.clearHospitalList();
                                  operation.clearFaqList();

                                  await operation.getDoctor().then((value)async{
                                    await operation.getHospitals();
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    regAuth.doctorDetails =null;
                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomePage()), (route) => false);
                                  });
                                }
                                else{
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  showSnackBar(_scaffoldKey,'Error register doctor. Try again', Colors.deepOrange);
                                }
                              }
                            });
                          }catch(e){
                            Navigator.pop(context);
                            Navigator.pop(context);
                            showSnackBar(_scaffoldKey,'Invalid OTP', Colors.deepOrange);
                          }
                        },
                        child: Button(context, 'Submit'),
                      );
                    },
                  ),
                  SizedBox(height: 15),

                  Text('OTP will expired after 2 minutes',style: TextStyle(fontSize: size.width*.033,color: Colors.grey[600]))
                ],
              ),
            ),
          );
        });
  }

}
import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:doctor_panel/pages/register_page.dart';
import 'package:doctor_panel/shared/form_decoration.dart';
import 'package:doctor_panel/widgets/button_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doctor_panel/providers/reg_auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:doctor_panel/widgets/notification_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doctor_panel/pages/home_page.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:doctor_panel/providers/doctor_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:doctor_panel/pages/subpage/forgot_password_page.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController _otpController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isConnected = true;
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  void _checkConnectivity() async {
    var result = await (Connectivity().checkConnectivity());
    if (result == ConnectivityResult.none) {
      setState(() => _isConnected = false);
      showSnackBar(_scaffoldKey,"No internet connection !", Colors.deepOrange);
    } else if (result == ConnectivityResult.mobile) {
      setState(() => _isConnected = true);
    } else if (result == ConnectivityResult.wifi) {
      setState(() => _isConnected = true);
    }
  }

  void _initializeDoctorData(RegAuth regAuth) async{
    regAuth.doctorDetails.phone='';
    regAuth.doctorDetails.password='';
  }

  @override
  Widget build(BuildContext context) {
    final RegAuth regAuth=Provider.of<RegAuth>(context);
    final DoctorProvider operation=Provider.of<DoctorProvider>(context);
    if(regAuth.doctorDetails.phone==null || regAuth.doctorDetails.password==null) _initializeDoctorData(regAuth);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xffF4F7F5),
      //resizeToAvoidBottomInset: false,
      body: _isConnected ?
      _bodyUI(regAuth,operation)
          : _noInternetUI(),
    );
  }

  Widget _bodyUI(RegAuth regAuth,DoctorProvider operation) {
    final Size size = MediaQuery.of(context).size;
    final Color colorPrimaryAccent = Color(0xffBCEDF2);
    return Container(
      height: size.height,
      width: size.width,
      child: SingleChildScrollView(
        child: Column(
          children: [
            //Heading Section
            Container(
              height: size.height * .40,
              width: size.width,
              color: colorPrimaryAccent,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ///Logo Icon...
                  Positioned(
                      top: size.height * .09,
                      child: Container(
                        alignment: Alignment.center,
                        width: size.width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          child: Image.asset(
                            "assets/logo.png",
                            height: 50,
                            //width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )),

                  ///Doctors Image...
                  Positioned(
                    bottom: -(size.height * .04),
                    child: Container(
                        alignment: Alignment.center,
                        width: size.width,
                        child: Image.asset(
                          "assets/doctor_patient.png",
                          height: 200,
                          fit: BoxFit.cover,
                        )),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),

            ///Phone number field
            Container(
              width:size.width*.90,
              child: Material(
                color: Colors.white,
                elevation: 2,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Row(
                  children: [
                    Container(
                        width:size.width*.35,
                        //height: size.width*.13,
                        child: _countryCodePicker(regAuth)
                    ),
                    Container(
                      width:size.width*.54,
                      //height: size.width*.13,
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        onChanged: (val)=> setState(()=>regAuth.doctorDetails.phone = val),
                        decoration:
                        FormDecoration.copyWith(
                          labelStyle: TextStyle(
                            fontSize: size.width*.033,
                          ),
                          labelText: 'Phone number',
                          prefixIcon: null,
                        ),
                        style:  TextStyle(
                        fontSize: size.width*.04,
                      ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            ///password field
            Container(
              width: size.width * .90,

              //height: 50,
              alignment: Alignment.center,
              child: Material(
                elevation: 2,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: TextFormField(
                  style: TextStyle(
                  fontSize: size.width*.04,
                ),
                  obscureText: _obscure,
                  keyboardType: TextInputType.text,
                  onChanged: (val)=>
                  setState(()=>regAuth.doctorDetails.password = val),
                  decoration: FormDecoration.copyWith(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        fontSize: size.width*.033,
                      ),
                      prefixIcon: Icon(Icons.security),
                      suffixIcon: IconButton(
                          icon: _obscure
                              ? Icon(Icons.visibility_off_rounded)
                              : Icon(Icons.remove_red_eye),
                          onPressed: () =>
                              setState(() => _obscure = !_obscure))),
                ),
              ),
            ),
            SizedBox(height: 20),

            ///Continue Button...
            Consumer<DoctorProvider>(
              builder: (context, operation, child){
                return Container(
                  width: size.width * .90,
                  height: size.width*.12,
                  child: GestureDetector(
                    onTap: ()=> _checkValidity(regAuth,operation),
                    child: Button(context, "Continue"),
                  ),
                );
              },
            ),
            SizedBox(height: 40),

            ///Register Button
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have account? ",
                  style: TextStyle(
                      fontWeight: FontWeight.w500, fontSize: size.width / 20),
                ),
                Consumer<RegAuth>(
                  builder: (context, regAuth, child){
                    return GestureDetector(
                      onTap: () {
                        regAuth.doctorDetails=null;
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Register()));
                      },
                      child: Text(
                        "Register",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: size.width / 20,
                            color: Theme.of(context).primaryColor),
                      ),


                    );
                  },
                ),

              ],
            ),
            SizedBox(height: 30),

            ///Forgot password
            GestureDetector(
              onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPassword())),
              child: Text('Forgot Password?',
                  style:TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: size.width / 20,
                  color: Theme.of(context).primaryColor)),
            )
          ],
        ),
      ),
    );
  }

  Widget _noInternetUI() {
    return Container(
      color: Colors.white70,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/logo.png",
            height: 50,
            //width: 100,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 40),
          Icon(
            CupertinoIcons.wifi_exclamationmark,
            color: Colors.orange[300],
            size: 150,
          ),
          Text(
            'No Internet Connection !',
            style: TextStyle(fontSize: 16, color: Colors.grey[800]),
          ),
          Text(
            'Connect your device with wifi or cellular data',
            style: TextStyle(fontSize: 15, color: Colors.grey[600]),
          ),
          SizedBox(height: 20),
          Text(
            "For emergency call 16263",
            style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () => _checkConnectivity(),
            splashColor: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Container(
                width: MediaQuery.of(context).size.width * .25,
                child: miniOutlineIconButton(
                    context, 'Refresh', Icons.refresh, Colors.grey)),
          )
        ],
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

  void _checkValidity(RegAuth regAuth,DoctorProvider operation) async{
    if (regAuth.doctorDetails.phone.isNotEmpty) {
      if (regAuth.doctorDetails.password.isNotEmpty) {
        regAuth.loadingMgs="Logging in...";
        showLoadingDialog(context, regAuth);

        //Firebase querySnapshot
        QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Doctors')
            .where('phone', isEqualTo: regAuth.doctorDetails.phone).get();
        final List<QueryDocumentSnapshot> user = snapshot.docs;
        if(user.isNotEmpty){
          if(user[0].get('password')==regAuth.doctorDetails.password){
            _OTPVerification(regAuth,operation);
          }
          else {
            Navigator.pop(context);
            showSnackBar(_scaffoldKey,"Incorrect password", Colors.deepOrange);
          }
        }else{
          Navigator.pop(context);
          showSnackBar(_scaffoldKey,"No doctor is registered with this phone" ,Colors.deepOrange);
        }
      }else
        showSnackBar(_scaffoldKey,"Password can't be empty", Colors.deepOrange);
    }else
      showSnackBar(_scaffoldKey,"Phone number can't be empty", Colors.deepOrange);
  }

  // ignore: non_constant_identifier_names
  void _OTPDialog(RegAuth regAuth){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          Size size=MediaQuery.of(context).size;
          return AlertDialog(
            scrollable: true,
            contentPadding: EdgeInsets.all(20),
            title: Text("Phone Verification", style:TextStyle(fontSize: size.width*.04), textAlign: TextAlign.center),
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
                        fillColor: Color(0xffF4F7F5),
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
                                //Save data to local
                                SharedPreferences pref = await SharedPreferences.getInstance();
                                pref.setString('id', regAuth.doctorDetails.countryCode+regAuth.doctorDetails.phone);

                                // if(pref.getStringList('likeId')==null)
                                // pref.setStringList('likeId', []);
                                //clear all list
                                operation.clearDoctorList();
                                operation.clearHospitalList();
                                operation.clearFaqList();
                                await operation.getDoctor().then((value)async{
                                  await operation.getHospitals();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  regAuth.doctorDetails=null;
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomePage()), (route) => false);
                                });
                              }else{
                                Navigator.pop(context);
                                Navigator.pop(context);
                                showSnackBar(_scaffoldKey,'Something went wrong. try again', Colors.deepOrange);
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

  // ignore: non_constant_identifier_names
  Future<void> _OTPVerification(RegAuth regAuth,DoctorProvider operation)async{
    FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.verifyPhoneNumber(
      phoneNumber: regAuth.doctorDetails.countryCode+regAuth.doctorDetails.phone,
      //Automatic verify....
      verificationCompleted: (PhoneAuthCredential credential) async{
        await _auth.signInWithCredential(credential).then((value) async{
          if(value.user!=null){
              //Save data to local
              SharedPreferences pref = await SharedPreferences.getInstance();
              pref.setString('id', regAuth.doctorDetails.countryCode+regAuth.doctorDetails.phone);

              if(pref.getStringList('likeId')==null)
                pref.setStringList('likeId', []);
              //clear all list
              operation.clearDoctorList();
              operation.clearHospitalList();
              operation.clearFaqList();
              await operation.getDoctor().then((value)async{
                await operation.getHospitals();
                Navigator.pop(context);
                regAuth.doctorDetails=null;
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomePage()), (route) => false);
              });

          }else{
            Navigator.pop(context);
            showSnackBar(_scaffoldKey,'Error verifying Doctor', Colors.deepOrange);
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
        _OTPDialog(regAuth);
        //_startTimer();
      },
      codeAutoRetrievalTimeout: (String verificationId){
        regAuth.verificationCode = verificationId;
        Navigator.pop(context);
        _OTPDialog(regAuth);
        //_startTimer();
      },
      timeout: Duration(seconds: 120),

    );
  }

}



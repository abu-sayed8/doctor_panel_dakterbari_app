import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doctor_panel/providers/doctor_provider.dart';
import 'package:doctor_panel/shared/form_decoration.dart';
import 'package:doctor_panel/pages/login_page.dart';
import 'package:doctor_panel/widgets/notification_widget.dart';
import 'package:doctor_panel/widgets/button_widgets.dart';

// ignore: must_be_immutable
class ResetPassword extends StatefulWidget {
  // String phone;
  //
  // NewPassword({this.phone});

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String new1;
  String new2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      backgroundColor: Color(0xffF4F7F5),
      body: _bodyUI(),
    );
  }

  Widget _bodyUI() {
    final DoctorProvider provider = Provider.of<DoctorProvider>(context);
    final Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 60),
          Container(
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
          ),
          SizedBox(height: 15),

          Text(
            'New Password',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            width: size.width,
            child: TextFormField(
              keyboardType: TextInputType.text,
              onChanged: (val) {
                setState(() => new1 = val);
              },
              decoration: FormDecoration.copyWith(
                labelText: 'Enter new Password',
                prefixIcon: null,
              ),
            ),
          ),
          SizedBox(height: 20),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            width: size.width,
            child: TextFormField(
              keyboardType: TextInputType.text,
              onChanged: (val) {
                setState(() {
                  new2 = val;
                  provider.doctorDetails.password = val;
                });
              },
              decoration: FormDecoration.copyWith(
                labelText: 'Re-enter new Password',
                prefixIcon: null,
              ),
            ),
          ),
          SizedBox(height: 20),

          //Continue Button...
          Consumer<DoctorProvider>(
            builder: (context, provider, child) {
              return Container(
                width: size.width * .90,
                child: GestureDetector(
                  onTap: () {
                    if (new1 == new2) {
                      provider.loadingMgs = 'Password updating...';
                      showLoadingDialog(context, provider);
                      provider.updateDoctorPassword(
                              provider.doctorDetails.countryCode+provider.doctorDetails.phone, provider, _scaffoldKey, context)
                          .then((value) {
                        Navigator.pop(context);
                        provider.doctorDetails = null;
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => LogIn()),
                            (route) => false);
                        showAlertDialog(context, 'Password changed successfully');
                      },onError: (error){
                        Navigator.pop(context);
                            showSnackBar(_scaffoldKey, error, Colors.deepOrange);
                      });
                    } else {
                      showSnackBar(_scaffoldKey, "Password not matched",Colors.deepOrange);
                    }
                  },
                  child: Button(context, "Reset Password"),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

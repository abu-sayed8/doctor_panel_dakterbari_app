import 'package:doctor_panel/utils/custom_clipper.dart';
import 'package:flutter/material.dart';
import 'package:doctor_panel/shared/form_decoration.dart';

class SupportCenter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF4F7F5),
      appBar: _customAppBar(context),
      body: _bodyUI(context),
    );
  }

  Widget _customAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(90),
      child: AppBar(
        title: Text(
          'Support Center',
          style: TextStyle(color: Colors.black,fontSize: MediaQuery.of(context).size.width*.048),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        flexibleSpace: ClipPath(
          clipper: MyCustomClipperForAppBar(),
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Color(0xffBCEDF2),
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              tileMode: TileMode.clamp,
            )),
          ),
        ),
      ),
    );
  }

  Widget _bodyUI(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      child: SingleChildScrollView(
        child: Column(
          children: [
            //Header...
            Container(
              height: size.height * .25,
              width: size.width,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[400],
                        offset: Offset(0, 2),
                        blurRadius: 2)
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Dakterbari Logo
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Image.asset('assets/logo_2.jpg'),
                    ),
                  ),
                  SizedBox(height: 8),
                  //Dakterbari Details
                  //Text("Dakterbari",style: TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.w900),),
                  Text(
                    "Chottogram, Bangladesh",
                    style: TextStyle(
                        fontSize: size.width*.048,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "www.dakterbari.com",
                    style: TextStyle(
                        fontSize: size.width*.048,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),

            //Body
            Container(
              height: size.height * .55,
              width: size.width,
              child: ListView(
                children: [
                  SizedBox(height: 20),
                  _contentBuilder(
                      context,
                      "Address",
                      "Bangladesh office",
                      "B-25, Manon Plaza, 4th floor, Newmarket",
                      "Chottogram, Bangladesh"),
                  SizedBox(height: 10),
                  _contentBuilder(
                      context,
                      "Contact Us",
                      "Customer Care :+8801830200087",
                      "Office Reception :+8801830200087",
                      "Support Email :support@dakterbari.com"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _contentBuilder(
    BuildContext context,
    String header,
    String sub1,
    String sub2,
    String sub3,
  ) {
    Size size=MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.all(8),
      decoration: cardDecoration,
      child: Column(
        children: [
          Text(
            header,
            style: TextStyle(
                fontSize: size.width*.058,
                color: Theme.of(context).primaryColorDark,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 5),
          Text(
            sub1,
            style: TextStyle(
                fontSize: size.width*.038,
                color: Colors.grey[800],
                fontWeight: FontWeight.w400),
          ),
          Text(
            sub2,
            style: TextStyle(
                fontSize: size.width*.038,
                color: Colors.grey[800],
                fontWeight: FontWeight.w300),
          ),
          Text(
            sub3,
            style: TextStyle(
                fontSize: size.width*.038,
                color: Colors.grey[800],
                fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }
}

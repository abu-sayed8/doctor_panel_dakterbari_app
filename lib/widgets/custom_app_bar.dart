import 'package:doctor_panel/utils/custom_clipper.dart';
import 'package:flutter/material.dart';

// ignore: missing_return
Widget customAppBarDesign(BuildContext context, String appBarName){
  Size size=MediaQuery.of(context).size;
  return PreferredSize(
    preferredSize: Size.fromHeight(90),
    child: AppBar(
      title: Text(appBarName,style: TextStyle(color: Colors.black,fontSize: size.width*.048),),
      centerTitle: true,
      backgroundColor: Colors.transparent,
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
              )
          ),
        ),
      ),
    ),
  );
}

import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget Button(BuildContext context, String ButtonName) {
  Size size = MediaQuery.of(context).size;
  return Material(
    elevation: 2,
    borderRadius: BorderRadius.all(Radius.circular(10)),
    child: Container(
      alignment: Alignment.center,
      height: size.width*.12,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Theme.of(context).primaryColor,
      ),
      child: Text(
        ButtonName,
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: size.width / 20),
      ),
    ),
  );
}

Widget outlineIconButton(
    BuildContext context, IconData iconData, String buttonName, Color color) {
  Size size = MediaQuery.of(context).size;
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
        border: Border.all(width: 2, color: color),
        borderRadius: BorderRadius.all(Radius.circular(10))),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          iconData,
          size: size.width*.04,
          color: color,
        ),
        SizedBox(width: 5),
        Text(
          buttonName,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: size.width*.035, color: color),
        )
      ],
    ),
  );
}

Widget bigOutlineIconButton(
    BuildContext context, IconData iconData, String buttonName, Color color) {
  Size size=MediaQuery.of(context).size;
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    decoration: BoxDecoration(
        border: Border.all(width: 2, color: color),
        borderRadius: BorderRadius.all(Radius.circular(10))),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          iconData,
          size: size.width*.042,
          color: color,
        ),
        SizedBox(width: 5),
        Text(
          buttonName,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: size.width*.04, color: color),
        )
      ],
    ),
  );
}

Widget miniOutlineButton(
    BuildContext context, String buttonName, Color color) {
  Size size = MediaQuery.of(context).size;
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
        border: Border.all(width: 1, color: color),
        borderRadius: BorderRadius.all(Radius.circular(10))),
    child: Text(
      buttonName,
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: size.width*.03, color: color),
    ),
  );
}

Widget miniOutlineIconButton(
    BuildContext context, String buttonName,  IconData iconData, Color color) {
  Size size = MediaQuery.of(context).size;
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
        border: Border.all(width: 1, color: color),
        borderRadius: BorderRadius.all(Radius.circular(10))),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(iconData,color: color,size: size.width*.04),
        SizedBox(width: 5),
        Text(
          buttonName,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: size.width*.03, color: color),
        ),
      ],
    ),
  );
}

Widget bigFillButton(BuildContext context, String buttonName, IconData iconData){
  Size size=MediaQuery
  .of(context).size;
  return Material(
    elevation: 2,
    borderRadius: BorderRadius.all(Radius.circular(10)),
    child: Container(
      // width: size.width,
      // height: size.width / 8,
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Theme.of(context).primaryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(iconData,color: Colors.white,size: size.width*.042,),
          SizedBox(width: 10),
          Text(
            buttonName,
            style: TextStyle(
                color: Colors.white,
                fontSize: size.width*.040,
                fontWeight: FontWeight.w500),
          )
        ],
      ),
    ),
  );
}
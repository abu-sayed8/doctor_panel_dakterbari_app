import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:doctor_panel/providers/doctor_provider.dart';
import 'package:doctor_panel/shared/form_decoration.dart';
import 'package:doctor_panel/widgets/custom_app_bar.dart';

class Notifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF4F7F5),
      resizeToAvoidBottomInset: false,
      //backgroundColor: Colors.white,
      appBar: customAppBarDesign(context, 'Notifications For You'),
      body: _bodyUI()
    );
  }

  Widget _bodyUI(){
    return Consumer<DoctorProvider>(
      builder: (context,drProvider, child){
        return RefreshIndicator(
          backgroundColor: Colors.white,
          onRefresh: ()=>drProvider.getNotification(),
          child:AnimationLimiter(
            child: ListView.builder(
              itemCount: drProvider.notificationList.length,
              itemBuilder: (context, index){
                return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                      verticalOffset: 400,
                      child: FadeInAnimation(
                        child: NotificationTile(
                            drProvider: drProvider,
                            index: index),
                      ),
                    )
                );
              },
            ),
          ),
        );
      },
    );
  }
}

// ignore: must_be_immutable
class NotificationTile extends StatelessWidget {
  int index;
  DoctorProvider drProvider;
  NotificationTile({this.drProvider,this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> _showFullNotification(context,drProvider.notificationList[index].title,
          drProvider.notificationList[index].message, drProvider.notificationList[index].date),
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        width: MediaQuery.of(context).size.width,
        decoration: simpleCardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(drProvider.notificationList[index].title??'',
                maxLines: 2,
                style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.grey[900])),
            SizedBox(height: 5),
            Text(drProvider.notificationList[index].message??'',
                maxLines: 4,
                style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Colors.grey[800])),
            Text(drProvider.notificationList[index].date??'',
                maxLines: 1,
                style: TextStyle(fontSize: 10,fontWeight: FontWeight.w400,color: Colors.grey[700])),
          ],
        ),
      ),
    );
  }

  void _showFullNotification(BuildContext context,String title, String message, String date){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context){
        return AlertDialog(
          scrollable: true,
          title: Text(title,textAlign: TextAlign.justify,),
          content: Text(message,textAlign: TextAlign.justify,),
          actions: [
            IconButton(icon: Icon(Icons.cancel_presentation_sharp), onPressed: ()=>Navigator.pop(context))
          ],
        );
      }
    );
  }
}


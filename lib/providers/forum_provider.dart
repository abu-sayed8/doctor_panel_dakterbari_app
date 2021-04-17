import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_panel/model/forum_ans_model.dart';
import 'package:doctor_panel/model/forum_model.dart';
import 'package:doctor_panel/providers/reg_auth_provider.dart';
import 'package:doctor_panel/providers/doctor_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:doctor_panel/widgets/notification_widget.dart';

class ForumProvider extends RegAuth {

  List<ForumModel> _allQuesList = List();
  List<ForumAnsModel> _answerList = List();

  get allQuesList=> _allQuesList;
  get answerList=> _answerList;

  void removeQuestionFromList(int index){
    _allQuesList.removeAt(index);
    notifyListeners();
  }

  Future<void> getAllQuestionList()async{
    try{
      await FirebaseFirestore.instance.collection('ForumQuestions').orderBy('timeStamp',descending: true).get().then((snapshot){
        _allQuesList.clear();
        snapshot.docChanges.forEach((element) {
          ForumModel forumModel = ForumModel(
            id: element.doc['id'],
            patientId: element.doc['patientId'],
            patientPhotoUrl: element.doc['patientPhotoUrl'],
            quesDate: element.doc['quesDate'],
            question: element.doc['question'],
            totalAns: element.doc['totalAns'],
          );
          _allQuesList.add(forumModel);
        });
      });
      notifyListeners();

    }catch(error){}
  }
  
  Future<void> getForumAnswer(String quesId)async{
      try{
        await FirebaseFirestore.instance.collection('ForumAnswers').where('quesId', isEqualTo: quesId).orderBy('timeStamp',descending: true).get().then((snapshot)async{
          _answerList.clear();
          snapshot.docChanges.forEach((element) {
            ForumAnsModel forumAnsModel = ForumAnsModel(
              id: element.doc['id'],
              quesId: element.doc['quesId'],
              drId: element.doc['drId'],
              drName: element.doc['drName'],
              drPhotoUrl: element.doc['drPhotoUrl'],
              drDegree: element.doc['drDegree'],
              answer: element.doc['answer'],
              ansDate: element.doc['ansDate'],
              timeStamp: element.doc['timeStamp'],
            );
            _answerList.add(forumAnsModel);
          });
        });
        notifyListeners();
      }catch(error){}
   
  }

  Future<void> submitForumAnswer(String quesId, String answer,String totalAns, int index, DoctorProvider drProvider, BuildContext context, GlobalKey<ScaffoldState> scaffoldKey)async{
    final String drId = await getPreferenceId();
    final int timeStamp = DateTime.now().millisecondsSinceEpoch;
    final String ansId = drId+timeStamp.toString();
    await FirebaseFirestore.instance.collection('ForumAnswers').doc(ansId).set({
     'id': ansId,
     'quesId': quesId,
     'drId': drId,
     'drName': drProvider.doctorList[0].fullName,
     'drPhotoUrl': drProvider.doctorList[0].photoUrl,
     'drDegree': drProvider.doctorList[0].degree,
     'answer': answer,
     'ansDate':  DateFormat("dd-MMM-yyyy").format(DateTime.fromMillisecondsSinceEpoch(timeStamp)).toString(),
     'timeStamp': timeStamp.toString(),
    }).then((value)async{
      await FirebaseFirestore.instance.collection('ForumQuestions').doc(quesId).update({
        'totalAns': totalAns==null? '1' :(int.parse(totalAns)+1).toString(),
      }).then((value){
        _allQuesList[index].totalAns = totalAns==null? '1' :(int.parse(totalAns)+1).toString();
        notifyListeners();

        Navigator.pop(context);
        showSnackBar(scaffoldKey, 'Answered successful', Theme.of(context).primaryColor);
      },onError: (error){
        Navigator.pop(context);
        showSnackBar(scaffoldKey, error.toString(), Colors.deepOrange);
      });
    },onError: (error){
      Navigator.pop(context);
      showSnackBar(scaffoldKey, error.toString(), Colors.deepOrange);
    });
  }

}
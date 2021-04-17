import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_panel/model/appointment_model.dart';
import 'package:doctor_panel/providers/doctor_provider.dart';
import 'package:doctor_panel/providers/reg_auth_provider.dart';
import 'package:doctor_panel/widgets/notification_widget.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentProvider extends RegAuth{
  AppointmentDetailsModel _prescriptionModel= AppointmentDetailsModel();

  List<String> _prescribedMedicineList = List<String>();

  List<AppointmentDetailsModel> _appointmentList = List<AppointmentDetailsModel>();
  List<AppointmentDetailsModel> _prescriptionList = List<AppointmentDetailsModel>();

  get prescribedMedicineList=> _prescribedMedicineList;

  get appointmentList => _appointmentList;

  get prescriptionList => _prescriptionList;

  void addMedicine(String value){
    _prescribedMedicineList.add(value);
    notifyListeners();
  }
  void clearPrescribedMedicineList(){
    _prescribedMedicineList.clear();
    notifyListeners();
  }

  get prescriptionModel=> _prescriptionModel;

  set prescriptionModel(AppointmentDetailsModel model){
    model= AppointmentDetailsModel();
    _prescriptionModel=model;
    notifyListeners();
  }


  Future<void> getAppointmentList()async{
    try{
      await getPreferenceId().then((docId)async{
        await FirebaseFirestore.instance.collection('AppointmentList').where('drId',isEqualTo: docId).orderBy('timeStamp',descending: true).get().then((snapshot){
          _appointmentList.clear();
          snapshot.docChanges.forEach((element) {
            if(element.doc['prescribeState']=='no'){
              AppointmentDetailsModel appointmentDetailsModel=AppointmentDetailsModel(
                id: element.doc['id'],
                drId: element.doc['drId'],
                drName: element.doc['drName'],
                drPhotoUrl: element.doc['drPhotoUrl'],
                drDegree: element.doc['drDegree'],
                drEmail: element.doc['drEmail'],
                drAddress: element.doc['drAddress'],
                specification: element.doc['specification'],
                appFee: element.doc['appFee'],
                teleFee: element.doc['teleFee'],
                currency: element.doc['currency'],
                prescribeDate: element.doc['prescribeDate'],
                prescribeState: element.doc['prescribeState'],
                pId: element.doc['pId'],
                pName: element.doc['pName'],
                pPhotoUrl: element.doc['pPhotoUrl'],
                pAddress: element.doc['pAddress'],
                pAge: element.doc['pAge'],
                pGender: element.doc['pGender'],
                pProblem: element.doc['pProblem'],
                actualProblem: element.doc['actualProblem'],
                bookingDate: element.doc['bookingDate'],
                appointDate: element.doc['appointDate'],
                chamberName: element.doc['chamberName'],
                chamberAddress: element.doc['chamberAddress'],
                bookingSchedule: element.doc['bookingSchedule'],
                rx: element.doc['rx'],
                advice: element.doc['advice'],
                nextVisit: element.doc['nextVisit'],
                appointState: element.doc['appointState'],
                medicines: element.doc['medicines'],
                timeStamp: element.doc['timeStamp'],
              );
              _appointmentList.add(appointmentDetailsModel);
            }
          });
        });
      });
      notifyListeners();
      print(_appointmentList.length);
    }catch(error){}
  }

  Future<void> getPrescriptionList()async{
    try{
      await getPreferenceId().then((docId)async{
        await FirebaseFirestore.instance.collection('AppointmentList').where('drId',isEqualTo: docId).orderBy('timeStamp',descending: true).get().then((snapshot){
          _prescriptionList.clear();
          snapshot.docChanges.forEach((element) {
            if(element.doc['prescribeState']=='yes'){
              AppointmentDetailsModel appointmentDetailsModel=AppointmentDetailsModel(
                id: element.doc['id'],
                drId: element.doc['drId'],
                drName: element.doc['drName'],
                drPhotoUrl: element.doc['drPhotoUrl'],
                drDegree: element.doc['drDegree'],
                drEmail: element.doc['drEmail'],
                drAddress: element.doc['drAddress'],
                specification: element.doc['specification'],
                appFee: element.doc['appFee'],
                teleFee: element.doc['teleFee'],
                currency: element.doc['currency'],
                prescribeDate: element.doc['prescribeDate'],
                prescribeState: element.doc['prescribeState'],
                pId: element.doc['pId'],
                pName: element.doc['pName'],
                pPhotoUrl: element.doc['pPhotoUrl'],
                pAddress: element.doc['pAddress'],
                pAge: element.doc['pAge'],
                pGender: element.doc['pGender'],
                pProblem: element.doc['pProblem'],
                bookingDate: element.doc['bookingDate'],
                appointDate: element.doc['appointDate'],
                chamberName: element.doc['chamberName'],
                chamberAddress: element.doc['chamberAddress'],
                bookingSchedule: element.doc['bookingSchedule'],
                actualProblem: element.doc['actualProblem'],
                rx: element.doc['rx'],
                advice: element.doc['advice'],
                nextVisit: element.doc['nextVisit'],
                appointState: element.doc['appointState'],
                medicines: element.doc['medicines'],
                prescribeNo: element.doc['prescribeNo'],
                timeStamp: element.doc['timeStamp'],
              );
              _prescriptionList.add(appointmentDetailsModel);
            }
          });
        });
      });
      notifyListeners();
    }catch(error){}
  }

  Future<void> confirmPrescribe(AppointmentProvider appProvider, DoctorProvider drProvider, String docId, String appId, BuildContext context, GlobalKey<ScaffoldState> scaffoldKey)async{
    String currentDate = DateFormat("dd-MMM-yyyy").format(DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch)).toString();
    await FirebaseFirestore.instance.collection('AppointmentList').doc(appId).update({
      'prescribeState': 'yes',
      'prescribeDate': currentDate,
      'actualProblem':appProvider.prescriptionModel.actualProblem==''? null :appProvider.prescriptionModel.actualProblem,
      'rx': appProvider.prescriptionModel.rx==''? null :appProvider.prescriptionModel.rx,
      'advice': appProvider.prescriptionModel.advice==''? null :appProvider.prescriptionModel.advice,
      'nextVisit': appProvider.prescriptionModel.nextVisit==''? null :appProvider.prescriptionModel.nextVisit,
      'medicines': appProvider.prescribedMedicineList,
      'prescribeNo': drProvider.doctorList[0].totalPrescribe==null? '1': (int.parse(drProvider.doctorList[0].totalPrescribe)+1).toString()
    }).then((value)async{
      await FirebaseFirestore.instance.collection('Doctors').doc(docId).update({
        'totalPrescribe': drProvider.doctorList[0].totalPrescribe==null? '1': (int.parse(drProvider.doctorList[0].totalPrescribe)+1).toString()
      }).then((value)async{

        drProvider.doctorList[0].totalPrescribe = drProvider.doctorList[0].totalPrescribe==null? '1':
        (int.parse(drProvider.doctorList[0].totalPrescribe)+1).toString();

        //Update Appointment list...
        await appProvider.getAppointmentList();

        Navigator.pop(context);
        Navigator.pop(context);
        showAlertDialog(context, 'Prescription successful');
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
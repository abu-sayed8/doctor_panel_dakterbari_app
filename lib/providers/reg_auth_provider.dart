import 'package:doctor_panel/model/doctor_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class RegAuth extends ChangeNotifier{

  DoctorDetailsModel _doctorDetails= DoctorDetailsModel();
  bool _agreeChk = false;
  bool _obscure = true;
  String _loadingMgs;
  String _verificationCode;

  get doctorDetails=>_doctorDetails;
  get agreeChk=>_agreeChk;
  get obscure=>_obscure;
  get loadingMgs=>_loadingMgs;
  get verificationCode=>_verificationCode;

  set doctorDetails(DoctorDetailsModel model){
    model =  DoctorDetailsModel();
    _doctorDetails = model;
    notifyListeners();
  }
  set agreeChk(bool val){
    _agreeChk = val;
    notifyListeners();
  }
  set obscure(bool val){
    _obscure = val;
    notifyListeners();
  }
  set loadingMgs(String val){
    _loadingMgs = val;
    notifyListeners();
  }
  set verificationCode(String val){
    _verificationCode = val;
    notifyListeners();
  }

  Future<String> getPreferenceId()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('id');
  }

  Future<bool> isDoctorRegistered(String id)async{
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Doctors')
        .where('id', isEqualTo: id).get();
    final List<QueryDocumentSnapshot> user = snapshot.docs;
    if(user.isEmpty){
      return false;
    }else{
      return true;
    }
  }

  Future<bool> isPatientRegistered(String id)async{
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Patients')
        .where('id', isEqualTo: id).get();
    final List<QueryDocumentSnapshot> user = snapshot.docs;
    if(user.isEmpty){
      return false;
    }else{
      return true;
    }
  }

  Future<bool> registerUser(DoctorDetailsModel doctorDetails)async{
    try{
      String date = DateFormat("dd-MMM-yyyy/hh:mm:aa").format(DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch));

      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString('id', doctorDetails.countryCode+doctorDetails.phone);
      await preferences.setString('pass', doctorDetails.password);
      final String id=doctorDetails.countryCode+doctorDetails.phone.trim();

      if(doctorDetails.provideTeleService){
        await FirebaseFirestore.instance.collection('Doctors').doc(id).set({
          'id': id,
          'name': doctorDetails.fullName,
          'phone': doctorDetails.phone,
          'password': doctorDetails.password,
          'email': doctorDetails.email,
          'about': doctorDetails.about,
          'country': doctorDetails.country,
          'state': doctorDetails.state,
          'city': doctorDetails.city,
          'joinDate': date,
          'gender': doctorDetails.gender,
          'specification': doctorDetails.specification,
          'optionalSpecification': null,
          'degree': doctorDetails.degree,
          'bmdcNumber': doctorDetails.bmdcNumber,
          'currency':doctorDetails.currency,
          'appFee': doctorDetails.appFee,
          'teleFee': doctorDetails.teleFee,
          'experience': null,
          'photoUrl': doctorDetails.photoUrl,
          'totalPrescribe': null,
          'countryCode': doctorDetails.countryCode,
          'provideTeleService': doctorDetails.provideTeleService,
          'totalTeleFee':null,
          'teleSat': !doctorDetails.sat[0]? null: ['${doctorDetails.sat[1].hour}:${doctorDetails.sat[1].minute}','${doctorDetails.sat[2].hour}:${doctorDetails.sat[2].minute}'],
          'teleSun': !doctorDetails.sun[0]? null: ['${doctorDetails.sun[1].hour}:${doctorDetails.sun[1].minute}','${doctorDetails.sun[2].hour}:${doctorDetails.sun[2].minute}'],
          'teleMon': !doctorDetails.mon[0]? null: ['${doctorDetails.mon[1].hour}:${doctorDetails.mon[1].minute}','${doctorDetails.mon[2].hour}:${doctorDetails.mon[2].minute}'],
          'teleTue': !doctorDetails.tue[0]? null: ['${doctorDetails.tue[1].hour}:${doctorDetails.tue[1].minute}','${doctorDetails.tue[2].hour}:${doctorDetails.tue[2].minute}'],
          'teleWed': !doctorDetails.wed[0]? null: ['${doctorDetails.wed[1].hour}:${doctorDetails.wed[1].minute}','${doctorDetails.wed[2].hour}:${doctorDetails.wed[2].minute}'],
          'teleThu': !doctorDetails.thu[0]? null: ['${doctorDetails.thu[1].hour}:${doctorDetails.thu[1].minute}','${doctorDetails.thu[2].hour}:${doctorDetails.thu[2].minute}'],
          'teleFri': !doctorDetails.fri[0]? null: ['${doctorDetails.fri[1].hour}:${doctorDetails.fri[1].minute}','${doctorDetails.fri[2].hour}:${doctorDetails.fri[2].minute}'],
        });
        return true;
      }else{
        await FirebaseFirestore.instance.collection('Doctors').doc(id).set({
          'id': id,
          'name': doctorDetails.fullName,
          'phone': doctorDetails.phone,
          'password': doctorDetails.password,
          'email': doctorDetails.email,
          'about': doctorDetails.about,
          'country': doctorDetails.country,
          'state': doctorDetails.state,
          'city': doctorDetails.city,
          'joinDate': date,
          'gender': doctorDetails.gender,
          'specification': doctorDetails.specification,
          'optionalSpecification': null,
          'degree': doctorDetails.degree,
          'bmdcNumber': doctorDetails.bmdcNumber,
          'currency':doctorDetails.currency,
          'appFee': doctorDetails.appFee,
          'teleFee': doctorDetails.teleFee,
          'experience': null,
          'photoUrl': doctorDetails.photoUrl,
          'totalPrescribe': null,
          'countryCode': doctorDetails.countryCode,
          'provideTeleService': doctorDetails.provideTeleService,
          'totalTeleFee':null,
          'teleSat': null,
          'teleSun': null,
          'teleMon': null,
          'teleTue': null,
          'teleWed': null,
          'teleThu': null,
          'teleFri': null,
        });
        return true;
      }
    }catch(e){
      return false;
    }
  }
}
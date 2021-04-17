import 'dart:io';
import 'package:doctor_panel/model/doctor_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_panel/model/faq_model.dart';
import 'package:doctor_panel/model/hospital_model.dart';
import 'package:doctor_panel/providers/reg_auth_provider.dart';
import 'package:doctor_panel/widgets/notification_widget.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:doctor_panel/model/notification_model.dart';


class DoctorProvider extends RegAuth{
   List<DoctorDetailsModel> _doctorList=List<DoctorDetailsModel>();
   List<HospitalModel> _hospitalList = List<HospitalModel>();
   List<FaqModel> _faqList = List<FaqModel>();
   List<NotificationModel> _notificationList = List<NotificationModel>();

   HospitalModel _hospitalModel = HospitalModel();
   FaqModel _faqModel = FaqModel();

   get doctorList=> _doctorList;
   get hospitalModel=> _hospitalModel;
   get hospitalList=> _hospitalList;
   get faqModel=> _faqModel;
   get faqList=> _faqList;
   get notificationList=> _notificationList;

   set hospitalModel(HospitalModel model){
      model = HospitalModel();
      _hospitalModel = model;
      notifyListeners();
   }
   set faqModel(FaqModel model){
      model = FaqModel();
      _faqModel = model;
      notifyListeners();
   }
   void clearDoctorList(){
      _doctorList.clear();
      notifyListeners();
   }
   void clearHospitalList(){
      _hospitalList.clear();
      notifyListeners();
   }
   void clearFaqList(){
      _faqList.clear();
      notifyListeners();
   }

   // void clearDoctorList(){
   //     _doctorList.clear();
   //    //notifyListeners();
   // }

   // Future<void> getDoctorSnap(String id)async{
   //    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Doctors')
   //        .where('id', isEqualTo: id).get();
   //    final List<QueryDocumentSnapshot> doctor = snapshot.docs;
   //    if(doctor.isNotEmpty){
   //       DoctorDetailsModel doctors=DoctorDetailsModel(
   //          id: doctor[0].get('id'),
   //          about: doctor[0].get('about'),
   //          address: doctor[0].get('address'),
   //          appFee: doctor[0].get('appFee'),
   //          blogIdList: doctor[0].get('blogIdList'),
   //          bmdcNumber: doctor[0].get('bmdcNumber'),
   //          countryCode: doctor[0].get('countryCode'),
   //          degree: doctor[0].get('degree'),
   //          email: doctor[0].get('email'),
   //          experience: doctor[0].get('experience'),
   //          faqList: doctor[0].get('faq'),
   //          gender: doctor[0].get('gender'),
   //          joinDate: doctor[0].get('joinDate'),
   //          fullName: doctor[0].get('name'),
   //          password: doctor[0].get('password'),
   //          phone: doctor[0].get('phone'),
   //          photoUrl: doctor[0].get('photoUrl'),
   //          provideTeleService: doctor[0].get('provideTeleService'),
   //          providedService: doctor[0].get('providedService'),
   //          serviceAtList: doctor[0].get('serviceAt'),
   //          teleFee: doctor[0].get('teleFee'),
   //          totalPrescribe: doctor[0].get('totalPrescribe'),
   //       );
   //       _doctorList.add(doctors);
   //       notifyListeners();
   //       isLoading = false;
   //       loadingMgs = '';
   //    }
   //    else{
   //       isLoading = false;
   //       loadingMgs = '';
   //    }
   // }
   Future<void> getDoctor()async{
      final id = await getPreferenceId();
      try{
         await FirebaseFirestore.instance.collection('Doctors').where('id', isEqualTo: id).get().then((snapShot){
            _doctorList.clear();
            snapShot.docChanges.forEach((element) {
               DoctorDetailsModel doctors=DoctorDetailsModel(
                  id: element.doc['id'],
                  about: element.doc['about'],
                  appFee: element.doc['appFee'],
                  bmdcNumber: element.doc['bmdcNumber'],
                  countryCode: element.doc['countryCode'],
                  degree: element.doc['degree'],
                  email: element.doc['email'],
                  experience: element.doc['experience'],
                  gender: element.doc['gender'],
                  joinDate: element.doc['joinDate'],
                  fullName: element.doc['name'],
                  password: element.doc['password'],
                  phone: element.doc['phone'],
                  photoUrl: element.doc['photoUrl'],
                  provideTeleService: element.doc['provideTeleService'],
                  specification: element.doc['specification'],
                  teleFee: element.doc['teleFee'],
                  totalPrescribe: element.doc['totalPrescribe'],
                  totalTeleFee: element.doc['totalTeleFee'],
                  country: element.doc['country'],
                  currency: element.doc['currency'],
                  state: element.doc['state'],
                  city: element.doc['city'],
                  optionalSpecification: element.doc['optionalSpecification'],
                  sat: element.doc['teleSat'],
                  sun: element.doc['teleSun'],
                  mon: element.doc['teleMon'],
                  tue: element.doc['teleTue'],
                  wed: element.doc['teleWed'],
                  thu: element.doc['teleThu'],
                  fri: element.doc['teleFri'],
               );
               _doctorList.add(doctors);
            });
         });
         notifyListeners();
         print( _doctorList[0].fullName);
      }catch(error){}
   }

   Future<void> updateDoctorSpecifications(DoctorProvider operation,List<dynamic> specificationList,BuildContext context,GlobalKey<ScaffoldState> scaffoldKey)async{
      final doctorId= await operation.getPreferenceId();
      await FirebaseFirestore.instance.collection('Doctors').doc(doctorId).update({
         'optionalSpecification': specificationList
      }).then((value){
         operation.doctorList[0].optionalSpecification = specificationList;
         notifyListeners();
         Navigator.pop(context);
         Navigator.pop(context);
         showSnackBar(scaffoldKey,'Specification successfully added',Theme.of(context).primaryColor);
      },onError: (error){
         Navigator.pop(context);
         Navigator.pop(context);
         showSnackBar(scaffoldKey,error.toString(),Colors.deepOrange);
      });
   }

   Future<void> removeDoctorSpecifications(DoctorProvider operation,BuildContext context,GlobalKey<ScaffoldState> scaffoldKey)async{
      final doctorId= await operation.getPreferenceId();
      await FirebaseFirestore.instance.collection('Doctors').doc(doctorId).update({
         'optionalSpecification': null
      }).then((value){
         operation.doctorList[0].optionalSpecification = null;
         notifyListeners();
         Navigator.pop(context);
         showSnackBar(scaffoldKey,'Specification successfully removed',Theme.of(context).primaryColor);
      },onError: (error){
         Navigator.pop(context);
         showSnackBar(scaffoldKey,error.toString(),Colors.deepOrange);
      });
   }

   Future<void> getHospitals()async{
      final id = await getPreferenceId();
      try{
         await FirebaseFirestore.instance.collection('Hospitals').where('doctorId', isEqualTo: id).get().then((snapShot){
            _hospitalList.clear();
            snapShot.docChanges.forEach((element) {
               HospitalModel hospitals = HospitalModel(
                  id: element.doc['id'],
                  doctorId: element.doc['doctorId'],
                  hospitalName: element.doc['hospitalName'],
                  hospitalAddress: element.doc['hospitalAddress'],
                  addingDate: element.doc['addingDate'],
                  sat: element.doc['sat'],
                  sun: element.doc['sun'],
                  mon: element.doc['mon'],
                  tue: element.doc['tue'],
                  wed: element.doc['wed'],
                  thu: element.doc['thu'],
                  fri: element.doc['fri'],
               );
               _hospitalList.add(hospitals);
            });
         });
         notifyListeners();
      }catch(error){}
   }

   Future<void> insertHospital(DoctorProvider operation, BuildContext context,GlobalKey<ScaffoldState> scaffoldKey)async{
      final String doctorId= await getPreferenceId();
      final String hospitalId= doctorId+DateTime.now().millisecondsSinceEpoch.toString();
      final String addingDate= DateFormat("dd-MMM-yyyy/hh:mm:aa").format(DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch));
      await FirebaseFirestore.instance.collection('Hospitals').doc(hospitalId).set({
         'id': hospitalId,
         'doctorId': doctorId,
         'addingDate': addingDate,
         'hospitalName': operation.hospitalModel.hospitalName,
         'hospitalAddress': operation.hospitalModel.hospitalAddress,
         'sat': !operation.hospitalModel.sat[0]? null: ['${operation.hospitalModel.sat[1].hour}:${operation.hospitalModel.sat[1].minute}','${operation.hospitalModel.sat[2].hour}:${operation.hospitalModel.sat[2].minute}'],
         'sun': !operation.hospitalModel.sun[0]? null: ['${operation.hospitalModel.sun[1].hour}:${operation.hospitalModel.sun[1].minute}','${operation.hospitalModel.sun[2].hour}:${operation.hospitalModel.sun[2].minute}'],
         'mon': !operation.hospitalModel.mon[0]? null: ['${operation.hospitalModel.mon[1].hour}:${operation.hospitalModel.mon[1].minute}','${operation.hospitalModel.mon[2].hour}:${operation.hospitalModel.mon[2].minute}'],
         'tue': !operation.hospitalModel.tue[0]? null: ['${operation.hospitalModel.tue[1].hour}:${operation.hospitalModel.tue[1].minute}','${operation.hospitalModel.tue[2].hour}:${operation.hospitalModel.tue[2].minute}'],
         'wed': !operation.hospitalModel.wed[0]? null: ['${operation.hospitalModel.wed[1].hour}:${operation.hospitalModel.wed[1].minute}','${operation.hospitalModel.wed[2].hour}:${operation.hospitalModel.wed[2].minute}'],
         'thu': !operation.hospitalModel.thu[0]? null: ['${operation.hospitalModel.thu[1].hour}:${operation.hospitalModel.thu[1].minute}','${operation.hospitalModel.thu[2].hour}:${operation.hospitalModel.thu[2].minute}'],
         'fri': !operation.hospitalModel.fri[0]? null: ['${operation.hospitalModel.fri[1].hour}:${operation.hospitalModel.fri[1].minute}','${operation.hospitalModel.fri[2].hour}:${operation.hospitalModel.fri[2].minute}'],
      }).then((value)async{
         await operation.getHospitals();
         //Close loading dialog
         Navigator.pop(context);
         Navigator.pop(context);
         showAlertDialog(context, 'Hospital/chamber successfully added');
      },onError: (error){
         Navigator.pop(context);
         showAlertDialog(context, error.toString());
      });
   }

   void removeHospitalFromList(int index){
      _hospitalList.removeAt(index);
      notifyListeners();
   }

   Future<void> removeHospitalFromDB(BuildContext context, String id, int index)async{
      await FirebaseFirestore.instance.collection('Hospitals').doc(id).delete().then((value){
         removeHospitalFromList(index);
         Navigator.pop(context);
      },onError: (error){
         Navigator.pop(context);
         showAlertDialog(context, error.toString());
      });
   }

   Future<void> updateDoctorProfilePhoto(GlobalKey<ScaffoldState> scaffoldKey, BuildContext context, DoctorProvider operation, File imageFile)async{
      final id = await getPreferenceId();
      firebase_storage.Reference storageReference =
      firebase_storage.FirebaseStorage.instance.ref().child('Doctors Photo').child(id);

      firebase_storage.UploadTask storageUploadTask = storageReference.putFile(imageFile);

      firebase_storage.TaskSnapshot taskSnapshot;
      storageUploadTask.then((value) {
         taskSnapshot = value;
         taskSnapshot.ref.getDownloadURL().then((newImageDownloadUrl){
            final photoUrl = newImageDownloadUrl;
            FirebaseFirestore.instance.collection('Doctors').doc(id).update({
               'photoUrl':photoUrl,
            }).then((value)async{
               await operation.getDoctor();
               Navigator.pop(context);
               showSnackBar(scaffoldKey, 'Profile photo updated',Theme.of(context).primaryColor);
            });
         },onError: (error){
            Navigator.pop(context);
            showSnackBar(scaffoldKey, error.toString(), Colors.deepOrange);
         });
      },onError: (error){
         Navigator.pop(context);
         showSnackBar(scaffoldKey, error.toString(), Colors.deepOrange);
      });

   }

   Future<void> updateDoctorInformation(DoctorProvider operation,GlobalKey<ScaffoldState> scaffoldKey,BuildContext context)async{
      await FirebaseFirestore.instance.collection('Doctors').doc(operation.doctorList[0].id).update({
         'name':operation.doctorDetails.fullName.isEmpty? operation.doctorList[0].fullName :operation.doctorDetails.fullName,
         'email':operation.doctorDetails.email.isEmpty? operation.doctorList[0].email :operation.doctorDetails.email,
         'about':operation.doctorDetails.about.isEmpty? operation.doctorList[0].about :operation.doctorDetails.about,
         'country':operation.doctorDetails.country.isEmpty? operation.doctorList[0].country :operation.doctorDetails.country,
         'state':operation.doctorDetails.state.isEmpty? operation.doctorList[0].state :operation.doctorDetails.state,
         'city':operation.doctorDetails.city.isEmpty? operation.doctorList[0].city :operation.doctorDetails.city,
         'experience':operation.doctorDetails.experience.isEmpty? operation.doctorList[0].experience :operation.doctorDetails.experience,
         'appFee':operation.doctorDetails.appFee.isEmpty? operation.doctorList[0].appFee :operation.doctorDetails.appFee,
         'teleFee':operation.doctorDetails.teleFee.isEmpty? null :operation.doctorDetails.teleFee,
         'degree':operation.doctorDetails.degree.isEmpty? null :operation.doctorDetails.degree,
      }).then((value)async{
         operation.doctorList[0].fullName= operation.doctorDetails.fullName.isEmpty? operation.doctorList[0].fullName :operation.doctorDetails.fullName;
         operation.doctorList[0].email= operation.doctorDetails.email.isEmpty? operation.doctorList[0].email :operation.doctorDetails.email;
         operation.doctorList[0].about= operation.doctorDetails.about.isEmpty? operation.doctorList[0].about :operation.doctorDetails.about;
         operation.doctorList[0].country= operation.doctorDetails.country.isEmpty? operation.doctorList[0].country :operation.doctorDetails.country;
         operation.doctorList[0].state= operation.doctorDetails.state.isEmpty? operation.doctorList[0].state :operation.doctorDetails.state;
         operation.doctorList[0].city= operation.doctorDetails.city.isEmpty? operation.doctorList[0].city :operation.doctorDetails.city;
         operation.doctorList[0].experience= operation.doctorDetails.experience.isEmpty? operation.doctorList[0].experience :operation.doctorDetails.experience;
         operation.doctorList[0].appFee= operation.doctorDetails.appFee.isEmpty? operation.doctorList[0].appFee :operation.doctorDetails.appFee;
         operation.doctorList[0].degree= operation.doctorDetails.degree.isEmpty? operation.doctorList[0].degree :operation.doctorDetails.degree;
         operation.doctorList[0].teleFee= operation.doctorDetails.teleFee.isEmpty? null :operation.doctorDetails.teleFee;
         notifyListeners();
         Navigator.pop(context);
         showSnackBar(scaffoldKey,'Updated successful',Theme.of(context).primaryColor);

      },onError: (error){
         Navigator.pop(context);
         showSnackBar(scaffoldKey,error.toString(), Colors.deepOrange);
      });
   }

   Future<void> getFaq() async{
      final id = await getPreferenceId();
      try{
         await FirebaseFirestore.instance.collection('FAQ').where('id', isEqualTo: id).get().then((snapshot){
            _faqList.clear();
            snapshot.docChanges.forEach((element) {
               FaqModel faqModel = FaqModel(
                  id: element.doc['id'],
                  one: element.doc['one'],
                  two: element.doc['two'],
                  three: element.doc['three'],
                  four: element.doc['four'],
                  five: element.doc['five'],
                  six: element.doc['six'],
                  seven: element.doc['seven'],
                  eight: element.doc['eight'],
                  nine: element.doc['nine'],
                  ten: element.doc['ten'],
               );
               _faqList.add(faqModel);
            });
         });
         notifyListeners();
         print('faq get');
      }catch(error){}
   }

   Future<void> updateFaq(DoctorProvider operation, GlobalKey<ScaffoldState> scaffoldKey, BuildContext context)async{
      final id = await operation.getPreferenceId();
      ///Insert operation
      if(operation.faqList.isEmpty){
         await FirebaseFirestore.instance.collection('FAQ').doc(id).set({
            'id': id,
            'one':operation.faqModel.one,
            'two':operation.faqModel.two,
            'three':operation.faqModel.three,
            'four':operation.faqModel.four,
            'five':operation.faqModel.five,
            'six':operation.faqModel.six,
            'seven':operation.faqModel.seven,
            'eight':operation.faqModel.eight,
            'nine':operation.faqModel.nine,
            'ten':operation.faqModel.ten,
         }).then((value){
            operation.getFaq();
            Navigator.pop(context);
            Navigator.pop(context);
            showAlertDialog(context, 'FAQ update successful');
         },onError: (error){
            Navigator.pop(context);
            showSnackBar(scaffoldKey, error.toString(), Colors.deepOrange);
         });

      }
      ///Update operation
      else{
         await FirebaseFirestore.instance.collection('FAQ').doc(id).update({
            'one':operation.faqModel.one.isNotEmpty?operation.faqModel.one:operation.faqList[0].one,
            'two':operation.faqModel.two.isNotEmpty?operation.faqModel.two:operation.faqList[0].two,
            'three':operation.faqModel.three.isNotEmpty?operation.faqModel.three:operation.faqList[0].three,
            'four':operation.faqModel.four.isNotEmpty?operation.faqModel.four:operation.faqList[0].four,
            'five':operation.faqModel.five.isNotEmpty?operation.faqModel.five:operation.faqList[0].five,
            'six':operation.faqModel.six.isNotEmpty?operation.faqModel.six:operation.faqList[0].six,
            'seven':operation.faqModel.seven.isNotEmpty?operation.faqModel.seven:operation.faqList[0].seven,
            'eight':operation.faqModel.eight.isNotEmpty?operation.faqModel.eight:operation.faqList[0].eight,
            'nine':operation.faqModel.nine.isNotEmpty?operation.faqModel.nine:operation.faqList[0].nine,
            'ten':operation.faqModel.ten.isNotEmpty?operation.faqModel.ten:operation.faqList[0].ten,
         }).then((value){
            operation.getFaq();
            Navigator.pop(context);
            Navigator.pop(context);
            showAlertDialog(context, 'FAQ update successful');
         },onError: (error){
            Navigator.pop(context);
            showSnackBar(scaffoldKey, error.toString(), Colors.deepOrange);
         });
      }
   }

   Future<void> updateTeleSchedule(DoctorProvider operation, BuildContext context,GlobalKey<ScaffoldState> scaffoldKey)async{
      final String doctorId= await getPreferenceId();
      bool provideTele=false;
      if(operation.hospitalModel.sat[0]||operation.hospitalModel.sun[0]||operation.hospitalModel.mon[0]||operation.hospitalModel.tue[0]||
          operation.hospitalModel.wed[0]||operation.hospitalModel.thu[0]||operation.hospitalModel.fri[0]) provideTele=true;

      await FirebaseFirestore.instance.collection('Doctors').doc(doctorId).update({
         'provideTeleService':provideTele,
         'teleSat': !operation.hospitalModel.sat[0]? null: ['${operation.hospitalModel.sat[1].hour}:${operation.hospitalModel.sat[1].minute}','${operation.hospitalModel.sat[2].hour}:${operation.hospitalModel.sat[2].minute}'],
         'teleSun': !operation.hospitalModel.sun[0]? null: ['${operation.hospitalModel.sun[1].hour}:${operation.hospitalModel.sun[1].minute}','${operation.hospitalModel.sun[2].hour}:${operation.hospitalModel.sun[2].minute}'],
         'teleMon': !operation.hospitalModel.mon[0]? null: ['${operation.hospitalModel.mon[1].hour}:${operation.hospitalModel.mon[1].minute}','${operation.hospitalModel.mon[2].hour}:${operation.hospitalModel.mon[2].minute}'],
         'teleTue': !operation.hospitalModel.tue[0]? null: ['${operation.hospitalModel.tue[1].hour}:${operation.hospitalModel.tue[1].minute}','${operation.hospitalModel.tue[2].hour}:${operation.hospitalModel.tue[2].minute}'],
         'teleWed': !operation.hospitalModel.wed[0]? null: ['${operation.hospitalModel.wed[1].hour}:${operation.hospitalModel.wed[1].minute}','${operation.hospitalModel.wed[2].hour}:${operation.hospitalModel.wed[2].minute}'],
         'teleThu': !operation.hospitalModel.thu[0]? null: ['${operation.hospitalModel.thu[1].hour}:${operation.hospitalModel.thu[1].minute}','${operation.hospitalModel.thu[2].hour}:${operation.hospitalModel.thu[2].minute}'],
         'teleFri': !operation.hospitalModel.fri[0]? null: ['${operation.hospitalModel.fri[1].hour}:${operation.hospitalModel.fri[1].minute}','${operation.hospitalModel.fri[2].hour}:${operation.hospitalModel.fri[2].minute}'],
      }).then((value){
         operation.doctorList[0].provideTeleService= provideTele;
         operation.doctorList[0].sat= !operation.hospitalModel.sat[0]? null: ['${operation.hospitalModel.sat[1].hour}:${operation.hospitalModel.sat[1].minute}','${operation.hospitalModel.sat[2].hour}:${operation.hospitalModel.sat[2].minute}'];
         operation.doctorList[0].sun= !operation.hospitalModel.sun[0]? null: ['${operation.hospitalModel.sun[1].hour}:${operation.hospitalModel.sun[1].minute}','${operation.hospitalModel.sun[2].hour}:${operation.hospitalModel.sun[2].minute}'];
         operation.doctorList[0].mon= !operation.hospitalModel.mon[0]? null: ['${operation.hospitalModel.mon[1].hour}:${operation.hospitalModel.mon[1].minute}','${operation.hospitalModel.mon[2].hour}:${operation.hospitalModel.mon[2].minute}'];
         operation.doctorList[0].tue= !operation.hospitalModel.tue[0]? null: ['${operation.hospitalModel.tue[1].hour}:${operation.hospitalModel.tue[1].minute}','${operation.hospitalModel.tue[2].hour}:${operation.hospitalModel.tue[2].minute}'];
         operation.doctorList[0].wed= !operation.hospitalModel.wed[0]? null: ['${operation.hospitalModel.wed[1].hour}:${operation.hospitalModel.wed[1].minute}','${operation.hospitalModel.wed[2].hour}:${operation.hospitalModel.wed[2].minute}'];
         operation.doctorList[0].thu= !operation.hospitalModel.thu[0]? null: ['${operation.hospitalModel.thu[1].hour}:${operation.hospitalModel.thu[1].minute}','${operation.hospitalModel.thu[2].hour}:${operation.hospitalModel.thu[2].minute}'];
         operation.doctorList[0].fri= !operation.hospitalModel.fri[0]? null: ['${operation.hospitalModel.fri[1].hour}:${operation.hospitalModel.fri[1].minute}','${operation.hospitalModel.fri[2].hour}:${operation.hospitalModel.fri[2].minute}'];
         notifyListeners();
         Navigator.pop(context);
         Navigator.pop(context);
         showAlertDialog(context, 'Telemedicine service successfully updated');
      },onError: (error){
         Navigator.pop(context);
         showAlertDialog(context, error.toString());
      });
   }

   Future<void> sendMessageToAdmin(BuildContext context,GlobalKey<ScaffoldState> scaffoldKey,String name,String email,String message)async{
      final String drId = await getPreferenceId();
      final int timeStamp = DateTime.now().millisecondsSinceEpoch;
      final String problemId= drId+timeStamp.toString();
      final String submitDate= DateFormat("dd-MMM-yyyy/hh:mm:aa").format(DateTime.fromMillisecondsSinceEpoch(timeStamp));

      await FirebaseFirestore.instance.collection('UserProblems').doc(problemId).set({
         'id':problemId,
         'submitDate': submitDate,
         'messageFrom': 'doctor',
         'name': name,
         'email':email,
         'message':message,
         'phone': drId,
         'timeStamp': timeStamp.toString()
      }).then((value){
         Navigator.pop(context);
         showSnackBar(scaffoldKey,'Message successfully sent to Authority',Theme.of(context).primaryColor);
      },onError: (error){
         Navigator.pop(context);
         showSnackBar(scaffoldKey,error.toString(),Colors.deepOrange);
      });
   }

   Future<void> getNotification()async{
      try{
         FirebaseFirestore.instance.collection('Notifications').where('category',isEqualTo: 'Doctor').orderBy('id',descending: true).get().then((snapshot){
            _notificationList.clear();
            snapshot.docChanges.forEach((element) {
               NotificationModel model = NotificationModel(
                  id: element.doc['id'],
                  category: element.doc['category'],
                  date: element.doc['date'],
                  message: element.doc['message'],
                  title: element.doc['title'],
               );
               _notificationList.add(model);
            });
         });
         notifyListeners();
      }catch(error){}
   }

   Future<String> updateDoctorPassword(String id,DoctorProvider drProvider,GlobalKey<ScaffoldState> scaffoldKey,BuildContext context)async{
      try{
         await FirebaseFirestore.instance.collection('Doctors').doc(id).update({
            'password': drProvider.doctorDetails.password,
         });
         return null;
      }catch(error){
         return error.toString();
      }
   }

}
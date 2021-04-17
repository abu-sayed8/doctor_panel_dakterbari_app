import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_panel/model/medicine_model.dart';
import 'package:doctor_panel/providers/reg_auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:doctor_panel/widgets/notification_widget.dart';

class MedicineProvider extends RegAuth{

  MedicineModel _medicineModel = MedicineModel();
  List<MedicineModel> _medicineList = [];

  get medicineModel=> _medicineModel;
  get medicineList=> _medicineList;

  set medicineModel(MedicineModel model){
    model = MedicineModel();
    _medicineModel = model;
    notifyListeners();
  }

  Future<void> getMedicine()async{
    try{
      await FirebaseFirestore.instance.collection('Medicines').where('state',isEqualTo: 'approved').get().then((snapshot){
        _medicineList.clear();
        snapshot.docChanges.forEach((element) {
          MedicineModel medicineModel = MedicineModel(
            id: element.doc['id'],
            name: element.doc['name'],
            strength: element.doc['strength'],
            genericName: element.doc['genericName'],
            dosage: element.doc['dosage'],
            manufacturer: element.doc['manufacturer'],
            price: element.doc['price'],
            indications: element.doc['indications'],
            adultDose: element.doc['adultDose'],
            childDose: element.doc['childDose'],
            renalDose: element.doc['renalDose'],
            administration: element.doc['administration'],
            contradiction: element.doc['contradiction'],
            sideEffect: element.doc['sideEffect'],
            precautions: element.doc['precautions'],
            pregnancy: element.doc['pregnancy'],
            therapeutic: element.doc['therapeutic'],
            modeOfAction: element.doc['modeOfAction'],
            interaction: element.doc['interaction'],
            darNo: element.doc['darNo'],
          );
          _medicineList.add(medicineModel);
        });
      });
      notifyListeners();
    }catch(error){}
  }

  Future<void> submitMedicine(MedicineProvider provider,BuildContext context, GlobalKey<ScaffoldState> scaffoldKey)async{
    final String drId = await getPreferenceId();
    final String id= provider.medicineModel.name+DateTime.now().millisecondsSinceEpoch.toString();
    await FirebaseFirestore.instance.collection('Medicines').doc(id).set({
      'id':id,
      'name':provider.medicineModel.name,
      'strength':provider.medicineModel.strength,
      'genericName':provider.medicineModel.genericName,
      'dosage':provider.medicineModel.dosage,
      'manufacturer':provider.medicineModel.manufacturer,
      'price':provider.medicineModel.price,
      'indications':provider.medicineModel.indications,
      'adultDose':provider.medicineModel.adultDose,
      'childDose':provider.medicineModel.childDose,
      'renalDose':provider.medicineModel.renalDose,
      'administration':provider.medicineModel.administration,
      'contradiction':provider.medicineModel.contradiction,
      'sideEffect':provider.medicineModel.sideEffect,
      'precautions':provider.medicineModel.precautions,
      'pregnancy':provider.medicineModel.pregnancy,
      'therapeutic':provider.medicineModel.therapeutic,
      'modeOfAction':provider.medicineModel.modeOfAction,
      'interaction':provider.medicineModel.interaction,
      'darNo':provider.medicineModel.darNo,
      'state':'pending',
      'representativePhone': drId,
    }).then((value){
      Navigator.pop(context);
      Navigator.pop(context);
      showAlertDialog(context, 'Medicine submitted successful');
    },onError: (error){
      Navigator.pop(context);
      showSnackBar(scaffoldKey, error.toString(), Colors.deepOrange);
    });
  }

}
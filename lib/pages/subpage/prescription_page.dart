import 'package:doctor_panel/shared/form_decoration.dart';
import 'package:doctor_panel/widgets/custom_app_bar.dart';
import 'package:doctor_panel/widgets/button_widgets.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doctor_panel/providers/appointment_provider.dart';
import 'package:doctor_panel/providers/doctor_provider.dart';
import 'package:doctor_panel/providers/medicine_provider.dart';
import 'package:doctor_panel/widgets/notification_widget.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class PrescriptionPage extends StatefulWidget {
  String id;
  String drId;
  String drName;
  String drPhotoUrl;
  String drDegree;
  String drEmail;
  String drAddress;
  String specification;
  String appFee;
  String teleFee;
  String currency;
  String pName;
  String pAddress;
  String pAge;
  String pGender;
  String pProblem;


  PrescriptionPage({
      this.id,
      this.drId,
      this.drName,
      this.drPhotoUrl,
      this.drDegree,
      this.drEmail,
      this.drAddress,
      this.specification,
      this.appFee,
      this.teleFee,
      this.currency,
      this.pName,
      this.pAddress,
      this.pAge,
      this.pGender,
      this.pProblem,
      });

  @override
  _PrescriptionPageState createState() => _PrescriptionPageState();
}

class _PrescriptionPageState extends State<PrescriptionPage> {
  final _addMedicineKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _medicineListController = TextEditingController();
  int _counter=0;
  List<String> medicineNameList =[];

  _initializeData(MedicineProvider mProvider){
    for(int i=0;i<mProvider.medicineList.length;i++){
      medicineNameList.add(mProvider.medicineList[i].name);
    }
    setState((){
      medicineNameList;
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppointmentProvider appProvider = Provider.of<AppointmentProvider>(context);
    final DoctorProvider drProvider = Provider.of<DoctorProvider>(context);
    final MedicineProvider mProvider = Provider.of<MedicineProvider>(context);
    if(_counter==0) _initializeData(mProvider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      //backgroundColor: Color(0xffF4F7F5),
      appBar: customAppBarDesign(context, "Prescribe to ${widget.pName}"),
      body:_bodyUI(appProvider, mProvider, drProvider),
    );
  }

  Widget _bodyUI(AppointmentProvider appProvider,MedicineProvider mProvider,DoctorProvider drProvider) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      child: ListView(
        children: [
          _topSectionBuilder(size,drProvider),
          SizedBox(height: 10),

          _patientInformationSection(size,drProvider),
          SizedBox(height: 20),

          //Add medicine button
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: size.width * .33),
            child: RaisedButton(
              color: Theme.of(context).primaryColor,
              onPressed: () => _showMedicineDialogue(appProvider),
              child: Text(
                "Add Medicine",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: size.width*.04),
              ),
            ),
          ),
          SizedBox(height: 20),

          _prescribeDetails(size,appProvider),
          SizedBox(height: 20),

          //Confirm button
          GestureDetector(
            onTap: ()=> _checkValidity(appProvider,drProvider),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Button(context, 'Confirm Prescribe'),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _topSectionBuilder(Size size,DoctorProvider drProvider) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      //color: Color(0xffF4F7F5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: Colors.white,
            child: Image.asset('assets/logo.png', height: 45,),
          ),
          SizedBox(height: size.width / 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: size.width*.12,
                width: size.width*.12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(35)),
                  image: DecorationImage(
                    image: widget.drPhotoUrl==null? AssetImage('assets/male.png')
                        :NetworkImage(widget.drPhotoUrl),
                    fit: BoxFit.cover
                  )
                ),
              ),
              SizedBox(width: 8),
              Text(
                widget.drName?? "Dr. Name",
                maxLines: 1,
                style: TextStyle(
                    fontSize: size.width / 20,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Text(
            widget.drDegree?? "Degree",
            maxLines: 2,
            style:
                TextStyle(fontSize: size.width / 32, color: Colors.grey[700]),
          ),
          SizedBox(height: size.width / 50),
          Text(
            'Address: '
            '${widget.drAddress??'Empty'}',
            maxLines: 2,
            style:
                TextStyle(fontSize: size.width / 30, color: Colors.grey[700]),
          ),
          Text(
            'Phone: ${widget.drId}',
            maxLines: 1,
            style:
                TextStyle(fontSize: size.width / 30, color: Colors.grey[700]),
          ),
          Text(
            "Email: ${widget.drEmail??''}",
            maxLines: 1,
            style:
                TextStyle(fontSize: size.width / 30, color: Colors.grey[700]),
          ),
          SizedBox(height: size.width / 40),
          Container(
            height: 2,
            width: size.width,
            color: Theme.of(context).primaryColor,
          )
        ],
      ),
    );
  }

  Widget _patientInformationSection(Size size,DoctorProvider drProvider) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      //color: Color(0xffF4F7F5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Date & S.No
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: size.width * .43,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Date: ",
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: size.width / 30,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat("dd-MMM-yyyy").format(DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch)),
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: size.width / 32,
                              color: Colors.grey[800]),
                        ),
                        Container(
                          height: 1,
                          color: Colors.grey[800],
                          width: size.width * .34,
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                width: size.width * .43,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "P.No: ",
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: size.width / 30,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          drProvider.doctorList[0].totalPrescribe==null? '1': (int.parse(drProvider.doctorList[0].totalPrescribe)+1).toString(),
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: size.width / 32,
                              color: Colors.grey[800]),
                        ),
                        Container(
                          height: 1,
                          color: Colors.grey[800],
                          width: size.width * .33,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),

          //Patient Name
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Patient Name: ",
                maxLines: 1,
                style: TextStyle(
                    fontSize: size.width / 30,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.pName,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: size.width / 32, color: Colors.grey[800]),
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey[800],
                    width: size.width * .71,
                  )
                ],
              )
            ],
          ),
          SizedBox(height: 5),

          //Address
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Address: ",
                maxLines: 1,
                style: TextStyle(
                    fontSize: size.width / 30,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.pAddress??'',
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: size.width / 32, color: Colors.grey[800]),
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey[800],
                    width: size.width * .79,
                  )
                ],
              )
            ],
          ),
          SizedBox(height: 5),

          //Age & Gender
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: size.width * .43,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Age: ",
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: size.width / 30,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.pAge??'',
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: size.width / 32,
                              color: Colors.grey[800]),
                        ),
                        Container(
                          height: 1,
                          color: Colors.grey[800],
                          width: size.width * .35,
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                width: size.width * .43,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Gender: ",
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: size.width / 30,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.pGender??'',
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: size.width / 32,
                              color: Colors.grey[800]),
                        ),
                        Container(
                          height: 1,
                          color: Colors.grey[800],
                          width: size.width * .29,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _prescribeDetails(Size size,AppointmentProvider appProvider) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          appProvider.prescribedMedicineList.isEmpty
              ? Container():
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Prescribed Medicines :",
                      style: TextStyle(
                          color: Colors.grey[900], fontWeight: FontWeight.w600),
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() =>appProvider.clearPrescribedMedicineList());
                        },
                        child: Text(
                          "Remove all",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600),
                        )),
                  ],
                ),
          SizedBox(height: 10),
          Container(
            width: size.width,
            child: ListView.builder(
              itemCount: appProvider.prescribedMedicineList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 5, top: 5, left: 2, right: 2),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Color(0xffF4F7F5),
                      borderRadius: BorderRadius.all(Radius.circular(5)),

                  ),
                  child: Text(
                    "${appProvider.prescribedMedicineList[index]}",
                    style: TextStyle(
                        color: Colors.grey[900],
                        fontWeight: FontWeight.w500),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: 6,
            style: TextStyle(
                fontSize: size.width*.033
            ),
            decoration: FormDecorationWithoutPrefix.copyWith(
              labelText: 'Patient problems',
              labelStyle: TextStyle(
                fontSize: size.width*.033
              ),
              fillColor: Color(0xffF4F7F5),
              alignLabelWithHint: true,
            ),
            onChanged: (val) => appProvider.prescriptionModel.actualProblem = val,
            validator: (val) => val.isEmpty ? 'Write patient problems' : null,
          ),
          SizedBox(height: 20),
          TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: 6,
            style: TextStyle(
                fontSize: size.width*.033
            ),
            decoration: FormDecorationWithoutPrefix.copyWith(labelText: 'Rx...',
              labelStyle: TextStyle(
                  fontSize: size.width*.033
              ),
              alignLabelWithHint: true,fillColor: Color(0xffF4F7F5),),
            onChanged: (val) => appProvider.prescriptionModel.rx = val,
            validator: (val) => val.isEmpty ? 'Rx here' : null,
          ),
          SizedBox(height: 20),
          TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            style: TextStyle(
                fontSize: size.width*.033
            ),
            onChanged: (val)=> appProvider.prescriptionModel.advice = val
            ,
            decoration: FormDecorationWithoutPrefix.copyWith(labelText: 'Advice',
              labelStyle: TextStyle(
                  fontSize: size.width*.033
              ),
              fillColor: Color(0xffF4F7F5),),
            validator: (val) => val.isEmpty ? 'please write advice' : null,
          ),
          SizedBox(height: 20),

          TextFormField(
            style: TextStyle(
                fontSize: size.width*.033
            ),
            decoration: FormDecorationWithoutPrefix.copyWith(labelText: 'Next visit',
              labelStyle: TextStyle(
                  fontSize: size.width*.033
              ),
              fillColor: Color(0xffF4F7F5),),
            onChanged: (val) => appProvider.prescriptionModel.nextVisit = val,
            validator: (val) => val.isEmpty ? 'please write next visit' : null,
          ),
        ],
      ),
    );
  }

  void _showMedicineDialogue(AppointmentProvider appProvider) {
    String medicineName;
    String dosage;
    String strength;
    String duration;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          Size size=MediaQuery.of(context).size;
          return AlertDialog(
            scrollable: true,
            contentPadding: EdgeInsets.all(20),
            title: Text(
              "Add Medicine Details",style: TextStyle(fontSize: size.width*.04),
              textAlign: TextAlign.center,
            ),
            content: Container(
              child: Form(
                key: _addMedicineKey,
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    DropDownField(
                      controller: _medicineListController,
                      hintText: 'Select Medicine',
                      hintStyle: TextStyle(fontSize: size.width*.033),
                      enabled: true,
                      itemsVisibleInDropdown: 4,
                      items: medicineNameList,
                      onValueChanged: (val)=> medicineName = val,
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: size.width*.033),
                      decoration: FormDecorationWithoutPrefix.copyWith(labelText: 'Strength (e.g 500mg/5ml)',fillColor: Color(0xffF4F7F5),),
                      onChanged: (val) => strength = val,
                      validator: (val) =>
                          val.isEmpty ? 'please write strength' : null,
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: size.width*.033),
                      decoration: FormDecorationWithoutPrefix.copyWith(labelText: 'Dosage (e.g 1+0+1)',fillColor: Color(0xffF4F7F5),),
                      onChanged: (val) => dosage = val,
                      validator: (val) =>
                          val.isEmpty ? 'please write dosage' : null,
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: size.width*.033),
                      decoration: FormDecorationWithoutPrefix.copyWith(labelText: 'Duration in days (e.g 10)',fillColor: Color(0xffF4F7F5),),
                      onChanged: (val) => duration = val,
                      validator: (val) =>
                          val.isEmpty ? 'please write duration' : null,
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RaisedButton(
                          color: Colors.redAccent,
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: size.width*.036),
                          ),
                        ),
                        RaisedButton(
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            if (_addMedicineKey.currentState.validate() && medicineName != null) {
                              appProvider.addMedicine(
                                '$medicineName | $strength | $dosage | $duration days'
                              );
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text(
                            "Add",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                            fontSize: size.width*.036),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _checkValidity(AppointmentProvider appProvider,DoctorProvider drProvider)async{
    if(appProvider.prescribedMedicineList.isNotEmpty){
      if(appProvider.prescriptionModel.actualProblem.isNotEmpty){
        appProvider.loadingMgs='Prescription confirming...';
        showLoadingDialog(context, appProvider);

        await appProvider.confirmPrescribe(appProvider,drProvider, widget.drId, widget.id, context, _scaffoldKey);

      }else showSnackBar(_scaffoldKey, 'Define patient problems', Colors.deepOrange);
    }else showSnackBar(_scaffoldKey, 'Add medicine first', Colors.deepOrange);
  }
}

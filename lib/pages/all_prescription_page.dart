import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctor_panel/widgets/button_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:doctor_panel/providers/doctor_provider.dart';
import 'package:doctor_panel/providers/appointment_provider.dart';
import 'package:doctor_panel/widgets/notification_widget.dart';
import 'package:doctor_panel/widgets/custom_app_bar.dart';
import 'package:doctor_panel/model/appointment_model.dart';
import 'package:doctor_panel/pages/subpage/view_prescription_page.dart';
import 'package:doctor_panel/shared/form_decoration.dart';

// ignore: must_be_immutable
class AllPrescription extends StatefulWidget {

  @override
  _AllPrescriptionState createState() => _AllPrescriptionState();
}

class _AllPrescriptionState extends State<AllPrescription> {

  List<AppointmentDetailsModel> prescribeList = [];
  List<AppointmentDetailsModel> filteredPrescribeList = [];
  int _counter = 0;
  bool _folded=true;

  void _initializeData(AppointmentProvider appointmentProvider) {
    setState((){
      prescribeList = appointmentProvider.prescriptionList;
      filteredPrescribeList = prescribeList;
      _counter++;
    });

  }

  ///SearchList builder
  _filterList(String searchItem) {
    setState(() {
      filteredPrescribeList = prescribeList.where((element) =>
      (element.pName.toLowerCase().contains(searchItem.toLowerCase()))).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppointmentProvider appointmentProvider = Provider.of<AppointmentProvider>(context);
    if (_counter == 0) _initializeData(appointmentProvider);

    return Scaffold(
      backgroundColor: Color(0xffF4F7F5),
      appBar: customAppBarDesign(context, 'All prescription List'),
      body: _bodyUI(appointmentProvider),
    );
  }

  Widget _bodyUI(AppointmentProvider appointmentProvider) {
    return RefreshIndicator(
      backgroundColor: Colors.white,
      onRefresh: ()async{
        await appointmentProvider.getPrescriptionList();
        _initializeData(appointmentProvider);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _animatedSearchBar(),
          SizedBox(height: 5),

          Expanded(
            child: AnimationLimiter(
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: filteredPrescribeList.length,
                itemBuilder: (context, index){
                  return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 500),
                      child: SlideAnimation(
                        verticalOffset: 400,
                        child: PatientInfoTile(
                          id: filteredPrescribeList[index].id,
                          drId: filteredPrescribeList[index].drId,
                          drName: filteredPrescribeList[index].drName,
                          drPhotoUrl: filteredPrescribeList[index].drPhotoUrl,
                          drDegree: filteredPrescribeList[index].drDegree,
                          drEmail: filteredPrescribeList[index].drEmail,
                          drAddress: filteredPrescribeList[index].drAddress,
                          specification: filteredPrescribeList[index].specification,
                          appFee: filteredPrescribeList[index].appFee,
                          teleFee: filteredPrescribeList[index].teleFee,
                          currency: filteredPrescribeList[index].currency,
                          pName: filteredPrescribeList[index].pName,
                          pPhotoUrl: filteredPrescribeList[index].pPhotoUrl,
                          pAddress: filteredPrescribeList[index].pAddress,
                          pAge: filteredPrescribeList[index].pAge,
                          pGender: filteredPrescribeList[index].pGender,
                          pProblem: filteredPrescribeList[index].pProblem,
                          bookingDate: filteredPrescribeList[index].bookingDate,
                          appointDate: filteredPrescribeList[index].appointDate,
                          chamberName: filteredPrescribeList[index].chamberName,
                          chamberAddress: filteredPrescribeList[index].chamberAddress,
                          bookingSchedule: filteredPrescribeList[index].bookingSchedule,
                          appointState: filteredPrescribeList[index].appointState,
                          pId: filteredPrescribeList[index].pId,
                          prescribeDate: filteredPrescribeList[index].prescribeDate,
                          actualProblem: filteredPrescribeList[index].actualProblem,
                          advice: filteredPrescribeList[index].advice,
                          rx: filteredPrescribeList[index].rx,
                          nextVisit: filteredPrescribeList[index].nextVisit,
                          medicines: filteredPrescribeList[index].medicines,
                          prescribeNo: filteredPrescribeList[index].prescribeNo,
                        ),
                      )
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
  Widget _animatedSearchBar(){
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      width: _folded ? 50 : MediaQuery.of(context).size.width,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: Colors.white,
        boxShadow: kElevationToShadow[2],
      ),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 16),
              child: !_folded
                  ? TextField(
                onChanged: _filterList,
                decoration: InputDecoration(
                    hintText: 'Search by name...',
                    hintStyle: TextStyle(color: Theme.of(context).primaryColor),
                    border: InputBorder.none),
              )
                  : null,
            ),
          ),
          Container(
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(_folded ? 32 : 0),
                  topRight: Radius.circular(32),
                  bottomLeft: Radius.circular(_folded ? 32 : 0),
                  bottomRight: Radius.circular(32),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Icon(
                    _folded ? Icons.search : Icons.close,
                    color: Colors.blue[900],
                    size: 20,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _folded = !_folded;
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class PatientInfoTile extends StatelessWidget {
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
  String pId;
  String pName;
  String pPhotoUrl;
  String pAddress;
  String pAge;
  String pGender;
  String pProblem;
  String bookingDate;
  String appointDate;
  String chamberName;
  String chamberAddress;
  String bookingSchedule;
  String appointState;
  String prescribeDate;
  String actualProblem;
  String advice;
  String rx;
  String nextVisit;
  List<dynamic> medicines;
  String prescribeNo;

  PatientInfoTile(
      {this.id,
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
        this.pId,
        this.pName,
        this.pPhotoUrl,
        this.pAddress,
        this.pAge,
        this.pGender,
        this.pProblem,
        this.bookingDate,
        this.appointDate,
        this.chamberName,
        this.chamberAddress,
        this.bookingSchedule,
        this.appointState, this.prescribeDate,
        this.medicines,this.nextVisit,this.rx,this.advice,this.actualProblem,this.prescribeNo});

  @override
  Widget build(BuildContext context) {
    DoctorProvider drProvider = Provider.of<DoctorProvider>(context);

    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      width: size.width,
      height: size.width * .28,
      decoration: simpleCardDecoration,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            ///Leading Container...
            Container(
              padding: EdgeInsets.all(5),
              width: size.width * .26,
              height: size.width * .27,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Color(0xffAAF1E8),
              ),
              child: pPhotoUrl == null
                  ? Image.asset("assets/male.png", width: size.width * .26)
                  : ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: CachedNetworkImage(
                  imageUrl: pPhotoUrl,
                  placeholder: (context, url) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/loadingimage.gif',
                      width: size.width * .26,
                      fit: BoxFit.cover,
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  width: size.width * .26,
                  //height: size.height * .28,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            ///Middle Section...
            Container(
              padding: EdgeInsets.only(left: 5),
              width: size.width * .47,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    pName ?? 'Patient name',
                    maxLines: 1,
                    style: TextStyle(fontSize: size.width*.038, fontWeight: FontWeight.w500),
                  ),
                  //SizedBox(height: 5),
                  Text(
                    pProblem ?? 'Patient problem',
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: size.width*.028,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 1),
                  appointState=='Chamber or Hospital'?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'At: $chamberName' ?? 'Chamber or Hospital',
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: size.width*.026,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w400),
                      ),Text(
                        'Schedule: $bookingSchedule' ?? 'Time schudule',
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: size.width*.026,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  )
                      :Text(
                    appointState ?? 'Online Video Consultation',
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: size.width*.026,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    'On: $appointDate' ?? 'Appointment date',
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: size.width*.026,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400),
                  ),


                  Text(
                    'Booked on: $bookingDate' ?? 'Booking Date',
                    maxLines: 1,
                    style:
                    TextStyle(fontSize: size.width*.027, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),

            ///Trailing Section
            Container(
              alignment: Alignment.topRight,
              width: size.width * .19,
              height: size.height,
              //color: Colors.red,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [

                  InkWell(
                      splashColor: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      onTap: () async {
                        if (drProvider.doctorList.isEmpty) {
                          drProvider.loadingMgs = 'Please wait...';
                          showLoadingDialog(context, drProvider);
                          await drProvider.getDoctor().then((value) async {
                              Navigator.pop(context);
                              Navigator.push(context,
                                  MaterialPageRoute(
                                      builder: (context) => ViewPrescription(
                                        id: id,
                                        drId: drId,
                                        drName: drName,
                                        drPhotoUrl: drPhotoUrl,
                                        drDegree: drDegree,
                                        drEmail: drEmail,
                                        drAddress: drAddress,
                                        specification: specification,
                                        appFee: appFee,
                                        teleFee: teleFee,
                                        currency: currency,
                                        pName: pName,
                                        pPhotoUrl: pPhotoUrl,
                                        pAddress: pAddress,
                                        pAge: pAge,
                                        pGender: pGender,
                                        pProblem: pProblem,
                                        bookingDate: bookingDate,
                                        appointDate: appointDate,
                                        chamberName: chamberName,
                                        chamberAddress: chamberAddress,
                                        bookingSchedule: bookingSchedule,
                                        appointState: appointState,
                                        pId: pId,
                                        prescribeDate: prescribeDate,
                                        actualProblem: actualProblem,
                                        advice: advice,
                                        rx: rx,
                                        nextVisit: nextVisit,
                                        medicines: medicines,
                                        prescribeNo: prescribeNo,
                                      )));

                          });
                        } else {
                          Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => ViewPrescription(
                                    id: id,
                                    drId: drId,
                                    drName: drName,
                                    drPhotoUrl: drPhotoUrl,
                                    drDegree: drDegree,
                                    drEmail: drEmail,
                                    drAddress: drAddress,
                                    specification: specification,
                                    appFee: appFee,
                                    teleFee: teleFee,
                                    currency: currency,
                                    pName: pName,
                                    pPhotoUrl: pPhotoUrl,
                                    pAddress: pAddress,
                                    pAge: pAge,
                                    pGender: pGender,
                                    pProblem: pProblem,
                                    bookingDate: bookingDate,
                                    appointDate: appointDate,
                                    chamberName: chamberName,
                                    chamberAddress: chamberAddress,
                                    bookingSchedule: bookingSchedule,
                                    appointState: appointState,
                                    pId: pId,
                                    prescribeDate: prescribeDate,
                                    actualProblem: actualProblem,
                                    advice: advice,
                                    rx: rx,
                                    nextVisit: nextVisit,
                                    medicines: medicines,
                                    prescribeNo: prescribeNo,
                                  )));
                        }
                      },
                      child: miniOutlineButton(context, 'View',
                          Theme.of(context).primaryColor)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}
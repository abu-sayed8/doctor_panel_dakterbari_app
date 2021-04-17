import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctor_panel/pages/subpage/prescription_page.dart';
import 'package:doctor_panel/widgets/button_widgets.dart';
import 'package:doctor_panel/widgets/no_data_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:doctor_panel/providers/doctor_provider.dart';
import 'package:doctor_panel/providers/medicine_provider.dart';
import 'package:doctor_panel/providers/appointment_provider.dart';
import 'package:doctor_panel/widgets/notification_widget.dart';
import 'package:doctor_panel/widgets/custom_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:doctor_panel/shared/form_decoration.dart';

// ignore: must_be_immutable
class Appointments extends StatefulWidget {
  @override
  _AppointmentsState createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  @override
  Widget build(BuildContext context) {
    final AppointmentProvider appointmentProvider =
        Provider.of<AppointmentProvider>(context);
    return Scaffold(
      backgroundColor: Color(0xffF4F7F5),
      appBar: customAppBarDesign(context, 'My Appointments'),
      body: _bodyUI(appointmentProvider),
    );
  }

  Widget _bodyUI(AppointmentProvider appointmentProvider) {
    return Container(
      child: RefreshIndicator(
        backgroundColor: Colors.white,
        onRefresh: ()=>appointmentProvider.getAppointmentList(),
        child:AnimationLimiter(
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: appointmentProvider.appointmentList.length,
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 500),
                  child: SlideAnimation(
                    verticalOffset: 400,
                    child: FadeInAnimation(
                      child: PatientInfoTile(
                        id: appointmentProvider.appointmentList[index].id,
                        drId: appointmentProvider.appointmentList[index].drId,
                        drName: appointmentProvider.appointmentList[index].drName,
                        drPhotoUrl: appointmentProvider.appointmentList[index].drPhotoUrl,
                        drDegree: appointmentProvider.appointmentList[index].drDegree,
                        drEmail: appointmentProvider.appointmentList[index].drEmail,
                        drAddress: appointmentProvider.appointmentList[index].drAddress,
                        specification:
                        appointmentProvider.appointmentList[index].specification,
                        appFee: appointmentProvider.appointmentList[index].appFee,
                        teleFee: appointmentProvider.appointmentList[index].teleFee,
                        currency: appointmentProvider.appointmentList[index].currency,
                        pId: appointmentProvider.appointmentList[index].pId,
                        pName: appointmentProvider.appointmentList[index].pName,
                        pPhotoUrl: appointmentProvider.appointmentList[index].pPhotoUrl,
                        pAddress: appointmentProvider.appointmentList[index].pAddress,
                        pAge: appointmentProvider.appointmentList[index].pAge,
                        pGender: appointmentProvider.appointmentList[index].pGender,
                        pProblem: appointmentProvider.appointmentList[index].pProblem,
                        bookingDate: appointmentProvider.appointmentList[index].bookingDate,
                        appointDate: appointmentProvider.appointmentList[index].appointDate,
                        chamberName: appointmentProvider.appointmentList[index].chamberName,
                        chamberAddress:
                        appointmentProvider.appointmentList[index].chamberAddress,
                        bookingSchedule:
                        appointmentProvider.appointmentList[index].bookingSchedule,
                        appointState:
                        appointmentProvider.appointmentList[index].appointState,
                      ),
                    ),
                  )
              );
            },
          ),
        ),
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
      this.appointState});

  @override
  Widget build(BuildContext context) {
    DoctorProvider drProvider = Provider.of<DoctorProvider>(context);
    MedicineProvider mProvider = Provider.of<MedicineProvider>(context);
    AppointmentProvider appProvider = Provider.of<AppointmentProvider>(context);

    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      width: size.width,
      height: size.width*.28,
      decoration: simpleCardDecoration,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ///Leading Container...
            Container(
              padding: EdgeInsets.all(5),
              width:  size.width * .24,
              height: size.width * .27,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Color(0xffAAF1E8),
              ),
              child: pPhotoUrl == null
                  ? Image.asset("assets/male.png", width: size.width * .24)
                  : ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: CachedNetworkImage(
                        imageUrl: pPhotoUrl,
                        placeholder: (context, url) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/loadingimage.gif',
                            width: size.width * .24,
                            fit: BoxFit.cover,
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        width: size.width * .24,
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
                    pName?? 'Patient name',
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
                  SizedBox(height: 2),
                  appointState=='Chamber or Hospital'?
                  Text(
                    'At: $chamberName',
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: size.width*.026,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400),
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
                    'Schedule: $bookingSchedule' ,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: size.width*.026,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    'Appoint date: $appointDate',
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: size.width*.026,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400),
                  ),


                  Text(
                    'Booked on: $bookingDate',
                    maxLines: 1,
                    style:
                        TextStyle(fontSize: size.width*.028, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),

            ///Trailing Section
            Container(
              alignment: Alignment.bottomCenter,
              width: size.width * .20,
              height: size.height,
              //color: Colors.red,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  appointState == 'Online Video Consultation'
                      ? GestureDetector(
                          onTap: () => _showModalBottomSheet(context, pId, pName),
                          child: Icon(
                            Icons.local_phone_outlined,
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                      : Container(),
                  InkWell(
                      splashColor: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      onTap: () async {
                        if (mProvider.medicineList.isEmpty ||
                            drProvider.doctorList.isEmpty) {
                          drProvider.loadingMgs = 'Please wait...';
                          showLoadingDialog(context, drProvider);
                          await drProvider.getDoctor().then((value) async {
                            await mProvider.getMedicine().then((value) {
                              //initialize appointment Data
                              appProvider.prescriptionModel.actualProblem = '';
                              appProvider.prescriptionModel.rx = '';
                              appProvider.prescriptionModel.advice = '';
                              appProvider.prescriptionModel.nextVisit = '';
                              appProvider.clearPrescribedMedicineList();

                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PrescriptionPage(
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
                                            pAddress: pAddress,
                                            pAge: pAge,
                                            pGender: pGender,
                                            pProblem: pProblem,
                                          )));
                            });
                          });
                        } else {
                          //initialize appointment Data
                          appProvider.prescriptionModel.actualProblem = '';
                          appProvider.prescriptionModel.rx = '';
                          appProvider.prescriptionModel.advice = '';
                          appProvider.prescriptionModel.nextVisit = '';
                          appProvider.clearPrescribedMedicineList();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PrescriptionPage(
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
                                        pAddress: pAddress,
                                        pAge: pAge,
                                        pGender: pGender,
                                        pProblem: pProblem,
                                      )));
                        }
                      },
                      child: miniOutlineButton(context, 'Prescribe',
                          Theme.of(context).primaryColor)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context, String pId, String pName){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return Container(
            margin: EdgeInsets.only(left: 15,right: 15,bottom: 20),
            height: 150,
            decoration: modalDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Make call with $pName via?',style: TextStyle(fontSize: 16),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                        _makePhoneCall(context,'tel:$pId');
                        },
                      child: Container(
                        width: 80,
                        padding: EdgeInsets.all( 5),
                        decoration: BoxDecoration(
                            color: Color(0xffD4EFF5),
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child: Column(
                          children: [
                            Image.asset('assets/icons/phone128.png',height: 50,),
                            Text('Phone')
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                        _launchWhatsApp(
                            context:context,
                            number: pId,
                            message:
                            'Hello $pName. This is Dr. $drName from Daktarbari. Can I make video conversation?');
                      },
                      child: Container(
                        width: 80,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Color(0xffD4EFF5),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child: Column(
                          children: [
                            Image.asset('assets/icons/whatsapp128.png',height: 50,),
                            Text('WhatsApp')
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
    }
    );
  }

  void _launchWhatsApp({BuildContext context, String number, String message}) async {
    String url = "whatsapp://send?phone=$number&text=$message";
    await canLaunch(url) ? launch(url) : showAlertDialog(context, 'Error making WhatsApp call. Try again later');
  }

  Future<void> _makePhoneCall(BuildContext context, String url) async {
    await canLaunch(url) ? launch(url) : showAlertDialog(context, 'Error making phone call. Try again later');
  }


}

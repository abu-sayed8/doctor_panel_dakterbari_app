import 'dart:io';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:doctor_panel/pages/subpage/add_hospitals.dart';
import 'package:doctor_panel/providers/doctor_provider.dart';
import 'package:doctor_panel/widgets/custom_app_bar.dart';
import 'package:doctor_panel/shared/form_decoration.dart';
import 'package:doctor_panel/widgets/button_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:doctor_panel/widgets/notification_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class UpdateProfile extends StatefulWidget {
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _counter =0;
  List<dynamic> optSpecificationList=[];
  final _specificFormKey = GlobalKey<FormState>();

  TextEditingController spController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController expController = TextEditingController();
  TextEditingController teleFeeController = TextEditingController();
  TextEditingController appFeeController = TextEditingController();
  TextEditingController serviceAtController = TextEditingController();
  TextEditingController specificationController = TextEditingController();
  TextEditingController degreeController = TextEditingController();
  TextEditingController totalPrescribeController = TextEditingController();


  void _initializeTextFormData(DoctorProvider operation){
    setState(()=>_counter++);
    nameController.text = operation.doctorList[0].fullName ?? '';
    phoneController.text = operation.doctorList[0].id ?? '';
    emailController.text = operation.doctorList[0].email ?? '';
    aboutController.text = operation.doctorList[0].about ?? '';
    expController.text = operation.doctorList[0].experience ?? '';
    teleFeeController.text = operation.doctorList[0].teleFee ?? '';
    appFeeController.text = operation.doctorList[0].appFee ?? '';
    specificationController.text=operation.doctorList[0].specification ?? '';
    degreeController.text=operation.doctorList[0].degree ?? '';
    totalPrescribeController.text=operation.doctorList[0].totalPrescribe ?? '00';

    operation.doctorDetails.fullName=operation.doctorList[0].fullName ?? '';
    operation.doctorDetails.email=operation.doctorList[0].email ?? '';
    operation.doctorDetails.about=operation.doctorList[0].about ??'';
    operation.doctorDetails.experience=operation.doctorList[0].experience ??'';
    operation.doctorDetails.teleFee=operation.doctorList[0].teleFee ??'';
    operation.doctorDetails.appFee=operation.doctorList[0].appFee ??'';
    operation.doctorDetails.country=operation.doctorList[0].country ??'';
    operation.doctorDetails.state=operation.doctorList[0].state ??'';
    operation.doctorDetails.city=operation.doctorList[0].city ??'';
    operation.doctorDetails.degree=operation.doctorList[0].degree ??'';
    optSpecificationList = operation.doctorList[0].optionalSpecification??[];
  }

  @override
  Widget build(BuildContext context) {
    DoctorProvider operation = Provider.of<DoctorProvider>(context);
    if(_counter==0)_initializeTextFormData(operation);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: customAppBarDesign(context, "My Profile"),
      body:_bodyUI(),
    );
  }

  // ignore: missing_return
  Widget _bodyUI() {
    Size size = MediaQuery.of(context).size;
    DoctorProvider operation = Provider.of<DoctorProvider>(context);
    return Container(
      height: size.height,
      width: size.width,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ///Account Section...
            Container(
              padding: EdgeInsets.all(10),
              color: Colors.white,
              height: size.height * .25,
              width: size.width,
              child: Row(
                children: [
                  ///Profile Picture
                  Container(
                      width: size.width * .46,
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color(0xffAAF1E8),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: operation.doctorList[0].photoUrl==null? Image.asset("assets/male.png", width: 150)
                          :ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: CachedNetworkImage(
                        imageUrl: operation.doctorList[0].photoUrl,
                        placeholder: (context, url) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset('assets/loadingimage.gif',width: size.width * .46,
                              height: size.height * .25,fit: BoxFit.cover,),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        width: size.width * .46,
                        height: size.height * .25,
                        fit: BoxFit.cover,
                      ),
                          ),
                  ),

                  ///Update Profile Image
                  Container(
                    width: size.width * .42,
                    margin: EdgeInsets.only(left: 10, top: 10),
                    child: InkWell(
                      onTap: (){
                        _getImageFromGallery(operation);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Earned Tele Fee:',
                                style: TextStyle(color: Colors.grey[700],fontWeight: FontWeight.w500,fontSize: size.width*.045),),
                              Text(operation.doctorList[0].totalTeleFee==null?
                              '0.00 ${operation.doctorList[0].currency}'
                                  :'${operation.doctorList[0].totalTeleFee} ${operation.doctorList[0].currency}',
                                style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.w500,fontSize: size.width*.04),),
                            ],
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Theme.of(context).primaryColor,
                                        width: 3,
                                      ),
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                                  child: Icon(
                                    Icons.camera,
                                    color: Theme.of(context).primaryColor,
                                    size: size.width*.05,
                                  )),
                              SizedBox(height: size.width / 40),
                              Text(
                                "Change Image",
                                style: TextStyle(
                                    fontSize: size.width*.05,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

            ///Doctor Details
            Container(
              width: size.width,
              padding: EdgeInsets.symmetric(horizontal: 10),
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(height: size.width / 20),
                  _buildTextForm("Full name", Icons.person,operation),
                  SizedBox(height: size.width / 20),
                  _buildTextForm("Phone number", Icons.phone_android_outlined,operation),
                  SizedBox(height: size.width / 20),
                  _buildTextForm("Email address", Icons.mail,operation),
                  SizedBox(height: size.width / 20),
                  _buildTextForm("About", Icons.error_outlined,operation),
                  SizedBox(height: size.width / 20),

                  ///Address builder
                  Container(
                    width: size.width,
                    padding: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                    decoration: BoxDecoration(
                        color: Color(0xffF2F8F4),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Address',style: TextStyle(fontSize: size.width*.030,color: Colors.grey[700])),
                        SizedBox(height: 5),
                        operation.doctorList[0].country==null&&operation.doctorList[0].state==null?Text(
                          'Country, State, City',
                          style: TextStyle(fontSize: size.width*.036),
                        ):Text('${operation.doctorList[0].country??''}, ${operation.doctorList[0].state??''},'
                            ' ${operation.doctorList[0].city??''}', style: TextStyle(fontSize: size.width*.036),)
                      ],
                    )
                  ),
                  SizedBox(height: size.width / 20),
                ],
              ),
            ),

            ///Country, State, City picker
            Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Color(0xffF2F8F4),
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Change Address',style: TextStyle(fontSize: size.width*.03,color: Colors.grey[700])),
                  SelectState(
                  dropdownColor:Colors.white,
                    style: TextStyle(color: Color(0xff008D74),fontWeight: FontWeight.w500,fontSize: size.width*.036),
                    onCountryChanged: (value) {
                      setState(() {
                        operation.doctorDetails.country = value;
                      });
                    },
                    onStateChanged:(value) {
                      setState(() {
                        operation.doctorDetails.state = value;
                      });
                    },
                    onCityChanged:(value) {
                      setState(() {
                        operation.doctorDetails.city = value;
                      });
                    },
                  ),
                ],
              )
            ),
            SizedBox(height: size.width / 40),

            ///Experience & fees...
            Container(
              width: size.width,
              padding: EdgeInsets.symmetric(horizontal: 10),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      height: size.width / 20
                  ),
                  Text(
                    "Specification, Experience & Fee",
                    style: TextStyle(
                        color: Colors.grey[500],
                         fontSize: size.width*.046,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                      height: size.width / 20
                  ),
                  _buildTextForm('Specification', Icons.cleaning_services, operation),

                  operation.doctorList[0].optionalSpecification!=null?
                      Container(
                        padding: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Color(0xffF4F7F5),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),

                        child: ListView.builder(
                          itemCount: operation.doctorList[0].optionalSpecification.length,
                          shrinkWrap: true,
                          itemBuilder: (context,index){
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                                child: Text('\u25c6 ${operation.doctorList[0].optionalSpecification[index]}',
                                style: TextStyle(color: Colors.grey[900],fontSize: 15),)
                            );
                          },
                        ),
                      )
                      :Container(),
                  SizedBox(height: size.width / 40),
                  operation.doctorList[0].optionalSpecification!=null?
                  Container(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: ()async{
                        operation.loadingMgs='Removing...';
                        showLoadingDialog(context,operation);
                        await operation.removeDoctorSpecifications(operation, context, _scaffoldKey).then((value){
                          optSpecificationList=[];
                        });
                      },
                        child: Text('Remove all',style: TextStyle(color: Colors.redAccent,fontSize: 15,fontWeight: FontWeight.w500),)),
                  ):Container(),

                  ///Add specifications button
                  Container(
                      width: size.width * .30,
                      color: Colors.white,
                      child: InkWell(
                          onTap: ()=>_addSpecification(operation,size),
                          splashColor: Colors.cyan[200],
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: outlineIconButton(context, Icons.add, 'Add more', Theme.of(context).primaryColor))),
                  SizedBox(height: size.width / 20),

                  _buildTextForm('Degree', Icons.work, operation),
                  SizedBox(
                      height: size.width / 20
                  ),
                  _buildTextForm("Year of experience", Icons.work,operation),
                  SizedBox(
                      height: size.width / 20
                  ),
                  _buildTextForm("Total Prescribed", Icons.edit,operation),
                  SizedBox(
                      height: size.width / 20
                  ),
                  _buildTextForm("Appointment fee", Icons.monetization_on,operation),
                  SizedBox(
                      height: size.width / 20
                  ),
                  _buildTextForm("Telemedicine service fee", Icons.monetization_on,operation),

                ],
              ),
            ),
            SizedBox(height: size.width / 20),

            ///Update button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: InkWell(
                  onTap: (){
                    operation.loadingMgs = 'Updating information...';
                    showLoadingDialog(context,operation);
                    operation.updateDoctorInformation(operation,_scaffoldKey, context);
                  },
                  splashColor: Colors.cyan[200],
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: bigOutlineIconButton(context, Icons.update, 'Update Information', Theme.of(context).primaryColor)),
            ),
            SizedBox(height: size.width / 40),

            ///Telemedicine service schedule...
            Container(
              width: size.width,
              padding: EdgeInsets.symmetric(horizontal: 10),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.width / 20,
                  ),
                  Text(
                    "Telemedicine service schedule",
                    style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: size.width*.042,
                        fontWeight: FontWeight.w500),
                  ),
                  // SizedBox(
                  //   height: size.width / 20,
                  // ),

                  operation.doctorList[0].provideTeleService==true? Container(
                    margin: EdgeInsets.only(top: 10),
                    child:
                      Text(
                        '${operation.doctorList[0].sat==null?'':'Sat: ${operation.doctorList[0].sat[0]}-${operation.doctorList[0].sat[1]}  ||  '}'
                        '${operation.doctorList[0].sun==null?'':'Sun: ${operation.doctorList[0].sun[0]}-${operation.doctorList[0].sun[1]}  ||  '}'
                        '${operation.doctorList[0].mon==null?'':'Mon: ${operation.doctorList[0].mon[0]}-${operation.doctorList[0].mon[1]}  ||  '}'
                        '${operation.doctorList[0].tue==null?'':'Tue: ${operation.doctorList[0].tue[0]}-${operation.doctorList[0].tue[1]}  ||  '}'
                        '${operation.doctorList[0].wed==null?'':'Wed: ${operation.doctorList[0].wed[0]}-${operation.doctorList[0].wed[1]}  ||  '}'
                        '${operation.doctorList[0].thu==null?'':'Thu: ${operation.doctorList[0].thu[0]}-${operation.doctorList[0].thu[1]}  ||  '}'
                        '${operation.doctorList[0].fri==null?'':'Fri: ${operation.doctorList[0].fri[0]}-${operation.doctorList[0].fri[1]}  ||  '}',
                        style: TextStyle(fontSize: size.width*.032),
                      )
                  )
                  :Padding(
                    padding: const EdgeInsets.only(bottom: 10,top: 10),
                    child: Text('You don\'t provide telemedicine service yet !',style: TextStyle(color: Color(0xffF0A732),fontWeight: FontWeight.w500),),
                  ),
                  SizedBox(height: size.width / 40),

                  ///Add schedule button
                  Container(
                      width:operation.doctorList[0].provideTeleService? size.width * .41: size.width * .35,
                      //margin: EdgeInsets.symmetric(horizontal: 10),
                      child: InkWell(
                          onTap: (){
                            operation.doctorDetails=null;
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddHospitals('')));
                          },
                          splashColor: Colors.cyan[200],
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: outlineIconButton(context, Icons.add, operation.doctorList[0].provideTeleService? 'Update schedule' :'Add schedule', Theme.of(context).primaryColor))),
                ],
              ),
            ),
            SizedBox(height: size.width / 40),

            ///Service at...
            Container(
              width: size.width,
              padding: EdgeInsets.symmetric(horizontal: 10),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.width / 20,
                  ),
                  Text(
                    "Service at",
                    style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 19,
                        fontWeight: FontWeight.w500),
                  ),
                  operation.hospitalList.isEmpty? Padding(
                    padding: const EdgeInsets.only(bottom: 10,top: 10),
                    child: Text('No hospital/chamber added yet !',style: TextStyle(color: Color(0xffF0A732),fontWeight: FontWeight.w500),),
                  )
                      : Container(
                          margin: EdgeInsets.only(top: 10),
                          child: AnimationLimiter(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: operation.hospitalList.length>2?2: operation.hospitalList.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(milliseconds: 500),
                                    child: SlideAnimation(
                                      horizontalOffset: 400,
                                      child: FadeInAnimation(
                                        child: Container(
                                          margin: EdgeInsets.symmetric(horizontal: 10),
                                          child: HospitalTile(index: index),
                                        ),),
                                    )
                                );
                              },
                            ),
                          ),
                  ),
                  operation.hospitalList.length>2? Container(
                    width: size.width,
                    // padding: EdgeInsets.symmetric(horizontal: 10),
                    child: GestureDetector(
                      onTap: ()=> _viewAllChamberScheduleModal(context,operation),
                      child: Container(
                        child: Text("View all",textAlign: TextAlign.end,style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),),
                      ),
                    ),
                  ):Container(),
                  SizedBox(height: size.width / 40),

                  ///Add hospital button
                  Container(
                      width: size.width * .20,
                      //margin: EdgeInsets.symmetric(horizontal: 10),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddHospitals('add hospital')));
                        },
                          splashColor: Colors.cyan[200],
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: outlineIconButton(context, Icons.add, 'Add', Theme.of(context).primaryColor))),
                  //_buildTextForm("Service at", Icons.location_on,operation),
                  SizedBox(
                    height: size.width / 15,
                  ),
                ],
              ),
            ),
            SizedBox(height: size.width / 40),


          ],
        ),
      ),
    );
  }

  Widget _buildTextForm(String hint, IconData prefixIcon, DoctorProvider operation) {
    Size size=MediaQuery.of(context).size;
    return TextFormField(
      style: TextStyle(
        fontSize: size.width*.036
      ),
      maxLines: hint=='About'?4:null,
      readOnly: hint=='Phone number'?true
          :hint=='Specification'?true
          :hint=="Total Prescribed"?true
          :false,

      controller: hint=='Full name'? nameController
          :hint=='Phone number'?phoneController
          :hint=='Email address'?emailController
          :hint=='About'?aboutController
          :hint=='Year of experience'?expController
          :hint=='Appointment fee'?appFeeController
          :hint=='Specification'?specificationController
          :hint=='Degree'?degreeController
          :hint=="Total Prescribed"?totalPrescribeController
          :teleFeeController,
      initialValue: null,
      decoration: FormDecoration.copyWith(
        alignLabelWithHint: true,
          labelText: hint,
          labelStyle: TextStyle(fontSize: size.width*.033),
          prefixIcon: hint=='About' || hint=='Specification'?null: Icon(prefixIcon),
          fillColor: Color(0xffF4F7F5)),
      keyboardType: TextInputType.text,
      onChanged: (value){
        if(hint=='About') operation.doctorDetails.about=aboutController.text;
        else if(hint=='Full name') operation.doctorDetails.fullName=nameController.text;
        else if(hint=='Email address') operation.doctorDetails.email=emailController.text;
        else if(hint=='Year of experience') operation.doctorDetails.experience=expController.text;
        else if(hint=='Appointment fee') operation.doctorDetails.appFee=appFeeController.text;
        else if(hint=='Telemedicine service fee') operation.doctorDetails.teleFee=teleFeeController.text;
        else if(hint=='Specification') operation.doctorDetails.specification=specificationController.text;
        else if(hint=='Degree') operation.doctorDetails.degree=degreeController.text;
      },

    );
  }
  

  void _addSpecification(DoctorProvider operation, Size size){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context){
        Size size=MediaQuery.of(context).size;
        return AlertDialog(
          scrollable: true,
          title: Text('Add more specifications',style: TextStyle(fontSize: size.width*.039),),
          content: Container(
            child: Form(
              key: _specificFormKey,
              child: Column(
                children: [
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    style: TextStyle(fontSize: size.width*.036),
                    controller: spController,
                    validator: (val)=>val.isEmpty?'Enter specifications':null,
                    decoration: FormDecoration.copyWith(
                        alignLabelWithHint: true,
                        labelText: 'Write specifications',
                        labelStyle: TextStyle(fontSize: size.width*.033),
                        prefixIcon: null,
                        fillColor: Color(0xffF4F7F5)),
                  ),
                  SizedBox(height: size.width / 20),

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
                          fontSize: size.width*.033
                          ),
                        ),
                      ),
                      RaisedButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: () async{
                          if(_specificFormKey.currentState.validate()){
                            optSpecificationList.add(spController.text);
                            operation.loadingMgs='Adding specification...';
                            showLoadingDialog(context,operation);
                            await operation.updateDoctorSpecifications(operation, optSpecificationList, context, _scaffoldKey);
                          }
                        },
                        child: Text(
                          "Add",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: size.width*.033),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  Future<void> _getImageFromGallery(DoctorProvider operation)async{
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery,maxWidth: 300,maxHeight: 300);
    if(pickedFile!=null){
      final File _image = File(pickedFile.path);
      operation.loadingMgs='Updating profile photo...';
      showLoadingDialog(context, operation);
      await operation.updateDoctorProfilePhoto(_scaffoldKey,context, operation, _image);
    }else {
      showSnackBar(_scaffoldKey, 'No image selected', Colors.deepOrange);
    }

  }

  ///Chamber Schedule Modal
  void _viewAllChamberScheduleModal(BuildContext context,DoctorProvider drProvider){
    Size size= MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      builder: (context){
        return Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10)
              ),
              color: Colors.white
          ),
          child: Column(
            children: [
              Container(
                  width: size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                  //Color(0xffF4F7F5),
                  padding: const EdgeInsets.only(right: 15),
                  child: GestureDetector(
                    onTap: ()=>Navigator.pop(context),
                    child: Icon(Icons.clear,color: Colors.grey[100],size: 30,),
                  )
              ),

              Expanded(
                child: AnimationLimiter(
                  child: ListView.builder(
                      itemCount: drProvider.hospitalList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index){
                        return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 500),
                            child: SlideAnimation(
                              horizontalOffset: 400,
                              child: FadeInAnimation(
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: HospitalTile(index:index,fromModal: 'modal'),
                                ),),
                            )
                        );
                      }
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}

// ignore: must_be_immutable
class HospitalTile extends StatelessWidget {
  int index;String fromModal;
  HospitalTile({this.index,this.fromModal});
  @override
  Widget build(BuildContext context) {
    final TextStyle common = TextStyle(fontSize: 12,fontWeight: FontWeight.w400,color: Theme.of(context).primaryColor);
    return Consumer<DoctorProvider>(
      builder: (context, operation, child){
        Size size=MediaQuery.of(context).size;
        return ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 0,vertical: 0),
          title: Text(operation.hospitalList[index].hospitalName),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //address
              Text(operation.hospitalList[index].hospitalAddress,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),),
              Text(
                  '${operation.hospitalList[index].sat==null?'':'Sat: ${operation.hospitalList[index].sat[0]}-${operation.hospitalList[index].sat[1]}  ||  '}'
                      '${operation.hospitalList[index].sun==null?'':'Sun: ${operation.hospitalList[index].sun[0]}-${operation.hospitalList[index].sun[1]}  ||  '}'
                      '${operation.hospitalList[index].mon==null?'':'Mon: ${operation.hospitalList[index].mon[0]}-${operation.hospitalList[index].mon[1]}  ||  '}'
                      '${operation.hospitalList[index].tue==null?'':'Tue: ${operation.hospitalList[index].tue[0]}-${operation.hospitalList[index].tue[1]}  ||  '}'
                      '${operation.hospitalList[index].wed==null?'':'Wed: ${operation.hospitalList[index].wed[0]}-${operation.hospitalList[index].wed[1]}  ||  '}'
                      '${operation.hospitalList[index].thu==null?'':'Thu: ${operation.hospitalList[index].thu[0]}-${operation.hospitalList[index].thu[1]}  ||  '}'
                      '${operation.hospitalList[index].fri==null?'':'Fri: ${operation.hospitalList[index].fri[0]}-${operation.hospitalList[index].fri[1]}  ||  '}',
                style: common,
              )
              ],
          ),
          trailing: InkWell(
            onTap: (){
              if(fromModal=='modal'){
                Navigator.pop(context);
                operation.loadingMgs= 'Removing hospitals...';
                showLoadingDialog(context, operation);
                operation.removeHospitalFromDB(context, operation.hospitalList[index].id, index);
                Navigator.pop(context);

              }else{
              operation.loadingMgs= 'Removing hospitals...';
              showLoadingDialog(context, operation);
              operation.removeHospitalFromDB(context, operation.hospitalList[index].id, index);
              }
            },
            child: Icon(
              Icons.cancel_presentation,
              color: Colors.red[400],
            ),
          ),
        );
      },
    );
  }
}
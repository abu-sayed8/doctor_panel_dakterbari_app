import 'package:doctor_panel/widgets/custom_app_bar.dart';
import 'package:doctor_panel/shared/form_decoration.dart';
import 'package:doctor_panel/widgets/button_widgets.dart';
import 'package:flutter/material.dart';
import 'package:doctor_panel/providers/doctor_provider.dart';
import 'package:provider/provider.dart';
import 'package:doctor_panel/widgets/notification_widget.dart';

// ignore: must_be_immutable
class AddHospitals extends StatefulWidget {
  String identifier;
  AddHospitals(this.identifier);

  @override
  _AddHospitalsState createState() => _AddHospitalsState();
}

class _AddHospitalsState extends State<AddHospitals> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _counter=0;

  void _initializeHospitalData(DoctorProvider operation){
    setState(()=>_counter++);
    operation.hospitalModel.hospitalName='';
    operation.hospitalModel.hospitalAddress='';
    //Initialize teleService date
    operation.hospitalModel.sat=[false,TimeOfDay.now(),TimeOfDay.now()];
    operation.hospitalModel.sun=[false,TimeOfDay.now(),TimeOfDay.now()];
    operation.hospitalModel.mon=[false,TimeOfDay.now(),TimeOfDay.now()];
    operation.hospitalModel.tue=[false,TimeOfDay.now(),TimeOfDay.now()];
    operation.hospitalModel.wed=[false,TimeOfDay.now(),TimeOfDay.now()];
    operation.hospitalModel.thu=[false,TimeOfDay.now(),TimeOfDay.now()];
    operation.hospitalModel.fri=[false,TimeOfDay.now(),TimeOfDay.now()];
  }

  @override
  Widget build(BuildContext context) {
    DoctorProvider operation = Provider.of<DoctorProvider>(context);
    if(_counter==0) _initializeHospitalData(operation);
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: customAppBarDesign(context, widget.identifier=='add hospital'? "Add Hospital":'Update Tele Service Schedule'),
      body:_bodyUI(operation),
      bottomNavigationBar: _bottomNavigation(operation),
    );
  }


  Widget _bodyUI(DoctorProvider operation){
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 10,right: 10,),
      child: SingleChildScrollView(
        child: Column(
          children: [
            widget.identifier=='add hospital'?Column(
              children: [
                _headingBuilder("Add Hospital/Chamber where you stay"),
                SizedBox(height: size.width/10),

                _textFieldBuilder('Name of hospital', operation),
                SizedBox(height: size.width/20),
                _textFieldBuilder('Hospital address (country, state, city, local)', operation),
                SizedBox(height: size.width/10),
              ],
            ):operation.doctorList[0].provideTeleService? Container(
              padding: EdgeInsets.only(left: 10,right: 10,),
              child: Column(
                children: [
                  _headingBuilder("Previous Schedule"),
                  SizedBox(height: size.width/20),

                  Text(
                      '${operation.doctorList[0].sat==null?'':'Sat: ${operation.doctorList[0].sat[0]}-${operation.doctorList[0].sat[1]}  ||  '}'
                          '${operation.doctorList[0].sun==null?'':'Sun: ${operation.doctorList[0].sun[0]}-${operation.doctorList[0].sun[1]}  ||  '}'
                          '${operation.doctorList[0].mon==null?'':'Mon: ${operation.doctorList[0].mon[0]}-${operation.doctorList[0].mon[1]}  ||  '}'
                          '${operation.doctorList[0].tue==null?'':'Tue: ${operation.doctorList[0].tue[0]}-${operation.doctorList[0].tue[1]}  ||  '}'
                          '${operation.doctorList[0].wed==null?'':'Wed: ${operation.doctorList[0].wed[0]}-${operation.doctorList[0].wed[1]}  ||  '}'
                          '${operation.doctorList[0].thu==null?'':'Thu: ${operation.doctorList[0].thu[0]}-${operation.doctorList[0].thu[1]}  ||  '}'
                          '${operation.doctorList[0].fri==null?'':'Fri: ${operation.doctorList[0].fri[0]}-${operation.doctorList[0].fri[1]}  ||  '}',
                    style: TextStyle(fontSize: 16,color: Colors.grey[800]),
                  ),
                  SizedBox(height: size.width/10),
                ],
              ),
            ):Container(),

            _headingBuilder("Choose day and time schedule"),
            SizedBox(height: size.width/20),

            _availability('Sat',operation),
            _availability('Sun',operation),
            _availability('Mon',operation),
            _availability('Tue',operation),
            _availability('Wed',operation),
            _availability('Thu',operation),
            _availability('Fri',operation),

            widget.identifier=='add hospital'? Container()
                :Container(
              margin: EdgeInsets.only(left: 10,right: 10,top: size.width/20),
              child: Text(
                  'Note: Previous schedule will be removed and currently selected schedule considered as final and updated schedule.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: size.width*.033,color: Color(0xffF0A732)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _headingBuilder(String heading){
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.topCenter,
      child: Text(heading,style: TextStyle(
          fontSize: size.width*.042,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).primaryColor),),
    );
  }

  Widget _bottomNavigation(DoctorProvider operation) {
    Size size = MediaQuery.of(context).size;
    return widget.identifier=='add hospital'? Container(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 5),
        height: size.width*.15,
        color: Colors.white,
        child: GestureDetector(
          onTap: ()=> _checkValidity(operation),
          child: bigFillButton(context, 'Add Hospital/Chamber', Icons.add),
        ),
    )
        :Container(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 5),
      height: size.width*.15,
      color: Colors.white,
      child: GestureDetector(
        onTap: ()=> _updateTeleSchedule(operation),
        child: bigFillButton(context, 'Update Schedule', Icons.update),
      ),
    );
  }

  Widget _textFieldBuilder(String hint,DoctorProvider operation){
    Size size=MediaQuery.of(context).size;
    return TextFormField(
      textCapitalization: TextCapitalization.words,
      keyboardType:TextInputType.text,
      style: TextStyle(fontSize: size.width*.036),
      onChanged: (val){
        setState(() {
          hint=='Name of hospital'? operation.hospitalModel.hospitalName=val
              :operation.hospitalModel.hospitalAddress=val;
        });
      },
      decoration: FormDecoration.copyWith(
          labelText: hint,
          labelStyle: TextStyle(fontSize: size.width*.033),
          hintStyle: TextStyle(fontSize: size.width*.034),
          fillColor: Color(0xffF4F7F5),
          prefixIcon:null,
          suffixIcon:null
      ),
    );
  }

  Widget _availability(String day,DoctorProvider operation){
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      //padding: EdgeInsets.symmetric(horizontal: 10),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //Day Check Button
          Row(
            children: [
              Checkbox(
                value: day=='Sat'?operation.hospitalModel.sat[0]:day=='Sun'?operation.hospitalModel.sun[0]:day=='Mon'?operation.hospitalModel.mon[0]:
                day=='Tue'?operation.hospitalModel.tue[0]:day=='Wed'?operation.hospitalModel.wed[0]:day=='Thu'?operation.hospitalModel.thu[0]:
                operation.hospitalModel.fri[0],
                onChanged: (bool checkedValue) {
                  setState(() =>
                  day=='Sat'?operation.hospitalModel.sat[0] = checkedValue:
                  day=='Sun'?operation.hospitalModel.sun[0]= checkedValue:
                  day=='Mon'?operation.hospitalModel.mon[0]= checkedValue:
                  day=='Tue'?operation.hospitalModel.tue[0]= checkedValue:
                  day=='Wed'?operation.hospitalModel.wed[0]= checkedValue:
                  day=='Thu'?operation.hospitalModel.thu[0]= checkedValue:
                  operation.hospitalModel.fri[0]= checkedValue);
                },
              ),
              Text(
                day,
                style: TextStyle(
                    fontSize: size.width*.032,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800]),
              )
            ],
          ),
          //Time Button
          Row(
            children: [
              FlatButton(
                onPressed: (){
                  _selectTime(context, 'from', day,operation);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  height: 30,
                  decoration: BoxDecoration(
                      color: Color(0xffF4F7F5),
                      borderRadius: BorderRadius.all(Radius.circular(5))
                  ),
                  child: Row(
                    children: [
                      Text(day=="Sat"?'${operation.hospitalModel.sat[1].hour}:${operation.hospitalModel.sat[1].minute}':
                      day=="Sun"?'${operation.hospitalModel.sun[1].hour}:${operation.hospitalModel.sun[1].minute}':
                      day=="Mon"?'${operation.hospitalModel.mon[1].hour}:${operation.hospitalModel.mon[1].minute}':
                      day=="Tue"?'${operation.hospitalModel.tue[1].hour}:${operation.hospitalModel.tue[1].minute}':
                      day=="Wed"?'${operation.hospitalModel.wed[1].hour}:${operation.hospitalModel.wed[1].minute}':
                      day=="Thu"?'${operation.hospitalModel.thu[1].hour}:${operation.hospitalModel.thu[1].minute}':
                      '${operation.hospitalModel.fri[1].hour}:${operation.hospitalModel.fri[1].minute}',
                        style: TextStyle(fontSize: size.width*.03,),),

                      Icon(Icons.arrow_drop_down_outlined,color: Theme.of(context).primaryColor)
                    ],
                  ),
                ),
              ),
              Text("to",style: TextStyle(fontSize: size.width*.03),),
              FlatButton(
                onPressed: (){
                  _selectTime(context, 'to', day, operation);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  height: 30,
                  decoration: BoxDecoration(
                      color: Color(0xffF4F7F5),
                      borderRadius: BorderRadius.all(Radius.circular(5))
                  ),
                  child: Row(
                    children: [
                      Text(day=="Sat"?'${operation.hospitalModel.sat[2].hour}:${operation.hospitalModel.sat[2].minute}':
                      day=="Sun"?'${operation.hospitalModel.sun[2].hour}:${operation.hospitalModel.sun[2].minute}':
                      day=="Mon"?'${operation.hospitalModel.mon[2].hour}:${operation.hospitalModel.mon[2].minute}':
                      day=="Tue"?'${operation.hospitalModel.tue[2].hour}:${operation.hospitalModel.tue[2].minute}':
                      day=="Wed"?'${operation.hospitalModel.wed[2].hour}:${operation.hospitalModel.wed[2].minute}':
                      day=="Thu"?'${operation.hospitalModel.thu[2].hour}:${operation.hospitalModel.thu[2].minute}':
                      '${operation.hospitalModel.fri[2].hour}:${operation.hospitalModel.fri[2].minute}',
                        style: TextStyle(fontSize: size.width*.03,),),

                      Icon(Icons.arrow_drop_down_outlined,color: Theme.of(context).primaryColor)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _selectTime(BuildContext context, String identifier,String day,DoctorProvider operation) async{
    if(identifier=="from"){
      switch(day){
        case 'Sat':
          final TimeOfDay picked = await showTimePicker(
            context: context,
            initialTime: operation.hospitalModel.sat[1],
          );
          if(picked!=null && picked!=operation.hospitalModel.sat[1]){
            setState(() =>operation.hospitalModel.sat[1] = picked);
          }
          break;
        case 'Sun':
          final TimeOfDay picked = await showTimePicker(
            context: context,
            initialTime: operation.hospitalModel.sun[1],
          );
          if(picked!=null && picked!=operation.hospitalModel.sun[1]){
            setState(() =>operation.hospitalModel.sun[1] = picked);
          }
          break;
        case 'Mon':
          final TimeOfDay picked = await showTimePicker(
            context: context,
            initialTime: operation.hospitalModel.mon[1],
          );
          if(picked!=null && picked!=operation.hospitalModel.mon[1]){
            setState(() =>operation.hospitalModel.mon[1] = picked);
          }
          break;
        case 'Tue':
          final TimeOfDay picked = await showTimePicker(
            context: context,
            initialTime: operation.hospitalModel.tue[1],
          );
          if(picked!=null && picked!=operation.hospitalModel.tue[1]){
            setState(() =>operation.hospitalModel.tue[1] = picked);
          }
          break;
        case 'Wed':
          final TimeOfDay picked = await showTimePicker(
            context: context,
            initialTime: operation.hospitalModel.wed[1],
          );
          if(picked!=null && picked!=operation.hospitalModel.wed[1]){
            setState(() =>operation.hospitalModel.wed[1] = picked);
          }
          break;
        case 'Thu':
          final TimeOfDay picked = await showTimePicker(
            context: context,
            initialTime: operation.hospitalModel.thu[1],
          );
          if(picked!=null && picked!=operation.hospitalModel.thu[1]){
            setState(() =>operation.hospitalModel.thu[1] = picked);
          }
          break;
        default:
          final TimeOfDay picked = await showTimePicker(
            context: context,
            initialTime: operation.hospitalModel.fri[1],
          );
          if(picked!=null && picked!=operation.hospitalModel.fri[1]){
            setState(() =>operation.hospitalModel.fri[1] = picked);
          }
          break;

      }
    }else{
      switch(day){
        case 'Sat':
          final TimeOfDay picked = await showTimePicker(
            context: context,
            initialTime: operation.hospitalModel.sat[2],
          );
          if(picked!=null && picked!=operation.hospitalModel.sat[2]){
            setState(() =>operation.hospitalModel.sat[2] = picked);
          }
          break;
        case 'Sun':
          final TimeOfDay picked = await showTimePicker(
            context: context,
            initialTime: operation.hospitalModel.sun[2],
          );
          if(picked!=null && picked!=operation.hospitalModel.sun[2]){
            setState(() =>operation.hospitalModel.sun[2] = picked);
          }
          break;
        case 'Mon':
          final TimeOfDay picked = await showTimePicker(
            context: context,
            initialTime: operation.hospitalModel.mon[2],
          );
          if(picked!=null && picked!=operation.hospitalModel.mon[2]){
            setState(() =>operation.hospitalModel.mon[2] = picked);
          }
          break;
        case 'Tue':
          final TimeOfDay picked = await showTimePicker(
            context: context,
            initialTime: operation.hospitalModel.tue[2],
          );
          if(picked!=null && picked!=operation.hospitalModel.tue[2]){
            setState(() =>operation.hospitalModel.tue[2] = picked);
          }
          break;
        case 'Wed':
          final TimeOfDay picked = await showTimePicker(
            context: context,
            initialTime: operation.hospitalModel.wed[2],
          );
          if(picked!=null && picked!=operation.hospitalModel.wed[2]){
            setState(() =>operation.hospitalModel.wed[2] = picked);
          }
          break;
        case 'Thu':
          final TimeOfDay picked = await showTimePicker(
            context: context,
            initialTime: operation.hospitalModel.thu[2],
          );
          if(picked!=null && picked!=operation.hospitalModel.thu[2]){
            setState(() =>operation.hospitalModel.thu[2] = picked);
          }
          break;
        default:
          final TimeOfDay picked = await showTimePicker(
            context: context,
            initialTime: operation.hospitalModel.fri[2],
          );
          if(picked!=null && picked!=operation.hospitalModel.fri[2]){
            setState(() =>operation.hospitalModel.fri[2] = picked);
          }
          break;

      }
    }
  }

  void _checkValidity(DoctorProvider operation)async{
    if(operation.hospitalModel.hospitalName.isNotEmpty && operation.hospitalModel.hospitalAddress.isNotEmpty){
      operation.loadingMgs='Adding hospital/chamber...';
      showLoadingDialog(context, operation);
      await operation.insertHospital(operation, context, _scaffoldKey);
    }else showSnackBar(_scaffoldKey,'Enter hospital name & address', Colors.deepOrange);
  }

  void _updateTeleSchedule(DoctorProvider operation)async{
    operation.loadingMgs='Updating telemedicine service schedule...';
    showLoadingDialog(context, operation);
    await operation.updateTeleSchedule(operation, context, _scaffoldKey);
  }
}

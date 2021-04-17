import 'package:doctor_panel/widgets/custom_app_bar.dart';
import 'package:doctor_panel/shared/form_decoration.dart';
import 'package:flutter/material.dart';

class AddServices extends StatefulWidget {
  @override
  _AddServicesState createState() => _AddServicesState();
}

class _AddServicesState extends State<AddServices> {
  bool hyperchk= false;
  bool copdchk= false;
  bool diabeticschk= false;
  bool ecgchk= false;
  bool obesitychk= false;
  bool hltcheckupchk= false;
  bool feverchk= false;
  bool nonIntervensionchk= false;
  bool diabetologychk= false;
  bool mentalTreatchk= false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   centerTitle: true,
      //   title: Text("Add Service"),
      // ),
      appBar: customAppBarDesign(context, "Add Service"),
      body: _bodyUI(),
      bottomNavigationBar: _bottomNavigation(),
    );
  }

  Widget _bodyUI(){
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(left: 10,right: 10,),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.phone,
              decoration: FormDecoration.copyWith(
                  hintText: 'Search Services', fillColor: Colors.grey[100],prefixIcon: Icon(Icons.search_rounded)),
            ),
            SizedBox(height: size.width/20),
            Container(
              alignment: Alignment.topLeft,
              child: Text("Select services to add",style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor),),
            ),
            SizedBox(height: size.width/20),

            _buildServicesTag('Hypertension Treatment'),
            _buildServicesTag('COPD Treatment'),
            _buildServicesTag('Diabetes Management'),
            _buildServicesTag('ECG'),
            _buildServicesTag('Obesity Treatment'),
            _buildServicesTag('Health Checkup (General)'),
            _buildServicesTag('Fever Treatment'),
            _buildServicesTag('Non Interventional Cardiology'),
            _buildServicesTag('Diabetology'),
            _buildServicesTag('Mental Treatment'),

          ],
        ),
      ),
    );
  }

  Widget _buildServicesTag(String serviceName){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          value: serviceName=='Hypertension Treatment'?hyperchk:
          serviceName=='COPD Treatment'?copdchk:
          serviceName=='Diabetes Management'?diabeticschk:
          serviceName=='ECG'?ecgchk:
          serviceName=='Obesity Treatment'?obesitychk:
          serviceName=='Health Checkup (General)'?hltcheckupchk:
          serviceName=='Fever Treatment'?feverchk:
          serviceName=='Non Interventional Cardiology'?nonIntervensionchk:
          serviceName=='Diabetology'?diabetologychk: mentalTreatchk,

          onChanged: (bool checkedValue) {
            setState(() => serviceName=='Hypertension Treatment'?hyperchk=checkedValue:
            serviceName=='COPD Treatment'?copdchk=checkedValue:
            serviceName=='Diabetes Management'?diabeticschk=checkedValue:
            serviceName=='ECG'?ecgchk=checkedValue:
            serviceName=='Obesity Treatment'?obesitychk=checkedValue:
            serviceName=='Health Checkup (General)'?hltcheckupchk=checkedValue:
            serviceName=='Fever Treatment'?feverchk=checkedValue:
            serviceName=='Non Interventional Cardiology'?nonIntervensionchk=checkedValue:
            serviceName=='Diabetology'?diabetologychk=checkedValue: mentalTreatchk=checkedValue,);
          },
        ),

        Text(
          serviceName,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800]),
        ),

      ],
    );
  }

  Widget _bottomNavigation() {
    Size size = MediaQuery.of(context).size;
    return Container(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 5),
        height: size.width*.15,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //SizedBox(height: size.width / 15),
            GestureDetector(
              onTap: () {},
              child: Material(
                elevation: 2,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Container(
                  width: size.width,
                  height: size.width / 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.update,color: Colors.white,),
                      SizedBox(width: 10),
                      Text(
                        "Update Services",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

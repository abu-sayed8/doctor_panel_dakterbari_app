import 'package:doctor_panel/providers/medicine_provider.dart';
import 'package:doctor_panel/widgets/custom_app_bar.dart';
import 'package:doctor_panel/shared/form_decoration.dart';
import 'package:doctor_panel/shared/static_variable_page.dart';
import 'package:doctor_panel/widgets/button_widgets.dart';
import 'package:doctor_panel/widgets/notification_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddMedicine extends StatefulWidget {
  @override
  _AddMedicineState createState() => _AddMedicineState();
}

class _AddMedicineState extends State<AddMedicine> {
  int _counter=0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _initializeData(MedicineProvider provider){
    setState(()=>_counter++);
    provider.medicineModel.name='';
    provider.medicineModel.strength='';
    provider.medicineModel.genericName='';
    provider.medicineModel.manufacturer='';
    provider.medicineModel.price='';
    provider.medicineModel.indications='';
    provider.medicineModel.adultDose='';
    provider.medicineModel.childDose='';
    provider.medicineModel.renalDose='';
    provider.medicineModel.administration='';
    provider.medicineModel.contradiction='';
    provider.medicineModel.sideEffect='';
    provider.medicineModel.precautions='';
    provider.medicineModel.pregnancy='';
    provider.medicineModel.therapeutic='';
    provider.medicineModel.modeOfAction='';
    provider.medicineModel.interaction='';
    provider.medicineModel.darNo='';
    provider.medicineModel.dosage=null;
  }

  @override
  Widget build(BuildContext context) {
    final MedicineProvider provider = Provider.of<MedicineProvider>(context);
    if(_counter==0) _initializeData(provider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: customAppBarDesign(context, "Add New Medicine"),
      body: _bodyUI(provider),
    );
  }

  Widget _bodyUI(MedicineProvider provider) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 3),
            _textFormBuilder("Medicine Name",provider),
            SizedBox(height: 20),
            _textFormBuilder('Generic Name',provider),
            SizedBox(height: 20),
            _textFormBuilder('Strength in mg/ml',provider),
            SizedBox(height: 20),
            ///Dosage Dropdown...
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                  color: Color(0xffF4F7F5),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              width: size.width,
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  value: provider.medicineModel.dosage,
                  isExpanded: true,
                  hint: Text("Select Dosage",
                      style: TextStyle(
                          color: Colors.grey[700], fontSize: 16)),
                  items: StaticVariables.dosageList.map((category) {
                    return DropdownMenuItem(
                      child: Text(category,
                          style: TextStyle(
                            color: Colors.grey[900],
                            fontSize: 16,
                          )),
                      value: category,
                    );
                  }).toList(),
                  onChanged: (newValue) =>
                      setState(() => provider.medicineModel.dosage = newValue),
                  dropdownColor: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            _textFormBuilder('Manufacturer',provider),
            SizedBox(height: 20),
            _textFormBuilder('Price',provider),
            SizedBox(height: 20),
            _textFormBuilder('Dar. No',provider),
            SizedBox(height: 20),
            _textFormBuilder('Indications',provider),
            SizedBox(height: 20),
            _textFormBuilder('Adult dose',provider),
            SizedBox(height: 20),
            _textFormBuilder('Child dose',provider),
            SizedBox(height: 20),
            _textFormBuilder('Renal dose',provider),
            SizedBox(height: 20),
            _textFormBuilder('Administration',provider),
            SizedBox(height: 20),
            _textFormBuilder('Contradiction',provider),
            SizedBox(height: 20),
            _textFormBuilder('Side effect',provider),
            SizedBox(height: 20),
            _textFormBuilder('Precautions & Warnings',provider),
            SizedBox(height: 20),
            _textFormBuilder('Pregnancy & Lactation',provider),
            SizedBox(height: 20),
            _textFormBuilder('Therapeutic class',provider),
            SizedBox(height: 20),
            _textFormBuilder('Mode of action',provider),
            SizedBox(height: 20),
            _textFormBuilder('Interaction',provider),
            SizedBox(height: 20),

            ///Submit Button...
            GestureDetector(
              onTap: ()=>_checkValidity(provider),
              child: Button(context, "Submit  Medicine"),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _textFormBuilder(String hint,MedicineProvider provider) {
    return TextFormField(
      textCapitalization: hint=="Medicine Name" || hint=='Generic Name'|| hint=='Manufacturer'? TextCapitalization.words :TextCapitalization.sentences,
      keyboardType: hint == 'Price' ? TextInputType.number :TextInputType.text,
      decoration: FormDecorationWithoutPrefix.copyWith(
          alignLabelWithHint: true,
          labelText: hint, fillColor: Color(0xffF4F7F5),
          hintText: ''
      ),
      maxLines: hint=="Medicine Name" || hint=='Generic Name'|| hint=='Price'
          || hint=='Strength in mg/ml' ||hint=='Dar. No'? 1:4,
      onChanged: (val) {
        if(hint=="Medicine Name") provider.medicineModel.name=val;
        if(hint=='Generic Name') provider.medicineModel.genericName=val;
        if(hint=='Strength in mg/ml') provider.medicineModel.strength=val;
        if(hint=='Manufacturer') provider.medicineModel.manufacturer=val;
        if(hint=='Price') provider.medicineModel.price=val;
        if(hint=='Dar. No') provider.medicineModel.darNo=val;
        if(hint=='Indications') provider.medicineModel.indications=val;
        if(hint=='Adult dose') provider.medicineModel.adultDose=val;
        if(hint=='Child dose') provider.medicineModel.childDose=val;
        if(hint=='Renal dose') provider.medicineModel.renalDose=val;
        if(hint=='Administration') provider.medicineModel.administration=val;
        if(hint=='Contradiction') provider.medicineModel.contradiction=val;
        if(hint=='Side effect') provider.medicineModel.sideEffect=val;
        if(hint=='Precautions & Warnings') provider.medicineModel.precautions=val;
        if(hint=='Pregnancy & Lactation') provider.medicineModel.pregnancy=val;
        if(hint=='Therapeutic class') provider.medicineModel.therapeutic=val;
        if(hint=='Mode of action') provider.medicineModel.modeOfAction=val;
        if(hint=='Interaction') provider.medicineModel.interaction=val;
      },
    );
  }

  void _checkValidity(MedicineProvider provider){
    if( provider.medicineModel.name.isNotEmpty&&
        provider.medicineModel.genericName.isNotEmpty&&
        provider.medicineModel.strength.isNotEmpty&&
        provider.medicineModel.manufacturer.isNotEmpty&&
        provider.medicineModel.price.isNotEmpty&&
        provider.medicineModel.darNo.isNotEmpty&&
        provider.medicineModel.indications.isNotEmpty&&
        provider.medicineModel.adultDose.isNotEmpty&&
        provider.medicineModel.childDose.isNotEmpty&&
        provider.medicineModel.renalDose.isNotEmpty&&
        provider.medicineModel.administration.isNotEmpty&&
        provider.medicineModel.contradiction.isNotEmpty&&
        provider.medicineModel.sideEffect.isNotEmpty&&
        provider.medicineModel.precautions.isNotEmpty&&
        provider.medicineModel.pregnancy.isNotEmpty&&
        provider.medicineModel.therapeutic.isNotEmpty&&
        provider.medicineModel.modeOfAction.isNotEmpty&&
        provider.medicineModel.interaction.isNotEmpty &&
        provider.medicineModel.dosage!=null){
        provider.loadingMgs='Submitting medicine...';
      showLoadingDialog(context,provider);
      provider.submitMedicine(provider, context, _scaffoldKey);
    }else showSnackBar(_scaffoldKey,'Field can\'t be empty', Colors.deepOrange);
  }
}

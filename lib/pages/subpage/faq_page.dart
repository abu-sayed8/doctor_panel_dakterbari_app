import 'package:doctor_panel/pages/subpage/update_faq_page.dart';
import 'package:doctor_panel/providers/doctor_provider.dart';
import 'package:doctor_panel/widgets/custom_app_bar.dart';
import 'package:doctor_panel/shared/static_variable_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class FAQPage extends StatefulWidget {
  @override
  _FAQPageState createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  @override
  Widget build(BuildContext context) {
    //final FirebaseOperation operation = Provider.of<FirebaseOperation>(context);
    return Consumer<DoctorProvider>(
      builder: (context, operation,child){
        return Scaffold(
          backgroundColor: Colors.white,
          //backgroundColor: Color(0xffF4F7F5),
          appBar: customAppBarDesign(context, "FAQ"),
          body: AnimationLimiter(
            child: ListView.builder(
              itemCount: faqDataList(operation).length,
              itemBuilder: (context, index){
                return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                      verticalOffset: 400,
                      child: FadeInAnimation(
                        child: EntryItemTile(
                            faqDataList(operation)[index]
                        ),
                      ),
                    )
                );},
            ),
          ),

          floatingActionButton: FloatingActionButton(
            onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdateFAQ())),
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(Icons.update_rounded,color: Colors.white,size: 30,),
            tooltip: "Update Faq's",
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        );
      },
    );
  }
}

///Create the widget for the row...
class EntryItemTile extends StatelessWidget {
  final Entry entry;

  const EntryItemTile(this.entry);

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty) {
      return ListTile(
        title: Text(root.title,style: TextStyle(color: Colors.grey[800],fontSize: 13)),
      );
    }
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: Text(root.title,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14)),
      children: root.children.map<Widget>(_buildTiles).toList(),
    );
  }
  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}

import 'package:connectivity/connectivity.dart';
import 'package:doctor_panel/pages/account_page.dart';
import 'package:doctor_panel/pages/all_prescription_page.dart';
import 'package:doctor_panel/pages/appointments_page.dart';
import 'package:doctor_panel/pages/blog_page.dart';
import 'package:doctor_panel/pages/forum_page.dart';
import 'package:doctor_panel/pages/medicine_page.dart';
import 'package:doctor_panel/pages/review_page.dart';
import 'package:doctor_panel/pages/support_center_page.dart';
import 'package:doctor_panel/providers/article_provider.dart';
import 'package:doctor_panel/providers/forum_provider.dart';
import 'package:doctor_panel/widgets/custom_app_bar.dart';
import 'package:doctor_panel/widgets/button_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doctor_panel/providers/doctor_provider.dart';
import 'package:doctor_panel/providers/medicine_provider.dart';
import 'package:doctor_panel/widgets/notification_widget.dart';
import 'package:doctor_panel/providers/appointment_provider.dart';
import 'package:doctor_panel/providers/review_provider.dart';
import 'package:doctor_panel/pages/notifications_page.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isConnected = true;
  int _counter=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkConnectivity();
  }

  void _checkConnectivity() async {
    var result = await (Connectivity().checkConnectivity());
    if (result == ConnectivityResult.none) {
      setState(() => _isConnected = false);
      showSnackBar(_scaffoldKey,"No internet connection !", Colors.deepOrange);
    } else if (result == ConnectivityResult.mobile) {
      setState(() => _isConnected = true);
    } else if (result == ConnectivityResult.wifi) {
      setState(() => _isConnected = true);
    }
  }

  Future<void> _initializeLists(DoctorProvider drProvider,MedicineProvider mProvider,
      ArticleProvider articleProvider,ForumProvider forumProvider,
      ReviewProvider reviewProvider,AppointmentProvider appProvider)async{
      setState(()=> _counter++);
      await drProvider.getDoctor().then((value)async{
      await drProvider.getHospitals();
      await drProvider.getFaq();
      await appProvider.getAppointmentList();
      await appProvider.getPrescriptionList();
      await mProvider.getMedicine();
      await articleProvider.getAllArticle();
      await articleProvider.getPopularArticle();
      await forumProvider.getAllQuestionList();
      await drProvider.getNotification();
      await reviewProvider.getTotalAppointment();
      await reviewProvider.getAllReview();
      reviewProvider.getOneStar();

      drProvider.doctorDetails=null;
    });
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final DoctorProvider drProvider = Provider.of<DoctorProvider>(context);
    final MedicineProvider mProvider = Provider.of<MedicineProvider>(context);
    final ArticleProvider articleProvider = Provider.of<ArticleProvider>(context);
    final ForumProvider forumProvider = Provider.of<ForumProvider>(context);
    final ReviewProvider reviewProvider = Provider.of<ReviewProvider>(context);
    final AppointmentProvider appProvider = Provider.of<AppointmentProvider>(context);

    if(_counter==0 || drProvider.doctorList.isEmpty) _initializeLists(drProvider,mProvider, articleProvider, forumProvider,reviewProvider,appProvider);

    return Scaffold(
      key: _scaffoldKey,
      //backgroundColor: Color(0xffF4F7F5),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: customAppBarDesign(context, 'Dakterbari | ডাক্তারবাড়ি'),
      body: _isConnected ?
      _bodyUI(size, drProvider, mProvider, articleProvider, forumProvider,reviewProvider,appProvider)
          : _noInternetUI(),
    );

  }

  Widget _bodyUI(Size size, DoctorProvider drProvider, MedicineProvider mProvider,
      ArticleProvider articleProvider, ForumProvider forumProvider,ReviewProvider reviewProvider,AppointmentProvider appProvider) {
    return Container(
      width: size.width,
      height: size.height,
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: size.width,
            height: size.width * .35,
            decoration: BoxDecoration(
                color: Color(0xffF4F7F5),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome to",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Image.asset('assets/logo.png')
              ],
            ),
          ),
          Expanded(
              child: RefreshIndicator(
                backgroundColor: Colors.white,
                onRefresh: ()=> _initializeLists(drProvider, mProvider, articleProvider, forumProvider,reviewProvider,appProvider),
                child: AnimationLimiter(
                  child: GridView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        crossAxisCount: 3,
                      ),
                      itemCount: 9,
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 500),
                            child: SlideAnimation(
                              verticalOffset: 400,
                              child: FadeInAnimation(
                                child: GridBuilderTile(size:size, index:index),),
                            )
                        );
                      }),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _noInternetUI() {
    return Container(
      color: Colors.white70,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/logo.png",
            height: 50,
            //width: 100,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 40),
          Icon(
            CupertinoIcons.wifi_exclamationmark,
            color: Colors.orange[300],
            size: 150,
          ),
          Text(
            'No Internet Connection !',
            style: TextStyle(fontSize: 16, color: Colors.grey[800]),
          ),
          Text(
            'Connect your device with wifi or cellular data',
            style: TextStyle(fontSize: 15, color: Colors.grey[600]),
          ),
          SizedBox(height: 20),
          Text(
            "For emergency call 16263",
            style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () => _checkConnectivity(),
            splashColor: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Container(
                width: MediaQuery.of(context).size.width * .25,
                child: miniOutlineIconButton(
                    context, 'Refresh', Icons.refresh, Colors.grey)),
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class GridBuilderTile extends StatelessWidget {
  int index;
  Size size;

  GridBuilderTile({this.size, this.index});

  @override
  Widget build(BuildContext context) {
    final DoctorProvider drProvider = Provider.of<DoctorProvider>(context);
    final MedicineProvider medicineProvider = Provider.of<MedicineProvider>(context);
    final ArticleProvider articleProvider = Provider.of<ArticleProvider>(context);
    final ForumProvider forumProvider = Provider.of<ForumProvider>(context);

    return InkWell(
      onTap: () async{

        ///Appointment Page
        if (index == 0) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Appointments()));
        }

        ///Prescription Page
        if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AllPrescription()));
        }

        ///Review Page
        if (index == 2) {
          if(drProvider.doctorList.isEmpty){
            drProvider.loadingMgs='Please wait...';
            showLoadingDialog(context,drProvider);
            await drProvider.getDoctor().then((value) async{
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => Reviews()));
            });
          }else
            Navigator.push(context, MaterialPageRoute(builder: (context) => Reviews()));


        }

        ///Medicine Page
        if (index == 3) {
          if(medicineProvider.medicineList.isEmpty){
            medicineProvider.loadingMgs='Please wait...';
            showLoadingDialog(context, medicineProvider);
            await medicineProvider.getMedicine().then((value){
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MedicinePage()));
            });
          }else Navigator.push(context,
              MaterialPageRoute(builder: (context) => MedicinePage()));

        }

        ///Blog Page
        if (index == 4) {
          if(articleProvider.allArticleList.isEmpty){
            articleProvider.loadingMgs='Please wait...';
            showLoadingDialog(context, articleProvider);

            await articleProvider.getAllArticle().then((value)async{
              await articleProvider.getPopularArticle().then((value){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => BlogPage()));
              });
            });
          }else{
            Navigator.push(context, MaterialPageRoute(builder: (context) => BlogPage()));
          }

        }

        ///Account Page
        if (index == 5) {
          if(drProvider.doctorList.isEmpty){
            //operation.isLoading=true;
            drProvider.loadingMgs='Please wait...';
            showLoadingDialog(context, drProvider);
            await drProvider.getDoctor().then((value)async{
              await drProvider.getHospitals();
              await drProvider.getFaq();
              drProvider.doctorDetails=null;
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Account()));
            });
          }else {
            drProvider.doctorDetails=null;
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Account()));
          }
        }

        ///Forum Page
        if (index == 6) {
          if(drProvider.doctorList.isEmpty || forumProvider.allQuesList.isEmpty){
            forumProvider.loadingMgs='Please wait...';
            showLoadingDialog(context, forumProvider);
            await drProvider.getDoctor().then((value)async{
              await forumProvider.getAllQuestionList().then((value){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => ForumPage()));
              });
            });
          }else
          Navigator.push(context, MaterialPageRoute(builder: (context) => ForumPage()));
        }

        ///Notifications
        if(index==7) Navigator.push(context, MaterialPageRoute(builder: (context)=>Notifications()));

        ///Support Center
        if (index == 8) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SupportCenter()));
        }
      },

      splashColor: Theme.of(context).primaryColor,
      child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(alignment: Alignment.center, children: [
                Container(
                  height: size.width*.17,
                  width: size.width*.17,
                  decoration: BoxDecoration(
                    color: Color(0xffF4F7F5),
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: index == 0
                          ? AssetImage('assets/home_icon/appointment.png')
                          : index == 1
                          ? AssetImage('assets/home_icon/prescription.png')
                          : index == 2
                          ? AssetImage('assets/home_icon/review.png')
                          : index == 3
                          ? AssetImage('assets/home_icon/medicine.png')
                          : index == 4
                          ? AssetImage('assets/home_icon/blog.png')
                          : index == 5
                          ? AssetImage('assets/home_icon/account.png')
                          : index == 6
                          ? AssetImage('assets/home_icon/forum.png')
                          : index==7? AssetImage('assets/home_icon/notifications.png')
                          : AssetImage(
                          'assets/home_icon/support.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  height: size.width*.09,
                  width: size.width*.09,
                ),
              ]),
              SizedBox(height: 5),
              Text(
                index == 0
                    ? 'Appointment'
                    : index == 1
                    ? 'Prescription'
                    : index == 2
                    ? 'Review'
                    : index == 3
                    ? 'Medicine'
                    : index == 4
                    ? 'Blog'
                    : index == 5
                    ? 'Account'
                    : index == 6
                    ? 'Forum':
                    index==7? 'Notifications'
                    : 'Support Center',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).primaryColor, //Color(0xff00C5A4),
                    fontSize: size.width*.04,
                    fontWeight: FontWeight.bold),
              )
            ],
          )),
    );
  }
}

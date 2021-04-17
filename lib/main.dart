import 'package:country_code_picker/country_localizations.dart';
import 'package:doctor_panel/pages/home_page.dart';
import 'package:doctor_panel/pages/login_page.dart';
import 'package:doctor_panel/providers/doctor_provider.dart';
import 'package:doctor_panel/providers/forum_provider.dart';
import 'package:doctor_panel/providers/reg_auth_provider.dart';
import 'package:doctor_panel/providers/medicine_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doctor_panel/providers/article_provider.dart';
import 'package:doctor_panel/providers/appointment_provider.dart';
import 'package:doctor_panel/providers/review_provider.dart';
import 'package:doctor_panel/splash_screen_package/animation_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await firebase_core.Firebase.initializeApp();
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<int, Color> color = {
    //RGB Color Code (0, 194, 162)
    50: Color.fromRGBO(0, 197, 164, .1),
    100: Color.fromRGBO(0, 197, 164, .2),
    200: Color.fromRGBO(0, 197, 164, .3),
    300: Color.fromRGBO(0, 197, 164, .4),
    400: Color.fromRGBO(0, 197, 164, .5),
    500: Color.fromRGBO(0, 197, 164, .6),
    600: Color.fromRGBO(0, 197, 164, .7),
    700: Color.fromRGBO(0, 197, 164, .8),
    800: Color.fromRGBO(0, 197, 164, .9),
    900: Color.fromRGBO(0, 197, 164, 1),
  };
  String id;
  String pass;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkPreferences();
  }

  void _checkPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.get('id');
      //pass = preferences.get('pass');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RegAuth(),),
        ChangeNotifierProvider(create: (context) => DoctorProvider(),),
        ChangeNotifierProvider(create: (context) => MedicineProvider(),),
        ChangeNotifierProvider(create: (context) => ArticleProvider(),),
        ChangeNotifierProvider(create: (context) => AppointmentProvider(),),
        ChangeNotifierProvider(create: (context) => ReviewProvider(),),
        ChangeNotifierProvider(create: (context) => ForumProvider(),),

      ],
      child: MaterialApp(
        //for country code picker
        supportedLocales: [
          Locale('en', 'US'),
        ],
          localizationsDelegates: [
            CountryLocalizations.delegate,
          ],
        title: 'DakterBari',
        theme: ThemeData(
            primarySwatch: MaterialColor(0xff00C5A4, color),
            //HEX Color Code(0xff00C5A4)
            visualDensity: VisualDensity.adaptivePlatformDensity,
            canvasColor: Colors.transparent,
            cursorColor: Colors.black,
            // //BottomNavigationBar Theme...
            // bottomNavigationBarTheme: BottomNavigationBarThemeData(
            //   backgroundColor: Colors.transparent,
            //   elevation: 50,
            //   showUnselectedLabels: true,
            //   unselectedIconTheme: IconThemeData(color: Colors.grey[800]),
            // )
        ),
        debugShowCheckedModeBanner: false,
        home: Material(
          child: Stack(
            children: [
              id == null? LogIn() : HomePage(),
              IgnorePointer(
                  child: AnimationScreen(
                    color: Color(0xff00C5A4),
                    appName: 'Dakterbari',
                  )
              )
            ],
          ),
        ) //id == null? LogIn() : HomePage(),
      ),
    );
  }
}

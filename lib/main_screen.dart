// import 'package:doctor_panel/pages/account_page.dart';
// import 'package:doctor_panel/pages/medicine_page.dart';
// import 'package:doctor_panel/pages/appointments_page.dart';
// import 'package:doctor_panel/pages/blog_page.dart';
// import 'package:doctor_panel/pages/review_page.dart';
// import 'package:flutter/material.dart';
//
// class MainScreen extends StatefulWidget {
//   @override
//   _MainScreenState createState() => _MainScreenState();
// }
//
// class _MainScreenState extends State<MainScreen> {
//   int currentTabIndex = 0;
//   List<Widget> pages;
//   Widget currentPage;
//
//   Appointments appointments;
//   Reviews reviews;
//   MedicinePage medicine;
//   BlogPage blogPage;
//   Account account;
//
//   @override
//   void initState() {
//     super.initState();
//
//     appointments = Appointments();
//     reviews = Reviews();
//     medicine = MedicinePage();
//     blogPage = BlogPage();
//     account = Account();
//     pages = [appointments, reviews, medicine, blogPage, account];
//     currentPage = appointments;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//
//       body: currentPage,
//
//       ///Bottom Navigation Bar Section...
//       bottomNavigationBar: BottomNavigationBar(
//         //backgroundColor: Colors.white,
//         onTap: (int index) {
//           setState(() {
//             currentTabIndex = index;
//             currentPage = pages[index];
//           });
//         },
//         currentIndex: currentTabIndex,
//         type: BottomNavigationBarType.fixed,
//
//         items: <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//               icon: Icon(Icons.featured_play_list_sharp),
//               label: "Appointments"),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.rate_review), label: "Reviews"),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.medical_services_rounded), label: "Medicine"),
//           BottomNavigationBarItem(icon: Icon(Icons.article), label: "Blog"),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
//         ],
//       ),
//     );
//   }
// }

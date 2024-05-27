import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'styles/app_styles.dart';
import 'screens/home_remedies.dart';
import 'widgets/gallery.dart';
import 'screens/doctor_list_page.dart';
import 'screens/hospital_list_page.dart';

void main() {
  runApp(CutiCareApp());
}

class CutiCareApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CutiCare',
      theme: ThemeData(
        primaryColor: AppStyles.primaryColor,
        textTheme: AppStyles.textTheme,
      ),
      home: HomeScreen(),
      routes: {
        '/homeRemedies': (context) => HomeRemediesPage(),
        '/photoChecker': (context) => Gallery(),
        '/doctorList': (context) => DoctorListPage(),
        '/hospitalList': (context) => HospitalListPage(),
      },
    );
  }
}

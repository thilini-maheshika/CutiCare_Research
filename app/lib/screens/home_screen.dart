import 'package:flutter/material.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/welcome_banner.dart';
import '../widgets/doctor_card.dart';
import '../widgets/menu_drawer.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Center(
          child: Image.asset(
            'assets/images/logo.png',
            height: 40,
          ),
        ),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.menu),
        //     onPressed: () {},
        //   )
        // ],
      ),
      drawer: MenuDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0)
            ),
            CustomSearchBar(),
            WelcomeBanner(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Check the Best Doctors',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            DoctorCard(
              name: 'Dr. Olivia Dermont',
              specialty: 'Dermatologist',
              imageUrl: 'assets/images/doctor1.jpg',
            ),
            DoctorCard(
              name: 'Dr. Marcus Skinfield',
              specialty: 'Dermatologist',
              imageUrl: 'assets/images/doctor2.jpg',
            ),
          ],
        ),
      ),
    );
  }
}

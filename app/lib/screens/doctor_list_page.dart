import 'package:flutter/material.dart';
import '../styles/app_styles.dart';
import '../widgets/menu_drawer.dart';

class DoctorListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Image.asset(
          'assets/images/logo.png',
          height: 40,
        ),
        centerTitle: true,
      ),
      drawer: MenuDrawer(), // Assuming you have the MenuDrawer implemented as before
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search By Nearest Town',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView(
                children: [
                  DoctorCard(
                    name: 'Dr. Olivia Dermont',
                    specialty: 'Dermatologist',
                    clinic: 'Radiant Skin Clinic',
                    imagePath: 'assets/images/doctor1.jpg', // Replace with actual image paths
                  ),
                  SizedBox(height: 16.0),
                  DoctorCard(
                    name: 'Dr. Marcus Skinfield',
                    specialty: 'Dermatologist',
                    clinic: 'Dermacare Wellness Center',
                    imagePath: 'assets/images/doctor2.jpg',
                  ),
                  SizedBox(height: 16.0),
                  DoctorCard(
                    name: 'Dr. Johnea Maxwell',
                    specialty: 'Dermatologist',
                    clinic: 'Skin Harmony Hospital',
                    imagePath: 'assets/images/doctor3.jpg',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final String name;
  final String specialty;
  final String clinic;
  final String imagePath;

  DoctorCard({
    required this.name,
    required this.specialty,
    required this.clinic,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: Colors.black),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Image.asset(
              imagePath,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(specialty, style: TextStyle(color: Colors.grey)),
                  Text(clinic),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              child: Text('INFO', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

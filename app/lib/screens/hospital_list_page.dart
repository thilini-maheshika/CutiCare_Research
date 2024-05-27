import 'package:flutter/material.dart';
import '../styles/app_styles.dart';
import '../widgets/menu_drawer.dart';

class HospitalListPage extends StatelessWidget {
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
                  ClinicCard(
                    name: 'Dermacare Wellness Center',
                    address: '789 Skincare Street, Townsville',
                    phone: '(555) 987-6543',
                    url: 'https://dermacarewellness.com/',
                  ),
                  SizedBox(height: 16.0),
                  ClinicCard(
                    name: 'Radiant Skin Clinic',
                    address: '789 Skincare Street, Townsville',
                    phone: '(555) 987-6543',
                    url: 'https://dermacarewellness.com/',
                  ),
                  SizedBox(height: 16.0),
                  ClinicCard(
                    name: 'Skin Harmony Hospital',
                    address: '789 Skincare Street, Townsville',
                    phone: '(555) 987-6543',
                    url: 'https://dermacarewellness.com/',
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

class ClinicCard extends StatelessWidget {
  final String name;
  final String address;
  final String phone;
  final String url;

  ClinicCard({
    required this.name,
    required this.address,
    required this.phone,
    required this.url,
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
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(address, style: TextStyle(color: Colors.grey)),
                  Text(phone, style: TextStyle(color: Colors.grey)),
                  Text(url, style: TextStyle(color: Colors.grey)),

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

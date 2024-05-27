import 'package:flutter/material.dart';
import '../styles/app_styles.dart';
import 'gallery.dart';

class WelcomeBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        color: AppStyles.primaryColor.withOpacity(0.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Welcome to CutiCare',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 9.0),
            Text(
              'Your Personal Skin Health Companion!',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Gallery()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyles.primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: Text(
                  'GET STARTED',
                style: TextStyle(
                  color: Colors.white,  // Change the button text color here
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

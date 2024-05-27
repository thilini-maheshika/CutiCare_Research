import 'package:flutter/material.dart';
import '../styles/app_styles.dart';

class MenuDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: AppStyles.primaryColor.withOpacity(0.9),  // Set the background color
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text('CutiCare', style: TextStyle(color: Colors.white, fontSize: 24)),
              decoration: BoxDecoration(
                color: AppStyles.primaryColor,
              ),
            ),
            ListTile(
              title: Text('Check your Skin', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Handle the tap
                Navigator.pop(context);
                Navigator.pushNamed(context, '/photoChecker');
              },
            ),
            ListTile(
              title: Text('Find Nearest Doctor', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Handle the tap
                Navigator.pop(context);
                Navigator.pushNamed(context, '/doctorList');
              },
            ),
            ListTile(
              title: Text('Find Nearest Hospital', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Handle the tap
                Navigator.pop(context);
                Navigator.pushNamed(context, '/hospitalList');
              },
            ),
            ListTile(
              title: Text('View Remedies', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Handle the tap
                Navigator.pop(context);
                Navigator.pushNamed(context, '/homeRemedies');
              },
            ),
          ],
        ),
      ),
    );
  }
}

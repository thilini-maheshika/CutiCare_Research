import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker package
import 'package:permission_handler/permission_handler.dart';
import '../styles/app_styles.dart';  // Ensure this path is correct for your project
import 'dart:io';
import '../screens/photo_display.dart';

class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  Future<void> _capturePhoto() async {
    try {
      // Request permissions
      if (await _requestPermissions()) {
        final ImagePicker _picker = ImagePicker();
        final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

        if (photo != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PhotoDisplay(imagePath: photo.path),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('No image captured.'),
          ));
        }
      }
    } catch (e) {
      print("Error capturing photo: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to capture photo. Please try again.'),
      ));
    }
  }



  Future<void> _importFromGallery() async {
    try {
      // Request permissions
      if (await _requestPermissions()) {
        final ImagePicker _picker = ImagePicker();
        final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

        if (image != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PhotoDisplay(imagePath: image.path),
            ),
          );
        }
      }
    } catch (e) {
      print("Error importing photo from gallery: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to import photo. Please try again.'),
      ));
    }
  }

  Future<bool> _requestPermissions() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
      if (!status.isGranted) {
        return false;
      }
    }
    status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
      if (!status.isGranted) {
        return false;
      }
    }
    return true;
  }

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16.0),
            Image.asset(
              'assets/images/doctor-patient.jpg', // Ensure this image path is correct
              fit: BoxFit.cover,
            ),
            SizedBox(height: 24.0),
            Text(
              'Your skin journey starts with a click. Capture your skin disease image and see the results!',
              textAlign: TextAlign.center,
              style: AppStyles.textTheme.bodyLarge,
            ),
            SizedBox(height: 16.0),
            Text(
              'Let Cuticare guide you towards radiant skin health!',
              textAlign: TextAlign.center,
              style: AppStyles.textTheme.bodyLarge,
            ),
            Spacer(),
            ElevatedButton(
              onPressed: _capturePhoto,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyles.primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: Text(
                'CAPTURE PHOTO',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _importFromGallery,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyles.primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: Text(
                'IMPORT FROM GALLERY',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 32.0),
          ],
        ),
      ),
    );
  }
}

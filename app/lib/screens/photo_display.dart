import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import './home_remedies.dart';

class PhotoDisplay extends StatefulWidget {
  final String imagePath;

  PhotoDisplay({required this.imagePath});

  @override
  _PhotoDisplayState createState() => _PhotoDisplayState();
}

class _PhotoDisplayState extends State<PhotoDisplay> {
  String _prediction = '';
  bool? _isEczema;

  @override
  void initState() {
    super.initState();
    _uploadImage(widget.imagePath);
  }

  Future<void> _uploadImage(String imagePath) async {

    //final uri = Uri.parse('http://10.0.2.2:3006/api/main/check');

    // For physical devices, use the local network IP address of your machine
    final uri = Uri.parse('http://192.168.8.102:3006/api/main/check'); // Replace with your actual IP

    print('Uploading image to: $uri');

    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('file', imagePath));

    try {
      final response = await request.send().timeout(Duration(seconds: 120)); // Set timeout duration
      print('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final result = jsonDecode(responseData);
        print('Response data: $result');

        setState(() {
          _isEczema = result['isRash'] ?? false; // Default to false if key is missing
          _prediction = _isEczema! ? 'Eczema detected' : 'Normal skin';
        });
      } else {
        setState(() {
          _prediction = 'Error: Server returned ${response.statusCode}';
        });
      }
    } on SocketException {
      setState(() {
        _prediction = 'Error: Network unreachable'; // Display error message for network unreachable
      });
    } on TimeoutException {
      setState(() {
        _prediction = 'Error: Connection timed out';
      });
    } catch (e) {
      print('Error uploading image: $e');
      setState(() {
        _prediction = 'Error: $e';
      });
    }
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
            Image.file(
              File(widget.imagePath),
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16.0),
            Text(
              _prediction.isNotEmpty ? _prediction : 'Analyzing...',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HomeRemediesPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: Text(
                'View Home Remedies',
                style: TextStyle(color: Colors.white,fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

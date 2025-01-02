import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';

import 'business_edit_hours.dart';

class BusinessEditUpload extends StatefulWidget {
  const BusinessEditUpload({super.key});

  @override
  _BusinessEditUploadState createState() => _BusinessEditUploadState();
}

class _BusinessEditUploadState extends State<BusinessEditUpload> {
  File? _image; // Store the uploaded image
  double _uploadProgress = 0.0; // Upload progress tracker

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _uploadProgress = 0.0; // Reset progress for the new image
      });
      _simulateUpload(); // Start upload simulation
    }
  }

  void _simulateUpload() {
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        if (_uploadProgress < 1.0) {
          _uploadProgress += 0.05; // Increment progress by 5%
        } else {
          _uploadProgress = 1.0;
          timer.cancel(); // Stop the timer when upload completes
          print("Image '${_image?.path.split('/').last}' uploaded successfully.");
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Tour',
                    style: TextStyle(
                      color: Color(0xff0b036c),
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  TextSpan(
                    text: 'Ease',
                    style: TextStyle(
                      color: Color(0xffe80000),
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ),
            const Text(
              "Upload Picture",
              style: TextStyle(color: Color(0xff0b036c), fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            // Display the uploaded image or upload box
            GestureDetector(
              onTap: _pickImage,
              child: _image == null
                  ? Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_upload_outlined, color: Colors.black, size: 50),
                    Text("Browse", style: TextStyle(color: Color(0xff0b036c))),
                  ],
                ),
              )
                  : Stack(
                children: [
                  Image.file(
                    _image!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: LinearProgressIndicator(
                      value: _uploadProgress,
                      color: Colors.green,
                      backgroundColor: Colors.grey[300],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Upload Button
            ElevatedButton(
              onPressed: () {
                if (_image != null) {
                  print("Image '${_image!.path.split('/').last}' ready for upload.");
                } else {
                  print("No image selected.");
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BusinessEditHours(),
                  ),
                );

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff0b036c),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                "Upload Files",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

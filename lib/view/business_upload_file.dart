import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:TourEase/view/business_operating_hour.dart';
import 'dart:async';
import 'dart:io';
import '../model/business_info.dart';
import 'dart:typed_data'; // Import this for Uint8List

class BusinessUploadFile extends StatefulWidget {

  final BusinessInfo businessInfo;

  const BusinessUploadFile({super.key, required this.businessInfo});

  @override
  _BusinessUploadFileState createState() => _BusinessUploadFileState();
}

class _BusinessUploadFileState extends State<BusinessUploadFile> {
  double _uploadProgress = 0.0;
  final ImagePicker _picker = ImagePicker();
  File? _pickedImage;
  Uint8List bytes = Uint8List(0); // Declare an empty Uint8List for the image bytes
  bool _isLoading = false; // Track loading state


  Future<void> _pickImage() async {

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _isLoading = true; // Set loading to true
    });

    if (pickedFile != null) {
        bytes = await File(pickedFile.path).readAsBytes(); //to be pass on business_info

      setState(() {
        _pickedImage = File(pickedFile.path);
        _isLoading = false; // Set loading to false after processing
      });
      _simulateUpload(); // Start simulated upload for the picked image

    } else {
      setState(() {
        _isLoading = false; // Set loading to false if no file is picked
      });
    }
  }

  void _simulateUpload() {
    // Simulate a file upload with a periodic timer
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        if (_uploadProgress < 1.0) {
          _uploadProgress += 0.05; // Increment progress by 5%
        } else {
          _uploadProgress = 1.0; // Set progress to complete
          timer.cancel(); // Stop the timer once upload is complete
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 100),
            // Logo
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
            const Text("Upload picture", style: TextStyle(color: Color(0xff0b036c), fontSize: 18)),
            const SizedBox(height: 30),
            // Upload Box
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _pickedImage == null
                    ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_upload_outlined, color: Colors.black, size: 50),
                    Text("Drag & drop files or", style: TextStyle(color: Colors.black)),
                    Text("Browse", style: TextStyle(color: Color(0xff0b036c))),
                  ],
                )

                    : Stack(
                  children: [
                    Positioned.fill(
                      child: Image.file(
                        _pickedImage!,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (_uploadProgress < 1.0)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: LinearProgressIndicator(
                          value: _uploadProgress,
                          backgroundColor: Colors.grey[300],
                          color: Colors.green,
                          minHeight: 5,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Upload Status
            if (_pickedImage != null)
              Align(
                alignment: Alignment.center,
                child: Text(
                  _uploadProgress < 1.0
                      ? "Uploading..."
                      : "Upload Complete!",
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            const SizedBox(height: 10),
            const SizedBox(height: 20),
            // Upload Button
            ElevatedButton(
              onPressed: (){
                if (bytes.isNotEmpty) { // Check if bytes are not empty before assigning
                  widget.businessInfo.businessPhoto = bytes; // Store the bytes in businessPhoto

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BusinessOperatingHour(businessInfo: widget.businessInfo),
                    ),
                  );
                } else {
                  // Optionally, show a message indicating that no image was picked
                  print('No image selected to upload.');
                }
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

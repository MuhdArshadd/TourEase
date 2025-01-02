import 'package:flutter/material.dart';
import 'package:TourEase/view/business_upload_file.dart';
import '../model/business_info.dart';
import 'business_edit_upload.dart';

class BusinessEditAddress extends StatefulWidget {

  const BusinessEditAddress({super.key});

  @override
  _BusinessEditAddressState createState() => _BusinessEditAddressState();
}

class _BusinessEditAddressState extends State<BusinessEditAddress> {
  final TextEditingController _streetAddressController = TextEditingController();
  final TextEditingController _postTownController = TextEditingController();
  final TextEditingController _postCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: RichText(
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
              ),
              const Center(
                child: Text(
                  'Edit your business address',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xff0b036c),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Center(
                child: Text(
                  'Edit location where customers can visit your business in person',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0x4A000000),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 45,
                child: TextField(
                  controller: _streetAddressController,
                  decoration: InputDecoration(
                    labelText: 'Street address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),
              SizedBox(
                height: 45,
                child: TextField(
                  controller: _postTownController,
                  decoration: InputDecoration(
                    labelText: 'Post town',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),
              SizedBox(
                height: 45,
                child: TextField(
                  controller: _postCodeController,
                  decoration: InputDecoration(
                    labelText: 'Postcode',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 0),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () {
                    //Handle button press
                    print('Pinned places on the map pressed');
                  },
                  icon: const Icon(Icons.map_outlined, color: Colors.black),
                  label: const Text(
                    'Pinned places on the map',
                    style: TextStyle(color: Color(0xcc120076)),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Add padding
                  ),
                ),
              ),

              const SizedBox(height: 8),
              // Mini Map Container
              Container(
                height: 150, // Set the height for the mini map
                decoration: BoxDecoration(
                  color: Colors.grey[300], // Background color for the mini map
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                  border: Border.all(color: Colors.grey), // Optional border
                ),
                child: const Center(
                  child: Text(
                    'Mini Map Placeholder', // Placeholder text
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ),
              const SizedBox(height: 12), // Added spacing for better layout
              // Back Button aligned to the center-left
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space between buttons
                children: [
                  SizedBox(
                    width: 110,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff0b036c),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: () {
                        // Return the business category back when pressing the button
                        Navigator.pop(context);
                        // Return the updated business name when pressing the button
                      },
                      child: const Text(
                        'Back',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  // Back Button aligned to the left
                  SizedBox(
                    width: 110,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff0b036c),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BusinessEditUpload(),
                          ),
                        );
                      },
                      child: const Text(
                        'Next',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  // Continue Button aligned to the right
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

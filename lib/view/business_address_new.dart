import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:TourEase/view/business_upload_file.dart';
import 'package:TourEase/view/pinned_location_page.dart';
import '../model/business_info.dart';

class BusinessAddressNew extends StatefulWidget {
  //final String businessCategory; // Added to receive the business category
  final BusinessInfo businessInfo;

  const BusinessAddressNew({super.key, required this.businessInfo});

  @override
  _BusinessAddressNewState createState() => _BusinessAddressNewState();
}

class _BusinessAddressNewState extends State<BusinessAddressNew> {
  final TextEditingController _streetAddressController = TextEditingController();
  final TextEditingController _postTownController = TextEditingController();
  final TextEditingController _postCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _updateTextControllers();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update text controllers in case businessInfo data was modified in the previous page.
    _updateTextControllers();
  }

  void _updateTextControllers() {
    _streetAddressController.text = widget.businessInfo.streetAddress;
    _postTownController.text = widget.businessInfo.postTown;
    _postCodeController.text = widget.businessInfo.postCode;
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
                  'Enter your business address',
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
                  'Add a location where customers can visit your business in person',
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PinnedLocationPage(businessInfo: widget.businessInfo),
                      ),
                    );
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
                        widget.businessInfo.streetAddress = _streetAddressController.text; // Update the model
                        widget.businessInfo.postTown = _postTownController.text;
                        widget.businessInfo.postCode = _postCodeController.text;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BusinessUploadFile(businessInfo: widget.businessInfo)
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


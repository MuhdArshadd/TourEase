import 'package:flutter/material.dart';
import 'package:TourEase/view/business_category_new.dart';

import '../model/business_info.dart';

class BusinessNameNew extends StatefulWidget{
  //final String? businessName; // Optional business name
  final BusinessInfo businessInfo;

  const BusinessNameNew({super.key, required this.businessInfo});

  @override
  _BusinessNameNewState createState() => _BusinessNameNewState();
}

class _BusinessNameNewState extends State<BusinessNameNew> {
  final TextEditingController _businessNameController = TextEditingController();

  void _printBusinessName() {
    String businessName = _businessNameController.text;
    print('Business Name: $businessName'); // Print the input

  }

  @override
  void initState() {
    super.initState();
    _businessNameController.text = widget.businessInfo.businessName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: Text(
                  'Get your business discovered on',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xff0b036c),
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),
              Center(
                child: RichText(
                  text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Tour',
                          style: TextStyle(
                              color: Color(0xff0b036c),
                              fontWeight: FontWeight.bold,
                              fontSize: 30
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
                      ]
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Center(
                child: Text(
                  'Enter a few business details to get started',
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
                  controller: _businessNameController,
                  decoration: InputDecoration(
                    labelText: 'Business name*',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Button to Print Business Name
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0b036c),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: () {
                    // Navigate to BusinessCategoryNew and pass the business name
                    widget.businessInfo.businessName = _businessNameController.text; // Update the model
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BusinessCategoryNew(
                            businessInfo: widget.businessInfo,
                          )),
                    );
                    _printBusinessName();

                  },
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'business_address_new.dart';
import '../model/business_info.dart';

class BusinessCategoryNew extends StatefulWidget {
  //final String businessName; // Receive the business name
  final BusinessInfo businessInfo;

  const BusinessCategoryNew({super.key, required this.businessInfo});

  @override
  _BusinessCategoryNewState createState() => _BusinessCategoryNewState();
}

class _BusinessCategoryNewState extends State<BusinessCategoryNew> {
  //final TextEditingController _businessCategoryController = TextEditingController();
  final TextEditingController _businessAccessibilityController = TextEditingController();
  final TextEditingController _businessPlanningController = TextEditingController();
  final TextEditingController _businessChildrenController = TextEditingController();

  // List of options for business categories
  final List<String> _businessCategories = ['Travel', 'Food', 'Culture'];

  @override
  void initState() {
    super.initState();
    // Initialize the text field with the passed business name
    //_businessCategoryController.text = widget.businessInfo.businessCategory;
    _businessAccessibilityController.text = widget.businessInfo.accessibility;
    _businessPlanningController.text = widget.businessInfo.planning;
    _businessChildrenController.text = widget.businessInfo.children;
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
                  'Choose your business category',
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
                  'Help customers discover your business by adding a business category, '
                      'and showcase your commitment to inclusivity by highlighting place accessibility features',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0x4A000000),
                  ),
                ),
              ),

              const SizedBox(height: 12),
              SizedBox(
                height: 45,
                child:  DropdownButtonFormField<String>(
                  value: widget.businessInfo.businessCategory.isNotEmpty
                      ? widget.businessInfo.businessCategory
                      : null,
                  decoration: InputDecoration(
                    labelText: 'Business category*',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  items: _businessCategories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category, style: TextStyle(fontSize: 13),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      widget.businessInfo.businessCategory = value!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 45,
                child: TextField(
                  controller: _businessAccessibilityController,
                  decoration: InputDecoration(
                    labelText: 'Accessibility*',
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
                  controller: _businessPlanningController,
                  decoration: InputDecoration(
                    labelText: 'Planning*',
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
                  controller: _businessChildrenController,
                  decoration: InputDecoration(
                    labelText: 'Children*',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
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
                        // Return the updated business name when pressing the button
                        widget.businessInfo.accessibility = _businessAccessibilityController.text;
                        widget.businessInfo.planning = _businessPlanningController.text;
                        widget.businessInfo.children = _businessChildrenController.text;
                        Navigator.pop(context, widget.businessInfo); // Pass back updated info
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
                        // TODO: Handle "Add New" action
                        // Navigate to BusinessAddressNew and pass the current business category
                        widget.businessInfo.accessibility = _businessAccessibilityController.text;
                        widget.businessInfo.planning = _businessPlanningController.text;
                        widget.businessInfo.children = _businessChildrenController.text;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BusinessAddressNew(businessInfo: widget.businessInfo)),
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

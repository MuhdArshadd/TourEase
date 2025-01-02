import 'package:flutter/material.dart';
import 'package:TourEase/view/business_edit_address.dart';


class BusinessEditNameCategory extends StatefulWidget{
  //final String? businessName; // Optional business name

  const BusinessEditNameCategory({super.key});

  @override
  _BusinessEditNameCategoryState createState() => _BusinessEditNameCategoryState();
}

class _BusinessEditNameCategoryState extends State<BusinessEditNameCategory> {
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _businessCategoryController = TextEditingController();
  final TextEditingController _businessAccessibilityController = TextEditingController();
  final TextEditingController _businessPlanningController = TextEditingController();
  final TextEditingController _businessChildrenController = TextEditingController();

  // List of options for business categories
  final List<String> _businessCategories = ['Travel', 'Food', 'Culture'];
  String? _selectedBusinessCategory; // Selected category



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
                  'Edit your business details',
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
                  'Edit your business detail',
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

              SizedBox(
                height: 45,
                child: DropdownButtonFormField<String>(
                  value: _selectedBusinessCategory,
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
                      _selectedBusinessCategory = value;
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BusinessEditAddress(),
                      ),
                    );
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
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:TourEase/view/business_dashboard.dart';
import 'package:postgres/postgres.dart';
import '../dbConnection/dbConnection.dart';
import '../model/business_info.dart';

class BusinessOperatingHour extends StatefulWidget {
  final BusinessInfo businessInfo;

  const BusinessOperatingHour({super.key, required this.businessInfo});

  @override
  _BusinessOperatingHourState createState() => _BusinessOperatingHourState();
}

class _BusinessOperatingHourState extends State<BusinessOperatingHour> {
  bool is24Hours = false; // Global 24 hours option
  bool _isLoading = false; // Variable to track loading state

  // Function to pick time for open/close
  Future<void> _pickTime(String day, bool isOpeningTime) async {
    final initialTime = isOpeningTime
        ? widget.businessInfo.businessHours[day]!.openTime
        : widget.businessInfo.businessHours[day]!.closeTime;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (pickedTime != null) {
      setState(() {
        if (isOpeningTime) {
          widget.businessInfo.businessHours[day]!.openTime = pickedTime;
        } else {
          widget.businessInfo.businessHours[day]!.closeTime = pickedTime;
        }
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 60.0,
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Success',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'You have successfully add your business',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    /*TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey.withOpacity(0.2),
                        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                      ),
                    ),*/
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BusinessDashboard(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 12.0),
                      ),
                      child: const Text(
                        'Dashboard',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // AppBar properties can be set here
          ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Logo
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
                "Add business hours",
                style: TextStyle(
                    color: Color(0xff0b036c),
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Let customers know when you are open for business",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 20),
            Center(
              child: ListTile(
                leading: Checkbox(
                  value: is24Hours,
                  onChanged: (value) {
                    setState(() {
                      is24Hours = value!;
                      // Set all days to 24 hours or reset their open/close times
                      widget.businessInfo.businessHours.forEach((day, hours) {
                        hours.is24Hours = is24Hours;
                        hours.isOpen =
                            is24Hours; // Assuming if 24 hours, it's always open
                        if (!is24Hours) {
                          hours.openTime = TimeOfDay(
                              hour: 9, minute: 0); // Default opening time
                          hours.closeTime = TimeOfDay(
                              hour: 17, minute: 0); // Default closing time
                        }
                      });
                    });
                  },
                ),
                title: const Text("Open 24 hours"),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            // Improved Design for 24 hours checkbox
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: widget.businessInfo.businessHours.keys.map((day) {
                  final businessHour = widget.businessInfo.businessHours[day]!;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(day, style: const TextStyle(fontSize: 16)),
                        Row(
                          children: [
                            // Show open and close time only if 24 hours is not selected
                            if (!is24Hours && businessHour.isOpen) ...[
                              GestureDetector(
                                onTap: () =>
                                    _pickTime(day, true), // Pick Opening time
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    businessHour.openTime.format(context),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () => _pickTime(day, false),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    businessHour.closeTime.format(context),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(width: 10),
                            // Open/Closed Switch if not 24 hours
                            if (!is24Hours)
                              Switch(
                                value: businessHour.isOpen,
                                onChanged: (value) {
                                  setState(() {
                                    businessHour.isOpen = value;
                                  });
                                },
                                activeColor: Colors.green,
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            // Submit Button
            Center(
              child: _isLoading // Check loading state
                  ? CircularProgressIndicator() // Show loading indicator if true
                  : ElevatedButton(
                      onPressed: () async {
                        // Collect the business hours data
                        displayBusinessHours(); // debugging

                        // Prepare the data for the database insert
                        Map<String, dynamic> businessData = {
                          'name': widget.businessInfo.businessName,
                          'category': widget.businessInfo.businessCategory,
                          // 'street_address': widget.businessInfo.streetAddress,
                          'accessibility': widget.businessInfo.accessibility,
                          'planning': widget.businessInfo.planning,
                          'children': widget.businessInfo.children,
                          // 'post_town': widget.businessInfo.postTown,
                          // 'post_code': widget.businessInfo.postCode,
                          'latitude': widget.businessInfo.latitude,
                          'longitude': widget.businessInfo.longitude,
                          'business_photo': widget.businessInfo.businessPhoto,
                          // 'business_hours': widget.businessInfo.businessHours.map((day, hours) {
                          //   return MapEntry(day, {
                          //     'is_open': hours.isOpen,
                          //     'open_time': hours.is24Hours ? '24 hours' : hours.openTime.format(context),
                          //     'close_time': hours.is24Hours ? '24 hours' : hours.closeTime.format(context),
                          //     'is_24_hours': hours.is24Hours,
                          //   });
                          // }),
                        };

                        // Debug: Print each key-value pair in businessData
                        print("Business Data to Insert:");
                        businessData.forEach((key, value) {
                          print('$key: $value'); // Print each key-value pair
                        });

                        setState(() {
                          _isLoading = true; // Start loading
                        });

                        try {
                          // Call the function to insert `businessData` into the database
                          await insertBusinessData(businessData);
                          _showSuccessDialog(); // Show success dialog if insertion is successful
                        } catch (e) {
                          print(
                              'Error inserting business data: $e'); // Log the error
                          // Handle error here, e.g., show an error dialog
                        } finally {
                          setState(() {
                            _isLoading = false; // Stop loading
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff0b036c),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> insertBusinessData(Map<String, dynamic> businessData) async {
    final conn = PostgreSQLConnection(
      'Database',
      5432,
      'db_name',
      username: username,
      password: password,
      useSSL: true,
    );

    try {
      final base64Image = base64Encode(businessData['business_photo']);
      await conn.open();

      // Insert into tbl_places
      await conn.query(
        '''
      INSERT INTO tbl_places (name, places_image, latitude, longitude, place_category, userid)
      VALUES (@name, (decode(@places_image, 'base64')), @latitude, @longitude, @place_category, @userid)
      ''',
        substitutionValues: {
          'name': businessData['name'],
          'places_image':
              base64Image, // Assuming business_photo is in byte array format
          'latitude': businessData['latitude'],
          'longitude': businessData['longitude'],
          'place_category': "Local Insight", // Use category for place_category
          'userid': 1, // Replace this with the actual user ID if needed
        },
      );

      print('Business data inserted successfully'); // Debugging line
    } catch (e) {
      print('Error during business information insertion: $e'); // Log the error
    } finally {
      await conn.close(); // Ensure the connection is closed
    }
  }

  void displayBusinessHours() {
    //debugging
    print("Business Hours:");
    widget.businessInfo.businessHours.forEach((day, hours) {
      if (hours.is24Hours) {
        print("$day: Open 24 hours");
      } else {
        String openTime =
            hours.isOpen ? hours.openTime.format(context) : "Closed";
        String closeTime = hours.isOpen ? hours.closeTime.format(context) : "";
        print(
            "$day: ${hours.isOpen ? "Open" : "Closed"} from $openTime to $closeTime");
      }
    });
  }
}

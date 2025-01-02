import 'package:flutter/material.dart';

class BusinessEditHours extends StatefulWidget {
  const BusinessEditHours({super.key});

  @override
  _BusinessEditHoursState createState() => _BusinessEditHoursState();
}

class _BusinessEditHoursState extends State<BusinessEditHours> {
  // List of business hours with a simple model for each day
  final List<Map<String, dynamic>> _businessHours = [
    {
      'day': 'Sunday',
      'isOpen': false,
      'openTime': TimeOfDay(hour: 9, minute: 0),
      'closeTime': TimeOfDay(hour: 17, minute: 0),
    },
    {
      'day': 'Monday',
      'isOpen': false,
      'openTime': TimeOfDay(hour: 9, minute: 0),
      'closeTime': TimeOfDay(hour: 17, minute: 0),
    },
    {
      'day': 'Tuesday',
      'isOpen': false,
      'openTime': TimeOfDay(hour: 9, minute: 0),
      'closeTime': TimeOfDay(hour: 17, minute: 0),
    },
    {
      'day': 'Wednesday',
      'isOpen': false,
      'openTime': TimeOfDay(hour: 9, minute: 0),
      'closeTime': TimeOfDay(hour: 17, minute: 0),
    },
    {
      'day': 'Thursday',
      'isOpen': false,
      'openTime': TimeOfDay(hour: 9, minute: 0),
      'closeTime': TimeOfDay(hour: 17, minute: 0),
    },
    {
      'day': 'Friday',
      'isOpen': false,
      'openTime': TimeOfDay(hour: 9, minute: 0),
      'closeTime': TimeOfDay(hour: 17, minute: 0),
    },
    {
      'day': 'Saturday',
      'isOpen': false,
      'openTime': TimeOfDay(hour: 9, minute: 0),
      'closeTime': TimeOfDay(hour: 17, minute: 0),
    },
  ];

  bool is24Hours = false; // Global 24 hours option

  // Function to pick time for open/close
  Future<void> _pickTime(int index, bool isOpeningTime) async {
    final initialTime = isOpeningTime
        ? _businessHours[index]['openTime']
        : _businessHours[index]['closeTime'];

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (pickedTime != null) {
      setState(() {
        if (isOpeningTime) {
          _businessHours[index]['openTime'] = pickedTime;
        } else {
          _businessHours[index]['closeTime'] = pickedTime;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                "Edit your business hours",
                style: TextStyle(color: Color(0xff0b036c), fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Let customers know when you are open for business",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 30),

            // Improved Design for 24 hours checkbox
            ListTile(
              leading: Checkbox(
                value: is24Hours,
                onChanged: (value) {
                  setState(() {
                    is24Hours = value!;
                    for (var hours in _businessHours) {
                      hours['isOpen'] = is24Hours;
                    }
                  });
                },
              ),
              title: const Text("Open 24 hours"),
              contentPadding: EdgeInsets.zero,
            ),

            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _businessHours.length,
                itemBuilder: (context, index) {
                  final businessHour = _businessHours[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(businessHour['day'], style: const TextStyle(fontSize: 16)),
                        Row(
                          children: [
                            // Show open and close time only if not 24 hours and isOpen is true
                            if (!is24Hours && businessHour['isOpen']) ...[
                              GestureDetector(
                                onTap: () => _pickTime(index, true),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    businessHour['openTime'].format(context),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () => _pickTime(index, false),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    businessHour['closeTime'].format(context),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(width: 10),
                            // Open/Closed Switch if not 24 hours
                            if (!is24Hours)
                              Switch(
                                value: businessHour['isOpen'],
                                onChanged: (value) {
                                  setState(() {
                                    businessHour['isOpen'] = value;
                                  });
                                },
                                activeColor: Colors.green,
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Submit Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle submission, for example, save data or navigate
                  print("Business Hours Updated:");
                  for (var hours in _businessHours) {
                    if (is24Hours) {
                      print("${hours['day']}: Open 24 hours");
                    } else {
                      print("${hours['day']}: ${hours['isOpen'] ? "Open" : "Closed"} from ${hours['isOpen'] ? "${hours['openTime'].format(context)} to ${hours['closeTime'].format(context)}" : ""}");
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0b036c),
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
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'bottom_nav_bar.dart';
import 'custom_drawer.dart';
import 'login_state.dart';

class CrowdInsightPage extends StatefulWidget {
  const CrowdInsightPage({super.key});

  get profileImageUrl => null;

  @override
  _CrowdInsightPageState createState() => _CrowdInsightPageState();
}

class _CrowdInsightPageState extends State<CrowdInsightPage> {
  // Dropdown selections
  String selectedYear = 'All-time';
  String selectedMonth = 'August';
  String selectedPlace = 'All';

  // Dropdown options
  final List<String> years = ['All-time', '2022', '2023', '2024'];
  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  final List<String> places = ['All', 'Malacca', 'Kuala Lumpur', 'Penang'];

  int _selectedIndex = 0;

  // Navigation logic for the BottomNavigationBar
  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      if (index == 0) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } else {
      setState(() {
        _selectedIndex = index;
      });

      switch (index) {
        case 0:
          break;
        case 1:
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainPage(selectedIndex: 1)),
                (Route<dynamic> route) => false,
          );
          break;
        case 2:
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainPage(selectedIndex: 2)),
                (Route<dynamic> route) => false,
          );
          break;
        case 3:
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainPage(selectedIndex: 3)),
                (Route<dynamic> route) => false,
          );
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginState = Provider.of<LoginState>(context); // Access login state
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Tour',
                    style: TextStyle(
                        color: Color(0xff0b036c),
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: 'Ease',
                    style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: CircleAvatar(
                  backgroundImage: widget.profileImageUrl != null
                      ? NetworkImage(widget.profileImageUrl!)
                      : const AssetImage('assets/profile_picture.jpg') as ImageProvider,
                ),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          ),
        ],
      ),
      endDrawer: CustomDrawer(
        profileImageUrl: widget.profileImageUrl,
        onLoginChanged: loginState.updateLoginStatus,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              "Tourism Statistics",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Year Dropdown with background color
                _buildDropdownContainer(
                  selectedValue: selectedYear,
                  items: years,
                  onChanged: (value) {
                    setState(() {
                      selectedYear = value!;
                    });
                  },
                ),
                // Month Dropdown with background color
                _buildDropdownContainer(
                  selectedValue: selectedMonth,
                  items: months,
                  onChanged: (value) {
                    setState(() {
                      selectedMonth = value!;
                    });
                  },
                ),
                // Place Dropdown with background color
                _buildDropdownContainer(
                  selectedValue: selectedPlace,
                  items: places,
                  onChanged: (value) {
                    setState(() {
                      selectedPlace = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Chart placeholder
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  "Chart Placeholder",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Statistics Cards
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                _buildStatCard("Active Users", "10001"),
                _buildStatCard("Most Visited Place", "Malacca"),
                _buildStatCard("Total Tourist", "4626"),
                _buildStatCard("Peak Hour", "10 AM - 5 PM"),
                _buildStatCard("2024 Tourist", "86%"),
                _buildStatCard("2023 Tourist", "+34%"),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildDropdownContainer({
    required String selectedValue,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: const Color(0xff0b036c), // Set background color
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButton<String>(
        value: selectedValue,
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        underline: const SizedBox(),
        dropdownColor: const Color(0xff0b036c), // Dropdown menu color
        style: const TextStyle(color: Colors.white), // Text color
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildStatCard(String title, String data) {
    return Container(
      width: 160,
      height: 80,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Text(
            data,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

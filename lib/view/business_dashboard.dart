import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:TourEase/view/business_edit_name_category.dart';
import 'package:TourEase/view/business_name_new.dart';
import 'package:postgres/postgres.dart';
import '../dbConnection/dbConnection.dart';
import 'business_sidebar.dart';

import '../model/business_info.dart';

class BusinessDashboard extends StatefulWidget {
  const BusinessDashboard({super.key});

  @override
  State<BusinessDashboard> createState() => _BusinessDashboardState();
}

class _BusinessDashboardState extends State<BusinessDashboard> {
  // Track the selected place
  String? _selectedPlace; // No default selection

  // Boolean to control visibility of pie charts
  bool _showPieCharts = false;

  List<Map<String, dynamic>> _places = []; // List to store places

  @override
  void initState() {
    super.initState();
    fetchPlaces(); // Fetch places from the database
  }

  Future<void> fetchPlaces() async {
    final conn = PostgreSQLConnection(
      'Database',
      5432,
      'db_name',
      username: username,
      password: password,
      useSSL: true,
    );

    try {
      await conn.open();

      final results = await conn.query(
        '''
        SELECT places_id, name 
        FROM tbl_places 
        WHERE userid = @userid
        ''',
        substitutionValues: {'userid': 1},
      );

      setState(() {
        _places = results.map((row) => {'id': row[0], 'name': row[1]}).toList();
      });
    } catch (e) {
      print('Error fetching places: $e');
    } finally {
      await conn.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Tour',
                style: TextStyle(
                  color: Color(0xff0b036c),
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              TextSpan(
                text: 'Ease',
                style: TextStyle(
                  color: Color(0xffe80000),
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
        automaticallyImplyLeading: false, // This removes the arrow icon
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context)
                    .openEndDrawer(); // Open the drawer using the correct context
              },
            ),
          ),
        ],
      ),
      endDrawer: const BusinessSidebar(
          profileImageUrl: 'assets/default_profile.jpg'), // Add the drawer
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container with Delete, Filter, and Search
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    // Top Row: Delete, Filter, Search
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _faintButton(
                          icon: Icons.delete_outline,
                          label: 'Delete',
                          onPressed: () {
                            // TODO: Handle delete action
                          },
                        ),
                        _faintButton(
                          icon: Icons.filter_alt_outlined,
                          label: 'Filter',
                          onPressed: () {
                            // TODO: Handle filter action
                          },
                        ),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search),
                              hintText: 'Search',
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 12.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: (value) {
                              // TODO: Handle search input
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),

                    // List of places with checkboxes and edit icons
                    ..._places.map(
                        (place) => _buildPlaceItem(place['name'], place['id'])),
                    // // List of places with checkboxes and edit icons
                    // _buildPlaceItem('Jonker Walk'),
                    // _buildPlaceItem('Timah Tasoh'),
                    // _buildPlaceItem('Wang Kelian'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Add New Button
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
                  //Create a new BusinessInfo instance to pass to BusinessNameNew
                  final newBusinessInfo = BusinessInfo();
                  // TODO: Handle "Add New" action
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            BusinessNameNew(businessInfo: newBusinessInfo)),
                  );
                },
                child: const Text(
                  'Add new',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Visitor Statistics Section
            // Pie Charts Row (conditionally shown)
            if (_showPieCharts)
              Column(
                children: [
                  const Center(
                    child: Text(
                      'Visitors at Jonker Walk',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0b036c),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildPieChart('Online Visitor', 50, Colors.blue),
                      _buildPieChart('Physical Visitor', 81, Colors.red),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // Widget for faint buttons (Delete, Filter)
  Widget _faintButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.grey),
      label: Text(
        label,
        style: const TextStyle(color: Color(0xff807a7a)),
      ),
      style: TextButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  // Widget for a place item in the list
  Widget _buildPlaceItem(String placeName, int placeId) {
    return ListTile(
      leading: Radio<String>(
        value: placeName,
        groupValue: _selectedPlace,
        onChanged: (String? value) {
          setState(() {
            _selectedPlace = value; // Update the selected place
            // Update the visibility of pie charts based on the selected place
            // _showPieCharts = value == 'Jonker Walk'; // Show only if "Jonker Walk" is selected
            _showPieCharts = value == placeName;
          });
          // TODO: Handle radio selection
        },
      ),
      title: Text(placeName),
      trailing: IconButton(
        icon: const Icon(Icons.edit_outlined, color: Colors.blue),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BusinessEditNameCategory(),
            ),
          );
          // TODO: Handle edit action
        },
      ),
    );
  }

  // Widget for a pie chart placeholder
  Widget _buildPieChart(String label, int percentage, Color color) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: percentage.toDouble(),
                        color: color,
                        radius: 40,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        value: (100 - percentage).toDouble(),
                        color: color.withOpacity(0.2),
                        radius: 40,
                        showTitle: false,
                      ),
                    ],
                    centerSpaceRadius: 30,
                    sectionsSpace: 2,
                  ),
                ),
              ),
              Text(
                '$percentage%',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

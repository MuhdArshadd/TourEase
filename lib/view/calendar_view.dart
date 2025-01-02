import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:postgres/postgres.dart';

import '../dbConnection/dbConnection.dart';
import '../main.dart';
import 'bottom_nav_bar.dart';

import 'package:url_launcher/url_launcher.dart';

class CalendarViewPage extends StatefulWidget {
  final String placeId;

  const CalendarViewPage({super.key, required this.placeId}); //place id key

  @override
  _CalendarViewPageState createState() => _CalendarViewPageState();
}

class _CalendarViewPageState extends State<CalendarViewPage> {
  bool _isMapLoading = false; // Loading for location
  Set<Marker> _eventMarkers = {}; // Store event marker
  int _selectedIndex = 2; // Default to the 'Events' tab
  LatLng _currentLocation =
      LatLng(3.68594, 101.52253); // Testing location at UPSI

  @override
  void initState() {
    super.initState();
    final String placeID = widget.placeId; // Access placeId from the widget
    displayEventPlace(placeID);
  }

  // Navigation logic for the BottomNavigationBar
  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      // If the user taps on the already selected 'Attractions' tab, navigate to the AttractionPage
      if (index == 2) {
        //go to attraction page
        // Go back to the AttractionPage
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } else {
      setState(() {
        _selectedIndex = index;
      });

      // Navigation for other tabs
      switch (index) {
        case 0:
          // Navigate to the HomePage
          // Navigate back to HomePage and remove AttractionPage from the stack
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const MainPage()),
            (Route<dynamic> route) => false,
          );
          break;
        case 1:
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) =>
                  const MainPage(selectedIndex: 1), // 2 for Calendar
            ),
            (Route<dynamic> route) => false,
          );
          // Stay on AttractionDetailPage
          break;
        case 2:
          break;
        case 3:
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) =>
                  const MainPage(selectedIndex: 3), // 2 for Calendar
            ),
            (Route<dynamic> route) => false,
          );
          break;
      }
    }
  }

  Future<void> displayEventPlace(String placeId) async {
    // Assume placeId is passed as an argument
    setState(() {
      _isMapLoading = true; // Start loading for map markers
    });

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
      var results = await conn.query(
        'SELECT e.event_id, e.event_name, p.latitude, p.longitude '
        'FROM tbl_places p '
        'JOIN tbl_events e ON p.places_id = e.places_id '
        'WHERE p.places_id = @placeId',
        substitutionValues: {
          'placeId':
              placeId, // Set this to the specific place ID you want to query
        },
      );

      Set<Marker> newMarkers = {};
      _eventMarkers.clear();

      for (var row in results) {
        final String eventId =
            row[0].toString(); // Assuming this is the event_id
        final String eventName = row[1]; // Corrected to access place_name
        final double latitude = row[2] as double; // Cast to double
        final double longitude = row[3] as double; // Cast to double

        newMarkers.add(
          Marker(
            markerId: MarkerId(eventId), // Use eventId for the marker ID
            position: LatLng(latitude, longitude),
            infoWindow: InfoWindow(
              title: eventName,
              snippet: 'Lat: $latitude, Lng: $longitude',
              onTap: () {
                openGoogleMaps(latitude, longitude);
              },
            ),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ),
        );
      }

      setState(() {
        _eventMarkers = newMarkers; // Update your markers set here
      });
    } catch (e) {
      print('Error fetching data from Azure: $e'); // Log the error
    } finally {
      await conn.close();
      if (mounted) {
        setState(() {
          _isMapLoading = false; // Stop loading for map markers
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: ' Search for events, categories, tags',
                    suffixIcon: Container(
                      margin: const EdgeInsets.all(4.0),
                      decoration: const BoxDecoration(
                        color: Color(0xff0b036c),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.search, color: Colors.white),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onSubmitted: (value) {
                    //TODO: Implement search
                  },
                ),
              ),
              const SizedBox(height: 14.0),
              Text(
                'Charity Concert 2024 from ${widget.placeId}', // Accessing placeId
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text('Date: October 15, 2022'),
              const SizedBox(height: 16.0),
              // Organizer Info
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.purple[100],
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Eventify Co.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'Organizer Contact: info@eventify.com',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Event Notice',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundImage:
                                  AssetImage('assets/appIcon.jpeg'),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Eventify Co.',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Spacer(),
                            Icon(Icons.more_vert),
                          ],
                        ),
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12.0),
                          bottomRight: Radius.circular(12.0),
                        ),
                        child: Image.asset(
                          'assets/event_poster.webp',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Excited to welcome everyone to the event!',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            const SizedBox(height: 8.0),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                                horizontal: 12.0,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Text(
                                'Announcement',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'About the Event',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              // The image and text placed side by side
              Row(
                children: [
                  // Display image
                  Image.asset(
                    'assets/event_poster.webp', // Update path accordingly
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 16.0),
                  // Display text next to image
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Charity Concert 2024',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Join us for a day of music and charity.',
                          style: TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Container(
                height: 250, // Map container height
                color: Colors.grey[300],
                child: _isMapLoading // Check if loading
                    ? Center(
                        child: CircularProgressIndicator()) // Loading spinner
                    : GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: _currentLocation, // Initial camera target
                          zoom: 13,
                        ),
                        markers: _eventMarkers,
                      ),
              ),
              const SizedBox(height: 16.0),
              // Buttons: Share and Add to Calendar
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implement share functionality
                      },
                      icon: const Icon(Icons.share, color: Colors.white),
                      label: const Text('Share',
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // Black background
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        openGoogleCalendar();
                      },
                      icon:
                          const Icon(Icons.calendar_today, color: Colors.white),
                      label: const Text('Add to Calendar',
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // Black background
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              // Merchandise Section
              const Text(
                'Merchandise',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              // Merchandise Containers
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 200, // Set a fixed height for both containers
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                'assets/event_tee.webp', // replace with the actual image path
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          const Text(
                            'Event Logo Tee',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4.0),
                          const Text('\$25'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Container(
                      height: 200, // Ensure the same height for both containers
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                'assets/event_snapback.webp', // replace with the actual image path
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          const Text(
                            'Event Snapback',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4.0),
                          const Text('\$15'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

Future<void> openGoogleCalendar() async {
  final Uri googleCalendarUri = Uri.parse(
      'intent://calendar.google.com/#Intent;scheme=https;package=com.google.android.calendar;end');

  if (await canLaunch(googleCalendarUri.toString())) {
    await launch(googleCalendarUri.toString());
  } else {
    throw 'Could not launch Google Calendar';
  }
}

Future<void> openGoogleMaps(double eventLatitude, double eventLongitude) async {
  final Uri googleMapsUri = Uri.parse(
      'geo:$eventLatitude,$eventLongitude?q=$eventLatitude,$eventLongitude');

  if (await canLaunch(googleMapsUri.toString())) {
    await launch(googleMapsUri.toString());
  } else {
    throw 'Could not launch Google Maps';
  }
}

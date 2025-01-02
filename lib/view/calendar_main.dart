import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:postgres/postgres.dart';
import 'package:provider/provider.dart';
import 'package:TourEase/view/calendar_view.dart';
import '../controller/location_state.dart';
import '../dbConnection/dbConnection.dart';
import 'calendar_view_tags.dart';
import 'custom_drawer.dart';
import 'login_state.dart';
import 'login_user.dart';

import 'dart:typed_data';

class CalendarMainPage extends StatefulWidget {
  final String? profileImageUrl; // URL for the profile image
  const CalendarMainPage(
      {super.key,
      this.profileImageUrl,
      required void Function(bool status) onLoginChanged});
  @override
  State<CalendarMainPage> createState() => _CalendarMainPageState();
}

class _CalendarMainPageState extends State<CalendarMainPage> {
  final LatLng _currentLocation =
      const LatLng(3.68594, 101.52253); // Testing location at UPSI
  Set<Marker> _attractionMarkers = {}; //to store the attraction marker
  bool _isLoading = true; // Loading state for the map
  Future<List<Map<String, dynamic>>>? attractionsFutureFuture;

  @override
  void initState() {
    super.initState();
    fetchAndDisplayEventMarkers(); // Fetch markers on initialization
    final locationState = Provider.of<LocationState>(context, listen: false);
    double? latitude = locationState.latitude;
    double? longitude = locationState.longitude;
    attractionsFutureFuture = getEventsFromAzure(latitude!, longitude!);
  }

  Future<void> fetchAndDisplayEventMarkers() async {
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

      // Query to fetch place_id, latitude, and longitude
      var results = await conn.query(
          'SELECT p.places_id, p.latitude, p.longitude FROM tbl_places p JOIN tbl_events e ON p.places_id = e.places_id');

      //print('Number of results: ${results.length}'); // Debugging

      // Create a set of new markers
      Set<Marker> newMarkers = {};
      //clear the marker
      _attractionMarkers.clear();

      for (var row in results) {
        final String placeId = row[0].toString(); // Get place_id
        final double latitude = row[1]; // Get latitude
        final double longitude = row[2]; // Get longitude

        // Debugging to get the data
        // print('Adding marker at: $latitude, $longitude with placeId: $placeId');

        // Add a clickable marker with an onTap event to navigate to the page
        newMarkers.add(
          Marker(
            markerId: MarkerId(placeId),
            position: LatLng(latitude, longitude),
            infoWindow: InfoWindow(
              title: 'Event Location',
              snippet: 'Lat: $latitude, Lng: $longitude',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CalendarViewPage(placeId: placeId), // Pass placeId here
                  ),
                );
              },
            ),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ),
        );
      }

      // Update the state with new markers
      setState(() {
        _attractionMarkers = newMarkers; // Update your markers set here
        _isLoading = false; // Set loading to false after fetching markers
      });
    } catch (e) {
      print('Error fetching data from Azure: $e');
    } finally {
      await conn.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginState = Provider.of<LoginState>(context); // Access login state

    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: const TextSpan(children: [
            TextSpan(
              text: 'Tour',
              style: TextStyle(
                  color: Color(0xff0b036c),
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
            TextSpan(
              text: 'Ease',
              style: TextStyle(
                color: Color(0xffe80000),
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ]),
        ),
        actions: [
          if (!loginState.isLoggedIn) ...[
            IconButton(
              icon: const Icon(Icons.person, color: Colors.black),
              onPressed: () async {
                final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginPage(
                            onLoginChanged: loginState.updateLoginStatus)));
                if (result == true) {
                  loginState.updateLoginStatus(true); //update login status
                }
              },
            ),
          ] else ...[
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: CircleAvatar(
                    backgroundImage: widget.profileImageUrl != null
                        ? NetworkImage(widget.profileImageUrl!)
                        : const AssetImage('assets/profile_picture.jpg')
                            as ImageProvider,
                  ),
                  onPressed: () {
                    Scaffold.of(context)
                        .openEndDrawer(); // Open the side drawer
                  },
                );
              },
            ),
          ],
        ],
      ),
      endDrawer: CustomDrawer(
        // Use the CustomDrawer widget here
        profileImageUrl: widget.profileImageUrl,
        onLoginChanged: loginState.updateLoginStatus,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
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
                  //Search akan ke calendar view tags page
                },
              ),
            ),
            const SizedBox(height: 14.0),
            const Text(
              'Events Nearby',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: attractionsFutureFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data available'));
                } else {
                  final attractions = snapshot.data!;

                  return Column(
                    children: attractions.map((attraction) {
                      return Column(
                        children: [
                          ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  20.0), // Adjust the radius as needed
                              child: Image.memory(
                                attraction['event_image'],
                                fit:
                                    BoxFit.cover, // Optional: To cover the area
                              ),
                            ),
                            title: Text(attraction['event_name'] ??
                                'Unnamed Attraction'),
                            subtitle: Text(attraction['date_start'] ??
                                'No date available'),
                            trailing: Text(
                              attraction['name'] != null
                                  ? attraction['name']!.replaceAll(' ', '\n')
                                  : 'Unknown location',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0, // Adjust font size as necessary
                              ),
                              maxLines: 4, // Adjust max lines if needed
                              overflow: TextOverflow
                                  .visible, // Ensure overflow is visible
                            ),
                            onTap: () {
                              // TODO: Navigate to event details
                            },
                          ),
                          const Divider(),
                        ],
                      );
                    }).toList(),
                  );
                }
              },
            ),
            const SizedBox(height: 14.0),
            Container(
              height: 200, // Map container height
              color: Colors.grey[300],
              child: _isLoading // Check if loading
                  ? const Center(
                      child: CircularProgressIndicator()) // Loading spinner
                  : GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _currentLocation, // Initial camera target
                        zoom: 15,
                      ),
                      markers: _attractionMarkers,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                    ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Upcoming Events',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.grey[200],
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4.0,
                          spreadRadius: 2.0,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 100,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(8.0),
                                ),
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/music_event.webp'), // Placeholder image
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(4.0),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  bottomRight: Radius.circular(8.0),
                                ),
                              ),
                              child: const Text(
                                'Music',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Concert', style: TextStyle(fontSize: 16)),
                              SizedBox(height: 4.0),
                              Text('Live Music Night',
                                  style: TextStyle(fontSize: 14)),
                              SizedBox(height: 4.0),
                              Text('Oct 10, 7:00 PM',
                                  style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.grey[200],
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4.0,
                          spreadRadius: 2.0,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 100,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(8.0),
                                ),
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/culinary_event.webp'), // Placeholder image
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(4.0),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  bottomRight: Radius.circular(8.0),
                                ),
                              ),
                              child: const Text(
                                'Culinary',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Food', style: TextStyle(fontSize: 16)),
                              SizedBox(height: 4.0),
                              Text('Gourmet Food Tasting',
                                  style: TextStyle(fontSize: 14)),
                              SizedBox(height: 4.0),
                              Text('Oct 18, 6:30 PM',
                                  style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            //Bahagian This month event kalo click akan ke calendar_view gak
            const Text(
              'This Month\'s Events',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Column(
              children: [
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Icon(Icons.calendar_month, color: Colors.white),
                  ),
                  title: const Text('01 - Street Food Festival'),
                  subtitle: const Text('Downtown'),
                  onTap: () {
                    // Ni hanya sementara (akan gi calendar tags kalo search sahaja)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CalendarViewTags(),
                      ),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(Icons.music_note, color: Colors.white),
                  ),
                  title: const Text('15 - Live Music Night'),
                  subtitle: const Text('Parksquare'),
                  onTap: () {
                    // TODO: Navigate to event details
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.movie, color: Colors.white),
                  ),
                  title: const Text('15 - Outdoor Cinema'),
                  subtitle: const Text('Beachfront'),
                  onTap: () {
                    // TODO: Navigate to event details
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.palette, color: Colors.white),
                  ),
                  title: const Text('30 - Local Artisan Market'),
                  subtitle: const Text('City Center'),
                  onTap: () {
                    // TODO: Navigate to event details
                  },
                ),
                const Divider(),
              ],
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}

Future<List<Map<String, dynamic>>> getEventsFromAzure(
    double latitude, double longitude) async {
  List<Map<String, dynamic>> attractions = [];

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
      '''
    select 
    tbl_events.event_name,
    tbl_events.event_image,
    TO_CHAR(tbl_events.date_start, 'DD-MM-YYYY') AS date_start,
    tbl_places.name,
    (6371 * acos(
        cos(radians(@latitude)) * cos(radians(latitude)) * cos(radians(longitude) - radians(@longitude)) +
        sin(radians(@latitude)) * sin(radians(latitude))
    )) AS distance
    from tbl_events
    JOIN tbl_places ON tbl_places.places_id = tbl_events.places_id
    ORDER BY distance
    LIMIT 3
    ''',
      substitutionValues: {
        'latitude': latitude,
        'longitude': longitude,
      },
    );

    for (var row in results) {
      Uint8List? imageBytes = row[1] as Uint8List?;
      attractions.add({
        'event_name': row[0]?.toString() ?? 'Unknown',
        'event_image': imageBytes,
        'date_start': row[2]?.toString() ?? 'No rating',
        'name': row[3]?.toString() ?? 'Unknown Location',
      });
    }
  } catch (e) {
    print('Error: $e');
  } finally {
    await conn.close();
  }
  print("Attractions fetched: $attractions");
  return attractions;
}

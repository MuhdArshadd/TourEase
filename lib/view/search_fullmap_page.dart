import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:postgres/postgres.dart';
import 'package:url_launcher/url_launcher.dart';
import '../dbConnection/dbConnection.dart';
import 'map_popup.dart';

class FullMapPage extends StatefulWidget {
  @override
  _FullMapPageState createState() => _FullMapPageState();
}

class _FullMapPageState extends State<FullMapPage> {
  LatLng currentLocation =
      LatLng(3.68594, 101.52253); // Testing location at UPSI
  Set<Marker> _attractionMarkers = {}; // Store attraction markers
  TextEditingController searchController = TextEditingController();
  bool _isLoading = false; // Loading state for map markers

  @override
  void initState() {
    super.initState();
    fetchAndDisplayPlaces(
        ""); // Call the fetch function for map markers with empty prefix
  }

  Future<void> fetchAndDisplayPlaces(String prefix) async {
    setState(() {
      _isLoading = true; // Start loading for state data
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
      var query = prefix.isEmpty
          ? 'SELECT places_id, name, latitude, longitude FROM tbl_places'
          : 'SELECT places_id, name, latitude, longitude FROM tbl_places WHERE name LIKE @prefix';
      var results = await conn.query(
        query,
        substitutionValues: prefix.isEmpty ? {} : {'prefix': '%$prefix%'},
      );

      // Debugging: Check how many results were found
      print('Results found: ${results.length}');

      // Only update markers if new results are found
      if (results.isNotEmpty) {
        Set<Marker> newMarkers = {};
        _attractionMarkers
            .clear(); // Clear all existing markers before fetching new ones

        for (var row in results) {
          final String placeId = row[0].toString();
          final String placeName = row[1];
          final double latitude = row[2];
          final double longitude = row[3];

          newMarkers.add(
            Marker(
              markerId: MarkerId(placeId),
              position: LatLng(latitude, longitude),
              infoWindow: InfoWindow(
                title: placeName,
                snippet: 'Lat: $latitude, Lng: $longitude',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapPopupPage(placeId: placeId),
                    ),
                  );
                },
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed),
            ),
          );
        }
        setState(() {
          _attractionMarkers = newMarkers; // Update your markers set here
        });
      }
    } catch (e) {
      print('Error fetching data from Azure: $e'); // Log the error
    } finally {
      await conn.close();
      setState(() {
        _isLoading = false; // Stop loading for state data
      });
    }
  }

  Future<void> openGoogleMaps() async {
    final Uri googleMapsUri = Uri.parse(
        'geo:${currentLocation.latitude},${currentLocation.longitude}?q=${currentLocation.latitude},${currentLocation.longitude}(${searchController.text})');

    if (await canLaunch(googleMapsUri.toString())) {
      await launch(googleMapsUri.toString());
    } else {
      throw 'Could not launch Google Maps';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search place...',
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                fetchAndDisplayPlaces(searchController.text.trim());
              },
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(), // Loading indicator
            )
          else
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: currentLocation,
                zoom: 15,
              ),
              markers: _attractionMarkers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          Positioned(
            bottom: 80,
            left: 10,
            right: 10,
            child: ElevatedButton(
              onPressed: () {
                openGoogleMaps();
              },
              child: Text("Open in Google Maps"),
            ),
          ),
        ],
      ),
    );
  }
}

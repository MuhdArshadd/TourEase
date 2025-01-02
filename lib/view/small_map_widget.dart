import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:postgres/postgres.dart';
import '../dbConnection/dbConnection.dart';
import 'map_popup.dart';

class SmallMapWidget extends StatefulWidget {
  const SmallMapWidget({Key? key}) : super(key: key);

  @override
  _SmallMapWidgetState createState() => _SmallMapWidgetState();
}

class _SmallMapWidgetState extends State<SmallMapWidget> {
  LatLng _currentLocation =
      LatLng(3.68594, 101.52253); // Testing location at UPSI
  String _currentState = ''; // State to display
  Set<Marker> _attractionMarkers = {}; // Store attraction markers
  bool _isLoading = false; // Loading state for location (state)
  bool _isMapLoading = true; // Loading state for the map

  @override
  void initState() {
    super.initState();
    fetchAndDisplayPlaces(); // Call the fetch function for map markers
    getStateFromLatLng(
        3.68594, 101.52253); // Testing with specific coordinates which is UPSI
  }

  // Get address (state) from latitude and longitude
  Future<void> getStateFromLatLng(double latitude, double longitude) async {
    setState(() {
      _isLoading = true; // Start loading for state data
    });

    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        setState(() {
          _currentState = placemarks[0].administrativeArea ?? 'Unknown';
        });
      } else {
        setState(() {
          _currentState = 'Unknown'; // No placemarks found
        });
      }
    } catch (e) {
      print('Error fetching address: $e'); // Log the error
      setState(() {
        _currentState = 'Error fetching location';
      });
    } finally {
      setState(() {
        _isLoading = false; // Stop loading for state data
      });
    }
  }

  Future<void> fetchAndDisplayPlaces() async {
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
          'SELECT places_id, name, latitude, longitude FROM tbl_places LIMIT 30');

      Set<Marker> newMarkers = {};
      _attractionMarkers.clear();

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
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ),
        );
      }
      setState(() {
        _attractionMarkers = newMarkers; // Update your markers set here
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
    return Column(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),
          child: _isMapLoading
              ? Center(
                  child: CircularProgressIndicator()) // Map loading indicator
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _currentLocation,
                    zoom: 15,
                  ),
                  markers: _attractionMarkers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoading
              ? const Text('Fetching location...',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
              : Text(
                  _currentState.isNotEmpty
                      ? _currentState
                      : 'Location not available',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
        ),
      ],
    );
  }
}

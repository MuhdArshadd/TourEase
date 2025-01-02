import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:TourEase/controller/location_state.dart';
import 'package:TourEase/view/bottom_nav_bar.dart';
import 'package:TourEase/view/calendar_main.dart';
import 'package:TourEase/view/register_main.dart';
import 'package:TourEase/view/review_main.dart';
import 'package:TourEase/view/user_profile.dart';
import 'Controller/map_method.dart';
import 'view/home_page.dart';
import 'view/attraction_page.dart';
import 'view/login_state.dart';

Location _locationController = Location();

void main() {

   final locationState = LocationState();
   //locationState.setLocation(currentLocation!.latitude,); // Example coordinates (San Francisco)
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => LoginState(),
          ),
          ChangeNotifierProvider(
          create: (context) => LocationState(), // Pass the created instance
          ),
        ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'NEXPO',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  final int? selectedIndex; // Nullable parameter to accept initial index
  const MainPage({super.key, this.selectedIndex});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int _selectedIndex;
  static late List<Widget> _widgetOptions;

  LatLng? currentLocation; // Store current location
  late Future<void> _initializationFuture; // Track initialization

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex ?? 0;
    _initializationFuture = _initializePages(); // Initialize pages before rendering
  }

  Future<void> _initializePages() async {
    final loginState = Provider.of<LoginState>(context, listen: false);
    final locationState = Provider.of<LocationState>(context, listen: false);
    await _getCurrentLocation(); // Get current location

    // Check if currentLocation is not null
    if (currentLocation != null) {
      // Set location in LocationState
      //locationState.setLocation(currentLocation!.latitude, currentLocation!.longitude);
      locationState.setLocation(3.686394966080142, 101.52458131943024); //upsi
    }

    _widgetOptions = <Widget>[
      HomePage(onLoginChanged: loginState.updateLoginStatus),
      AttractionPage(onLoginChanged: loginState.updateLoginStatus),
      CalendarMainPage(onLoginChanged: loginState.updateLoginStatus),
      UserProfilePage(), // Index 3 - User Profile
      RegisterMainPage(),
    ];
  }

  Future<void> _getCurrentLocation() async {
    try {
      final locationData = await _locationController.getLocation();
      setState(() {
        currentLocation = LatLng(locationData.latitude!, locationData.longitude!); // Update current location
      });
      print('Current Location in main.dart: Latitude: ${currentLocation!.latitude}, Longitude: ${currentLocation!.longitude}');
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializationFuture, // Wait for initialization to complete
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading indicator while initializing
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Show error message if initialization fails
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          // Display main content once initialized
          return Scaffold(
            body: _widgetOptions[_selectedIndex],
            // Use the custom bottom navigation
            bottomNavigationBar: BottomNavBar(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
            ),
          );
        }
      },
    );
  }
}

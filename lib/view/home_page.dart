import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:TourEase/view/fascinating_facts.dart';
import 'package:TourEase/view/custom_drawer.dart';
import 'package:TourEase/view/review_main.dart';
import 'ai_chat_page.dart';
import 'crowd_insight_page.dart';
import 'login_user.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'map_popup.dart';
import 'login_state.dart';

import 'small_map_widget.dart'; // Import  SmallMapWidget

import '../dbConnection/dbConnection.dart';
import 'package:postgres/postgres.dart';

Future<List<Map<String, dynamic>>> attractionsFuture = getPlacesFromAzure();

class HomePage extends StatelessWidget {
  final String? profileImageUrl; // URL for the profile image
  const HomePage(
      {super.key,
      this.profileImageUrl,
      required void Function(bool status) onLoginChanged});

  @override
  Widget build(BuildContext context) {
    final loginState = Provider.of<LoginState>(context);
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
        automaticallyImplyLeading: false, // This removes the hamburger icon
        actions: [
          if (!loginState.isLoggedIn) ...[
            IconButton(
              icon: const Icon(Icons.person, color: Colors.black),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          LoginPage(onLoginChanged: (isLoggedIn) {
                            if (isLoggedIn) loginState.updateLoginStatus;
                          })),
                );
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
                    backgroundImage: profileImageUrl != null
                        ? NetworkImage(profileImageUrl!)
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
        profileImageUrl: profileImageUrl,
        onLoginChanged: loginState.updateLoginStatus,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: ' Search',
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
                ),
              ),

              // Explore Malaysia Section
              Card(
                elevation: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        child: const Icon(Icons.person),
                      ),
                      title: const Text('Explore Malaysia!'),
                      subtitle: const Text('Your personalized travel guide'),
                    ),
                    SmallMapWidget(), // Insert the SmallMapWidget here (display the map)
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Local Insights Section
              //const Text('Local Insights', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Local Insights',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff0b036c),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      minimumSize: const Size(
                          80, 30), // Set minimum size (width, height)
                    ),
                    child: const Text(
                      'See More >',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    onPressed: () {
                      // Navigate to the Review main page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReviewMainPage(
                                onLoginChanged: loginState.updateLoginStatus)),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CarouselSlider(
                            items: [
                              Center(
                                child: Image.asset('assets/coffee_haven.jpg'),
                              ),
                              Center(
                                child: Image.asset('assets/green_eats.png'),
                              ),
                              Center(
                                child:
                                    Image.asset('assets/culinary_event.webp'),
                              ),
                            ],
                            options: CarouselOptions(
                              height: 100,
                              autoPlay: true,
                              enlargeCenterPage: true,
                              viewportFraction: 1.0,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Discover hidden gems in Malaysia'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                ClipOval(
                                  child: Image.asset(
                                    'assets/profile_picture.jpg', // Path to your image
                                    width: 24, // Set the width of the image
                                    height: 24, // Set the height of the image
                                    fit: BoxFit
                                        .cover, // Cover the entire circular area
                                  ),
                                ),
                                SizedBox(width: 4),
                                Text('Local Guide')
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Card(
                      elevation: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CarouselSlider(
                            items: [
                              Center(
                                child: Image.asset('assets/culture.jpg'),
                              ),
                              Center(
                                child: Image.asset('assets/klebang_beach.jpg'),
                              ),
                              Center(
                                child: Image.asset('assets/nature.webp'),
                              ),
                            ],
                            options: CarouselOptions(
                              height: 100,
                              autoPlay: true,
                              enlargeCenterPage: true,
                              viewportFraction: 1.0,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Sustainable tourism tips for tourist'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                ClipOval(
                                  child: Image.asset(
                                    'assets/sunset_terengganu.jpg', // Path to your image
                                    width: 24, // Set the width of the image
                                    height: 24, // Set the height of the image
                                    fit: BoxFit
                                        .cover, // Cover the entire circular area
                                  ),
                                ),
                                SizedBox(width: 4),
                                Text('Travel Enthusiast')
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              // Fascinating Facts Section
              const Text('Fascinating Facts',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              //const SizedBox(height: 8),
              const SizedBox(height: 8),

              // Culture Trivia
              ListTile(
                // leading: Image.asset(
                //     'assets/culture.jpg',
                //   width: 45,
                //   height: 45,
                //   fit: BoxFit.cover,
                // ),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      20.0), // Adjust the radius as needed
                  child: Image.asset(
                    'assets/culture.jpg',
                    height: 45, width: 45,
                    fit: BoxFit.cover, // Optional: To cover the area
                  ),
                ),
                title: const Text('Culture Trivia'),
                subtitle:
                    const Text('Learn about Malaysia\'s diverse tradition'),
                onTap: () {
                  //Handle culture trivia
                  Navigator.push(
                    context,
                    //Ni sementara dia akan go ke fascinating facts
                    MaterialPageRoute(
                        builder: (context) => const FascinatingFactsPage()),
                  );
                },
              ),
              const Divider(),

              // Nature Wonders
              ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      20.0), // Adjust the radius as needed
                  child: Image.asset(
                    'assets/nature.webp',
                    height: 45, width: 45,
                    fit: BoxFit.cover, // Optional: To cover the area
                  ),
                ),
                title: const Text('Nature Wonders'),
                subtitle:
                    const Text('Explore Malaysia\'s breathtaking landscapes'),
                onTap: () {
                  //Handle nature wonder
                  Navigator.push(
                    context,
                    //Ni sementara dia akan ke map popup nnti aku tukar
                    MaterialPageRoute(
                        builder: (context) => const MapPopupPage(
                              placeId: '000',
                            )),
                  );
                },
              ),
              const Divider(),
              const SizedBox(height: 16),

              // Quick Tips Section
              const Text('Quick Tips',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Row(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 2,
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.discount, color: Colors.amber),
                            title: Text(
                                'Flight ticket are usually cheaper on Tuesdays',
                                style: TextStyle(fontSize: 12.0)),
                            // TODO: Fetch ticket discounts from backend
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 2),
                  Expanded(
                    child: Card(
                      elevation: 1,
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.eco, color: Colors.green),
                            title: Text(
                                'Opt for eco-friendly travel to reduce carbon footprint',
                                style: TextStyle(fontSize: 11.0)),
                            // TODO: Fetch sustainability index from backend
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Create Itinerary Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Add itinerary creation functionality
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AIChatPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0b036c),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 120, vertical: 16),
                  ),
                  child: const Text(
                    'Create Itinerary',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Explore More Section
              Card(
                elevation: 2,
                child: Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: Center(
                      child: Image.asset(
                    'assets/nature.webp',
                    fit: BoxFit.fill,
                  )),
                ),
              ),
              const SizedBox(height: 16),

              // Crowd Insights Section
              const Text('Crowd Insights',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      child: const Card(
                        elevation: 2,
                        child: ListTile(
                          title: Text(
                            'Current Visitors',
                            style: TextStyle(fontSize: 14.0),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('500', style: TextStyle(fontSize: 16.0)),
                              SizedBox(height: 4.0),
                              Text(
                                '+20%',
                                style: TextStyle(color: Colors.green),
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        // TODO: Add functionality when the card is tapped
                        Navigator.push(
                          context,
                          //Ni sementara dia akan ke crowd insight
                          MaterialPageRoute(
                              builder: (context) => const CrowdInsightPage()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Expanded(
                    child: Card(
                      elevation: 2,
                      child: ListTile(
                        title: Text('Peak Hours'),
                        subtitle: Text(
                          '11 AM - 3 PM',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // TODO: Fetch peak hours from backend
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

Future<List<Map<String, dynamic>>> getPlacesFromAzure() async {
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

    var results = await conn.query('''
      SELECT * 
      FROM tbl_places
      JOIN tbl_places_subcategory ON tbl_places.places_id = tbl_places_subcategory.places_id
      WHERE tbl_places_subcategory.subcategory = 'Travel'
      ORDER BY RANDOM()
      LIMIT 3;
    ''');

    for (var row in results) {
      attractions.add({
        'places_id': row[0].toString(),
      });
    }
  } catch (e) {
    print('Error: $e');
  } finally {
    await conn.close();
  }
  return attractions;
}

import 'package:flutter/material.dart';

import '../main.dart';
import 'ai_chat_page.dart';
import 'bottom_nav_bar.dart';
import 'custom_drawer.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  get profileImageUrl => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        actions: [
          Builder(
            builder: (BuildContext context){
              return IconButton(
                icon: CircleAvatar(
                  backgroundImage: profileImageUrl != null
                      ? NetworkImage(profileImageUrl!)
                      : const AssetImage('assets/profile_picture.jpg') as ImageProvider,
                ),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer(); // Open the side drawer
                },
              );
            },
          ),
        ],
        automaticallyImplyLeading: false, // This removes the hamburger icon
      ),
      endDrawer: CustomDrawer( // Use the CustomDrawer widget here
        profileImageUrl: profileImageUrl,
        onLoginChanged: (status){},
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12),
            // User Info
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: AssetImage('assets/profile_picture.jpg'),
                  child: const Icon(Icons.person, size: 30, color: Colors.grey),
                ),
                const SizedBox(width: 16.0),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fetch user's name from backend
                    Text(
                      "User's Name",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Fetch user's email from backend
                    Text(
                      "user@email.com",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24.0),

            // Visited Places Section
            const Text(
              'Visited Places',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPlaceCard(
                  "Hawaii",
                  Icons.beach_access, // Example icon for the image
                ),
                _buildPlaceCard(
                  "New York",
                  Icons.location_city, // Example icon for the image
                ),
              ],
            ),
            const SizedBox(height: 24.0),

            // User's Reviews Section with horizontal scrolling
            const Text(
              "User's Reviews",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            SizedBox(
              height: 150, // Adjust height as needed
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildReviewCard("Restaurant A", "Great food and atmosphere!", 5),
                  _buildReviewCard("Hotel B", "Excellent service, highly recommended", 4.5),
                  _buildReviewCard("Café C", "Cozy place with great coffee", 4),
                  _buildReviewCard("Park D", "Beautiful scenery and well-maintained", 4.5),
                ],
              ),
            ),
            const SizedBox(height: 24.0),

            // Recently Viewed Places Section with enhanced style and clickable
            const Text(
              'Recently Viewed Places',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.castle, color: Colors.grey),
                  title: const Text('Castle X'),
                  onTap: () {
                    // TODO: Navigate to event details
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.terrain, color: Colors.brown),
                  title: const Text('Mountain Y'),
                  onTap: () {
                    // TODO: Navigate to event details
                  },
                ),
              ],
            ),
            const SizedBox(height: 24.0),

            // Favorite Places Section with clickable items
            const Text(
              'Favorite Places',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildClickableFavoritePlace(context, "Beach Z", Icons.beach_access),
                _buildClickableFavoritePlace(context, "Temple W", Icons.temple_hindu),
              ],
            ),
            const SizedBox(height: 24.0),

            // Ready for your dream trip? Text and Plan Trip Button
            Center(
              child: Column(
                children: [
                  const Text(
                    'Ready for your dream trip?',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to trip planning screen or handle trip planning
                      Navigator.push(
                        context,
                        //Ni sementara dia akan ke map popup nnti aku tukar
                        MaterialPageRoute(builder: (context) => const AIChatPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xff0b036c),
                      side: const BorderSide(color: Colors.black),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 120.0, vertical: 14.0),
                      child: Text('Plan Trip'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to build the Visited Places cards
  Widget _buildPlaceCard(String title, IconData icon) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Placeholder
              Container(
                height: 100,
                color: Colors.grey[300],
                child: Center(
                  child: Icon(
                    icon,
                    size: 40,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2.0),
              TextButton(
                onPressed: () {
                  // Navigate to detailed page for the visited place
                },
                child: const Text('Details here'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to build the Review cards
  Widget _buildReviewCard(String title, String review, double rating) {
    return SizedBox(
      width: 250, // Width for each review card
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Fetch image from backend if available
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey[300],
                    child: const Icon(Icons.restaurant, size: 20, color: Colors.grey),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(review),
              const SizedBox(height: 4.0),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.yellow),
                  const SizedBox(width: 4.0),
                  Text('$rating'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to build clickable favorite places
  Widget _buildClickableFavoritePlace(BuildContext context, String place, IconData icon) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          // Handle click for favorite place, e.g., navigate to the place's page

        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 20),
                const SizedBox(width: 8.0),
                Text(place),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

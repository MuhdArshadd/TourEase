import 'package:flutter/material.dart';

import '../main.dart';
import 'bottom_nav_bar.dart';
import 'custom_drawer.dart';

class ReviewAttractionPage extends StatefulWidget {
  final String? profileImageUrl; // URL for the profile image

  const ReviewAttractionPage({super.key, this.profileImageUrl});

  @override
  _ReviewAttractionPageState createState() => _ReviewAttractionPageState();
}

class _ReviewAttractionPageState extends State<ReviewAttractionPage> {
  int _selectedIndex = 4;

  get profileImageUrl => null; // Default to the 'Attractions' tab

  // Navigation logic for the BottomNavigationBar
  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      // If the user taps on the already selected 'review' tab, navigate to the ReviewPage
      if (index == 0) {
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
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainPage()), // Update with actual HomePage
                (Route<dynamic> route) => false,
          );
          break;
        case 1:
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainPage(selectedIndex: 1)), // Calendar tab
                (Route<dynamic> route) => false,
          );
          // Stay on ReviewPlacePage
          break;
        case 2:
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainPage(selectedIndex: 2)), // Calendar tab
                (Route<dynamic> route) => false,
          );
          break;
        case 3:
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainPage(selectedIndex: 3)), // Calendar tab
                (Route<dynamic> route) => false,
          );
        //stay
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      endDrawer: CustomDrawer( // Use the CustomDrawer widget here
        profileImageUrl: profileImageUrl,
        onLoginChanged: (status){},
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: ' Search for reviews',
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
                onSubmitted: (value){
                  //TODO: Implement search
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: <Widget>[
                  const Text(
                    'Reviews',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: attractions.length, // TODO: Fetch the actual number of attractions from backend
                    itemBuilder: (context, index) {
                      final attraction = attractions[index];
                      return GestureDetector(
                        onTap: () {
                          // existing navigation code
                        },
                        child: AttractionCard(
                          imageUrl: attraction['imageUrl'] ?? 'No Image URL',
                          title: attraction['title'] ?? 'No Title',
                          distance: attraction['distance'] ?? 'No Distance',
                          rating: attraction['rating'] ?? 0,
                        ),
                      );
                    },
                  ),
                ],
              ),
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
}


class AttractionCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String distance;
  final int rating;

  const AttractionCard({super.key,
    required this.imageUrl,
    required this.title,
    required this.distance,
    this.rating = 0, //default rating
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
            child: Image.asset(
              imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 20,
                );
              }),
            ),
            Text(distance),

          ],
        ),
      ),
    );
  }
}

// TODO: Fetch the actual list of attractions from backend
final List<Map<String, dynamic>> attractions = [
  {'imageUrl': 'assets/petronas_twin_towers.jpg', 'title': 'Petronas Twin Towers', 'distance': '5 km away', 'rating': 5},
  {'imageUrl': 'assets/klebang_beach.jpg', 'title': 'Pantai Klebang', 'distance': '10 km away', 'rating': 4},
  // Add more attractions here
];
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:provider/provider.dart';
import 'package:TourEase/view/review_attraction.dart';
import 'package:TourEase/view/review_place.dart';
import 'package:TourEase/view/custom_drawer.dart';
import '../controller/location_state.dart';
import '../dbConnection/dbConnection.dart';
import '../main.dart';
import 'bottom_nav_bar.dart';
import 'login_state.dart';
import 'login_user.dart';
import 'dart:typed_data';

class ReviewMainPage extends StatefulWidget {
  final String? profileImageUrl; // URL for the profile image

  const ReviewMainPage(
      {super.key,
      this.profileImageUrl,
      required void Function(bool status) onLoginChanged});

  @override
  _ReviewMainPageState createState() => _ReviewMainPageState();
}

class _ReviewMainPageState extends State<ReviewMainPage> {
  int _selectedIndex = 4;
  get profileImageUrl => null;
  Future<List<Map<String, dynamic>>>? attractionsFutureFuture;

  @override
  void initState() {
    super.initState();
    final locationState = Provider.of<LocationState>(context, listen: false);
    double? latitude = locationState.latitude;
    double? longitude = locationState.longitude;
    attractionsFutureFuture = getTopRatedPlacesFromAzure(latitude!, longitude!);
  }

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
            MaterialPageRoute(
                builder: (context) =>
                    const MainPage()), // Update with actual HomePage
            (Route<dynamic> route) => false,
          );
          break;
        case 1:
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const MainPage(selectedIndex: 1)), // Calendar tab
            (Route<dynamic> route) => false,
          );
          // Stay on ReviewPlacePage
          break;
        case 2:
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const MainPage(selectedIndex: 2)), // Calendar tab
            (Route<dynamic> route) => false,
          );
          break;
        case 3:
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const MainPage(selectedIndex: 3)), // Calendar tab
            (Route<dynamic> route) => false,
          );
          //stay
          break;
      }
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
        automaticallyImplyLeading: false,
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
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
                  onSubmitted: (value) {
                    //TODO: Implement search
                  },
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Reviews',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      // TODO: Implement navigation or action for Nature category
                      Navigator.push(
                        context,
                        //Ni akan go ke review attraction
                        MaterialPageRoute(
                            builder: (context) => const ReviewAttractionPage()),
                      );
                    },
                    child: const ReviewCategoryButton(
                        icon: Icons.travel_explore, label: 'Travel'),
                  ),
                  GestureDetector(
                    onTap: () {
                      // TODO: Implement navigation or action for Food category
                      Navigator.push(
                        context,
                        //Ni akan go ke review attraction
                        MaterialPageRoute(
                            builder: (context) => const ReviewAttractionPage()),
                      );
                    },
                    child: const ReviewCategoryButton(
                        icon: Icons.restaurant, label: 'Food'),
                  ),
                  GestureDetector(
                    onTap: () {
                      // TODO: Implement navigation or action for Shopping category
                    },
                    child: const ReviewCategoryButton(
                        icon: Icons.festival, label: 'Culture'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Filter by Rating',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RatingFilterButton(rating: '1 Star'),
                  RatingFilterButton(rating: '2 Stars'),
                  RatingFilterButton(rating: '3 Stars'),
                  RatingFilterButton(rating: '4 Stars'),
                  RatingFilterButton(rating: '5 Stars'),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Top Rated Places',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
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
                    final places = snapshot.data!;
                    return Column(
                      children: places.map((place) {
                        return Column(
                          children: [
                            TopRatedPlace(
                                data: place), // Pass the entire map as `data`
                            const Divider(),
                          ],
                        );
                      }).toList(),
                    );
                  }
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Featured Places',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: FeaturedPlaceCard(
                      imageUrl: 'assets/coffee_haven.jpg',
                      placeName: 'Coffee Haven',
                      reviewText: '5-star reviews',
                    ),
                  ),
                  SizedBox(width: 16), // Spacing between cards
                  Expanded(
                    child: FeaturedPlaceCard(
                      imageUrl: 'assets/green_eats.png',
                      placeName: 'Green Eats',
                      reviewText: 'Best vegetarian restaurant',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Featured Pictures',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const FeaturedPicture(
                imageUrl: 'assets/sunset_terengganu.jpg',
                title: 'Sunset in Terengganu, Malaysia',
                photographerName: 'Arshad Mohd',
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

class ReviewCategoryButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const ReviewCategoryButton({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      width: 110, // Adjust width as needed
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40),
          const SizedBox(height: 8),
          Text(label),
        ],
      ), // Adjust height as needed
    );
  }
}

class RatingFilterButton extends StatelessWidget {
  final String rating;

  const RatingFilterButton({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
            vertical: 8.0, horizontal: 12.0), // Adjusts button padding
        textStyle: const TextStyle(fontSize: 14), // Decreases font size
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(20), // Rounded corners for better fit
        ),
      ),
      onPressed: () {
        // TODO: Filter reviews by rating
      },
      child: Text(rating),
    );
  }
}

class TopRatedPlace extends StatelessWidget {
  final Map<String, dynamic> data;

  const TopRatedPlace({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: data['places_image'] != null
          ? Image.memory(
              data['places_image'],
              width: 45,
              height: 45,
              fit: BoxFit.cover,
            )
          : Icon(Icons.image,
              size: 45, color: Colors.grey), // Default icon if image is null
      title: Text(
          data['name'] ?? 'Unknown Place'), // Default text if placeName is null
      subtitle: Text(data['average_rating'] ??
          'No rating available'), // Default text if rating is null
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ReviewPlacePage(),
          ),
        );
      },
    );
  }
}

Future<List<Map<String, dynamic>>> getTopRatedPlacesFromAzure(
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

    var results = await conn.query('''
      SELECT
      tbl_places.name,
      tbl_places.places_image,
      COALESCE(
              (SELECT SUM(rating_score) FROM tbl_places_rating WHERE places_id = tbl_places.places_id) /
              (CASE
                  WHEN (SELECT COUNT(*) FROM tbl_places_rating WHERE places_id = tbl_places.places_id) > 0
                  THEN (SELECT COUNT(*) FROM tbl_places_rating WHERE places_id = tbl_places.places_id)
                  ELSE 1
              END),
          0) AS average_rating
      FROM
      tbl_places
      JOIN tbl_places_rating ON tbl_places_rating.places_id = tbl_places.places_id
      ORDER BY
      average_rating DESC
      LIMIT 3
    ''');

    for (var row in results) {
      Uint8List? imageBytes = row[1] as Uint8List?;
      attractions.add({
        'name': row[0]?.toString() ?? 'Unknown',
        'places_image': imageBytes,
        'average_rating': row[2]?.toString() ?? 'No rating',
      });
    }
  } catch (e) {
    print('Error: $e');
  } finally {
    await conn.close();
  }
  return attractions;
}

class FeaturedPlaceCard extends StatelessWidget {
  final String imageUrl;
  final String placeName;
  final String reviewText;

  const FeaturedPlaceCard({
    super.key,
    required this.imageUrl,
    required this.placeName,
    required this.reviewText,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity, // Ensure the image takes up full width
            height: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            title: Text(placeName),
            subtitle: Text(reviewText),
            onTap: () {
              // TODO: Navigate to the place details
            },
          ),
        ],
      ),
    );
  }
}

class FeaturedPicture extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String photographerName;

  const FeaturedPicture({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.photographerName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(imageUrl, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(photographerName),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

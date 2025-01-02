import 'package:flutter/material.dart';

import '../main.dart';
import 'bottom_nav_bar.dart';

class AttractionWriteReviewPage extends StatefulWidget {
  const AttractionWriteReviewPage({super.key});

  @override
  _AttractionWriteReviewPageState createState() => _AttractionWriteReviewPageState();
}

class _AttractionWriteReviewPageState extends State<AttractionWriteReviewPage> {
  int _selectedRating = 0; // This will hold the selected star rating (0 to 5)
  int _selectedIndex = 1; // Default to the 'Attractions' tab

  // Navigation logic for the BottomNavigationBar
  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      // If the user taps on the already selected 'Attractions' tab, navigate to the AttractionPage
      if (index == 1) {
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
        // Stay on AttractionDetailPage
          break;
        case 2:
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const MainPage(selectedIndex: 2), // 2 for Calendar
            ),
                (Route<dynamic> route) => false,
          );
          break;
        case 3:
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const MainPage(selectedIndex: 3), // 2 for Calendar
            ),
                (Route<dynamic> route) => false,
          );
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Petronas Twin Tower'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Review Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 2.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Profile and Name
                    const Row(
                      children: [
                        CircleAvatar(
                          radius: 20.0,
                          backgroundColor: Colors.grey,
                          backgroundImage: AssetImage('assets/profile_picture.jpg'),
                          // Add a backgroundImage property here to load user's profile picture
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          'Hana',
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    // Interactive Star Rating
                    StarRating(
                      rating: _selectedRating,
                      starSize: 30.0,
                      onRatingSelected: (rating) {
                        setState(() {
                          _selectedRating = rating;
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),
                    // Review Text Field
                    TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Share details of your own experience at this place',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    // Add Photos & Videos Button
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implement functionality to add photos and videos
                      },
                      icon: const Icon(Icons.photo_camera),
                      label: const Text('Add photos & videos'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            // Submit Review Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement review submission functionality using _selectedRating
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                  backgroundColor: const Color(0xff0b036c),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Submit Review'),
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

class StarRating extends StatelessWidget {
  final int rating; // Rating value from 0 to 5
  final double starSize; // Size of each star
  final Color starColor; // Color of the stars
  final ValueChanged<int> onRatingSelected; // Callback when a star is tapped

  const StarRating({
    super.key,
    required this.rating,
    this.starSize = 24.0,
    this.starColor = Colors.amber,
    required this.onRatingSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: starColor,
            size: starSize,
          ),
          onPressed: () {
            onRatingSelected(index + 1); // Set the rating to index + 1
          },
        );
      }),
    );
  }
}

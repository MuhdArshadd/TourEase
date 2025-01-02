import 'package:flutter/material.dart';
import 'package:TourEase/view/review_write_review.dart';

import '../main.dart';
import 'bottom_nav_bar.dart';
import 'custom_drawer.dart';

class ReviewPlacePage extends StatefulWidget {
  final String? profileImageUrl; // URL for the profile image
  const ReviewPlacePage({super.key, this.profileImageUrl});

  @override
  _ReviewPlacePageState createState() => _ReviewPlacePageState();
}

class _ReviewPlacePageState extends State<ReviewPlacePage> {
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

  // Function to calculate the average rating
  double calculateAverageRating(List<Review> reviews) {
    if (reviews.isEmpty) return 0.0;

    double totalRating = 0.0;
    for (var review in reviews) {
      totalRating += review.rating;
    }
    return totalRating / reviews.length;
  }


  @override
  Widget build(BuildContext context) {
    // List of reviews
    final List<Review> reviews = [
      Review(
        username: 'Happy Customer',
        date: '4 January 2024',
        reviewText: 'Great experience, loved the atmosphere!',
        rating: 5,
      ),
      Review(
        username: 'Joyful Visitor',
        date: '4 January 2024',
        reviewText: 'Excellent service, would recommend to everyone!',
        rating: 4,
      ),
      Review(
        username: 'Satisfied Traveler',
        date: '5 January 2024',
        reviewText: 'Beautiful architecture and friendly staff!',
        rating: 3,
      ),
    ];

    // Calculate average rating
    double averageRating = calculateAverageRating(reviews);

    return Scaffold(
      appBar: AppBar(
        title: const Text('NEXPO'),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              const Text(
                'Reviews',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Image.asset(
                'assets/petronas_twin_towers.jpg', // Example image, replace with actual asset
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
              const Text(
                'Petronas Twin Towers',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              RatingBar(
                averageRating: averageRating,
                totalRatings: reviews.length,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    averageRating.toStringAsFixed(1), // Displaying average rating with 1 decimal
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RatingBreakdown(reviews: reviews),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'All Reviews (3)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    child: const Text(
                      '+ Add Review',
                      style: TextStyle(
                        color: Color(0xff0b036c),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReviewWriteReviewPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 210, // Adjust this height to fit exactly two reviews
                child: Scrollbar(
                  thickness: 6.0,
                  thumbVisibility: true,
                  child: ListView(
                    children: reviews.map((review) {
                      return ReviewCard(
                        username: review.username,
                        date: review.date,
                        reviewText: review.reviewText,
                        rating: review.rating,
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Nearby Popular Places',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const ListTile(
                leading: Icon(Icons.location_on),
                title: Text('Aquaria KLCC'),
                subtitle: Text('9-min walk'),
              ),
              const Divider(),
              const ListTile(
                leading: Icon(Icons.location_on),
                title: Text('Galeri Petronas'),
                subtitle: Text('9-min walk'),
              ),
              const Divider(),
              const SizedBox(height: 24),
              const Text(
                "Travelers' Favorites",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: FavoritePlaceCard(
                      imageUrl: 'assets/coffee_haven.jpg',
                      placeName: 'Coffee Haven',
                      reviewText: '5-star reviews',
                    ),
                  ),
                  SizedBox(width: 12), // Spacing between cards
                  Expanded(
                    child: FavoritePlaceCard(
                      imageUrl: 'assets/green_eats.png',
                      placeName: 'Green Eats',
                      reviewText: 'Best vegetarian restaurant',
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

class RatingBreakdown extends StatelessWidget {
  final List<Review> reviews;

  const RatingBreakdown({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    int totalReviews = reviews.length;
    List<int> starCount = List<int>.filled(5, 0); // Create a list to hold star counts for 5 stars

    // Calculate the count for each star rating
    for (var review in reviews) {
      starCount[5 - review.rating]++;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(5, (index) {
        double percentage = (starCount[index] / totalReviews);
        return Row(
          children: [
            Text('${5 - index}'),
            const SizedBox(width: 4),
            Expanded(
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: Colors.grey[300],
                color: Colors.amber,
              ),
            ),
            const SizedBox(width: 8),
            //Text('${(percentage * 100).toStringAsFixed(1)}%'),
          ],
        );
      }),
    );
  }
}

class Review {
  final String username;
  final String date;
  final String reviewText;
  final int rating;

  Review({
    required this.username,
    required this.date,
    required this.reviewText,
    required this.rating,
  });
}


class RatingBar extends StatelessWidget {
  final double averageRating;
  final int totalRatings;

  const RatingBar({
    super.key,
    required this.averageRating,
    required this.totalRatings,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star, color: Colors.amber),
        const SizedBox(width: 4),
        Text(
          '$averageRating ($totalRatings ratings)',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

class ReviewCard extends StatelessWidget {
  final String username;
  final String date;
  final String reviewText;
  final int rating;

  const ReviewCard({
    super.key,
    required this.username,
    required this.date,
    required this.reviewText,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture, Username, and Star Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Profile Picture/Icon
                    const CircleAvatar(
                      radius: 16, // Adjust the radius as needed
                      //backgroundImage: AssetImage('assets/profile_placeholder.png'), // Replace with actual profile image asset
                      // If you don't have an image, you can use an icon instead:
                      child: Icon(Icons.person),
                    ),
                    const SizedBox(width: 8),
                    // Username
                    Text(
                      username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                // Star Rating aligned to the right
                Row(
                  children: List.generate(
                    rating,
                        (index) => const Icon(Icons.star, color: Colors.amber),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Review Text
            Text(reviewText),
            const SizedBox(height: 8),
            // Thumbs Up, Clap Icons, and Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icons aligned to the left
                const Row(
                  children: [
                    Icon(Icons.thumb_up, color: Colors.green),
                    SizedBox(width: 8),
                    Icon(Icons.emoji_events, color: Colors.orange), // Adjust icon as needed
                  ],
                ),
                // Date aligned to the right
                Text(date, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



class FavoritePlaceCard extends StatelessWidget {
  final String imageUrl;
  final String placeName;
  final String reviewText;

  const FavoritePlaceCard({
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
            width: 160,
            height: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(placeName),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
                reviewText,
                style: const TextStyle(fontSize: 12)
            ),
          ),
        ],
      ),
    );
  }
}

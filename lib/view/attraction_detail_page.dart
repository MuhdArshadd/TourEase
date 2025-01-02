import 'package:flutter/material.dart';
import 'package:TourEase/view/attraction_write_review.dart';
import '../main.dart';
import 'bottom_nav_bar.dart';

import '../dbConnection/dbConnection.dart';
import 'package:postgres/postgres.dart';
import 'dart:typed_data';

import 'package:provider/provider.dart';
import '../controller/location_state.dart';

class AttractionDetailPage extends StatefulWidget {
  final int attractionId;
  const AttractionDetailPage({super.key, required this.attractionId});

  @override
  _AttractionDetailPageState createState() => _AttractionDetailPageState();
}

class _AttractionDetailPageState extends State<AttractionDetailPage> {
  late Future<List<Map<String, dynamic>>> attractionsFuture;
  late Future<List<Map<String, dynamic>>> attractionsFuture2;
  late Future<List<Map<String, dynamic>>> attractionsFuture3;
  List<Map<String, dynamic>>? attractionsData;
  List<Map<String, dynamic>>? attractionsData2;
  List<Map<String, dynamic>>? attractionsData3;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    final locationState = Provider.of<LocationState>(context, listen: false);
    double? latitude = locationState.latitude;
    double? longitude = locationState.longitude;
    attractionsFuture =
        getOverViewDetailsFromAzure(widget.attractionId, latitude!, longitude!);
    attractionsFuture2 =
        getReviewsDetailsFromAzure(widget.attractionId, latitude, longitude);
    attractionsFuture3 =
        getAboutDetailsFromAzure(widget.attractionId, latitude, longitude);
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      if (index == 1) {
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
              builder: (context) =>
                  const MainPage(selectedIndex: 2), // 2 for Calendar
            ),
            (Route<dynamic> route) => false,
          );
          break;
        case 3:
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) =>
                  const MainPage(selectedIndex: 3), // 2 for Calendar
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
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Attractions Near You',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: 240,
                    color: Colors.grey[300],
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: attractionsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.hasData &&
                            snapshot.data!.isNotEmpty) {
                          final Uint8List imageData =
                              snapshot.data![0]['places_image'];
                          return Image.memory(
                            imageData,
                            fit: BoxFit.cover,
                          );
                        } else {
                          return const Center(
                              child: Text('No image available.'));
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 0),
                  DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        const TabBar(
                          tabs: [
                            Tab(text: 'Overview'),
                            Tab(text: 'Reviews'),
                            Tab(text: 'About'),
                          ],
                        ),
                        SizedBox(
                          height: 300,
                          child: TabBarView(
                            children: [
                              FutureBuilder<List<Map<String, dynamic>>>(
                                future: attractionsFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  } else if (snapshot.hasData &&
                                      snapshot.data!.isNotEmpty) {
                                    final data = snapshot.data![0];
                                    return OverviewTab(data: data);
                                  } else {
                                    return const Center(
                                        child: Text('No data found.'));
                                  }
                                },
                              ),
                              FutureBuilder<List<Map<String, dynamic>>>(
                                future: attractionsFuture2,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  } else if (snapshot.hasData &&
                                      snapshot.data!.isNotEmpty) {
                                    // Pass the entire data list to ReviewsTab
                                    return ReviewsTab(
                                        reviewsData: snapshot
                                            .data!); // Pass the whole list
                                  } else {
                                    return const Center(
                                        child: Text('No data found.'));
                                  }
                                },
                              ),
                              FutureBuilder<List<Map<String, dynamic>>>(
                                future: attractionsFuture3,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  } else if (snapshot.hasData &&
                                      snapshot.data!.isNotEmpty) {
                                    // Pass the entire data list to AboutTab
                                    return AboutTab(
                                        data3: snapshot
                                            .data!); // Pass the whole list
                                  } else {
                                    return const Center(
                                        child: Text('No data found.'));
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
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

Future<List<Map<String, dynamic>>> getOverViewDetailsFromAzure(
    int attractionId, double latitude, double longitude) async {
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
      SELECT 
        places_image, name, latitude, longitude,
        (6371 * acos(
            cos(radians($latitude)) * cos(radians(latitude)) * cos(radians(longitude) - radians($longitude)) +
            sin(radians($latitude)) * sin(radians(latitude))
        )) AS distance,
        (SELECT 
            COALESCE(
                (SELECT SUM(rating_score) FROM tbl_places_rating WHERE places_id = @attractionId) /
                (CASE 
                    WHEN (SELECT COUNT(*) FROM tbl_places_rating WHERE places_id = @attractionId) > 0 
                    THEN (SELECT COUNT(*) FROM tbl_places_rating WHERE places_id = @attractionId) 
                    ELSE 1 
                END), 
            0) AS average_rating
        ),
        (SELECT COUNT(*) FROM tbl_places_rating WHERE places_id = @attractionId)
        AS total_rating,
        tbl_places_operating_hours.is24,
        TO_CHAR(tbl_places_operating_hours.monday_start, 'HH24:MI') AS monday_start,
        TO_CHAR(tbl_places_operating_hours.monday_end, 'HH24:MI') AS monday_end,
        TO_CHAR(tbl_places_operating_hours.tuesday_start, 'HH24:MI') AS tuesday_start,
        TO_CHAR(tbl_places_operating_hours.tuesday_end, 'HH24:MI') AS tuesday_end,
        TO_CHAR(tbl_places_operating_hours.wednesday_start, 'HH24:MI') AS wednesday_start,
        TO_CHAR(tbl_places_operating_hours.wednesday_end, 'HH24:MI') AS wednesday_end,
        TO_CHAR(tbl_places_operating_hours.thursday_start, 'HH24:MI') AS thursday_start,
        TO_CHAR(tbl_places_operating_hours.thursday_end, 'HH24:MI') AS thursday_end,
        TO_CHAR(tbl_places_operating_hours.friday_start, 'HH24:MI') AS friday_start,
        TO_CHAR(tbl_places_operating_hours.friday_end, 'HH24:MI') AS friday_end,
        TO_CHAR(tbl_places_operating_hours.saturday_start, 'HH24:MI') AS saturday_start,
        TO_CHAR(tbl_places_operating_hours.saturday_end, 'HH24:MI') AS saturday_end,
        TO_CHAR(tbl_places_operating_hours.sunday_start, 'HH24:MI') AS sunday_start,
        TO_CHAR(tbl_places_operating_hours.sunday_end, 'HH24:MI') AS sunday_end
        FROM tbl_places
        JOIN tbl_places_operating_hours ON tbl_places_operating_hours.places_id = tbl_places.places_id
    WHERE tbl_places.places_id = @attractionId;
    ''',
      substitutionValues: {'attractionId': '$attractionId'},
    );

    for (var row in results) {
      attractions.add({
        'places_image': row[0] as Uint8List,
        'name': row[1].toString(),
        'latitude': row[2].toString(),
        'longitude': row[3].toString(),
        'distance': '${row[4].toStringAsFixed(2)} KM away',
        'average_rating': row[5].toString(),
        'total_rating': row[6].toString(),
        'is24': row[7].toString(),
        'monday_start': row[8].toString(),
        'monday_end': row[9].toString(),
        'tuesday_start': row[10].toString(),
        'tuesday_end': row[11].toString(),
        'wednesday_start': row[12].toString(),
        'wednesday_end': row[13].toString(),
        'thursday_start': row[14].toString(),
        'thursday_end': row[15].toString(),
        'friday_start': row[16].toString(),
        'friday_end': row[17].toString(),
        'saturday_start': row[18].toString(),
        'saturday_end': row[19].toString(),
        'sunday_start': row[20].toString(),
        'sunday_end': row[21].toString(),
      });
    }
  } catch (e) {
    print('Error: $e');
  } finally {
    await conn.close();
  }

  return attractions;
}

class OverviewTab extends StatelessWidget {
  final Map<String, dynamic> data;
  const OverviewTab({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data['name'] ?? 'No name available',
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.directions))
            ],
          ),
          Text(
            data['distance'] ?? 'No distance info',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber),
              Text(
                '${data['average_rating']} (${data['total_rating']} reviews)',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          Text(data['is24'] == '1'
              ? 'Open 24 hours'
              : 'Monday: ${data['monday_start'] != 'null' ? '${data['monday_start']} - ${data['monday_end']}' : 'Closed'}\n'
                  'Tuesday: ${data['tuesday_start'] != 'null' ? '${data['tuesday_start']} - ${data['tuesday_end']}' : 'Closed'}\n'
                  'Wednesday: ${data['wednesday_start'] != 'null' ? '${data['wednesday_start']} - ${data['wednesday_end']}' : 'Closed'}\n'
                  'Thursday: ${data['thursday_start'] != 'null' ? '${data['thursday_start']} - ${data['thursday_end']}' : 'Closed'}\n'
                  'Friday: ${data['friday_start'] != 'null' ? '${data['friday_start']} - ${data['friday_end']}' : 'Closed'}\n'
                  'Saturday: ${data['saturday_start'] != 'null' ? '${data['saturday_start']} - ${data['saturday_end']}' : 'Closed'}\n'
                  'Sunday: ${data['sunday_start'] != 'null' ? '${data['sunday_start']} - ${data['sunday_end']}' : 'Closed'}\n'),
          Text('${data['latitude']}, ${data['longitude']}'),
        ],
      ),
    );
  }
}

Future<List<Map<String, dynamic>>> getReviewsDetailsFromAzure(
    int attractionId, double latitude, double longitude) async {
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
      SELECT 
      tbl_user.fname,tbl_user.lname, tbl_places_rating.summary,tbl_places_rating.rating_score
      FROM tbl_places_rating
      JOIN tbl_user ON tbl_places_rating.userid = tbl_user.userid
      JOIN tbl_places ON tbl_places_rating.places_id = tbl_places.places_id
      WHERE tbl_places.places_id = @attractionId;
    ''',
      substitutionValues: {
        'attractionId': attractionId,
      },
    );

    for (var row in results) {
      attractions.add({
        'username': '${row[0]} ${row[1]}',
        'reviewText': row[2].toString(),
        'rating': row[3],
      });
    }
  } catch (e) {
    print('Error: $e');
  } finally {
    await conn.close();
  }

  return attractions;
}

class ReviewsTab extends StatelessWidget {
  final List<Map<String, dynamic>> reviewsData;
  const ReviewsTab({super.key, required this.reviewsData});

  double calculateAverageRating(List<Review> reviews) {
    if (reviews.isEmpty) return 0.0;

    double totalRating = 0.0;
    for (var review in reviews) {
      totalRating +=
          review.rating.toDouble(); // Convert to double for averaging
    }
    return totalRating / reviews.length;
  }

  @override
  Widget build(BuildContext context) {
    final List<Review> reviews = reviewsData.map((data) {
      return Review(
        username: data['username'],
        date: '', // Populate this as needed
        reviewText: data['reviewText'],
        rating: (data['rating'] is double)
            ? data['rating'].toInt() // Convert double to int
            : data['rating']
                as int, // Otherwise, just use it as int // Ensure it's an int
      );
    }).toList();

    double averageRating = calculateAverageRating(reviews);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Reviews',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      averageRating.toStringAsFixed(
                          1), // Display average rating with 1 decimal
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    RatingBar(
                      totalRatings: reviews.length,
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: RatingBreakdown(reviews: reviews),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'All Reviews (${(reviews.length)})',
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
                      fontSize: 12,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const AttractionWriteReviewPage()),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 2),
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
          ],
        ),
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
    List<int> starCount =
        List<int>.filled(5, 0); // Create a list to hold star counts for 5 stars

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
  //final double averageRating;
  final int totalRatings;

  const RatingBar({
    super.key,
    //required this.averageRating,
    required this.totalRatings,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //const Icon(Icons.star, color: Colors.amber),

        Text(
          '($totalRatings reviews)',
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
                    (index) => const Icon(
                      Icons.star,
                      color: Color(0xffffc700),
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Review Text
            Text(reviewText),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

Future<List<Map<String, dynamic>>> getAboutDetailsFromAzure(
    int attractionId, double latitude, double longitude) async {
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
      SELECT tbl_places.name, tbl_places_attribute.attribute_category, tbl_places_attribute.attribute_string
        FROM tbl_places_attribute
        JOIN tbl_places ON tbl_places_attribute.places_id = tbl_places.places_id
      WHERE tbl_places.places_id = @attractionId;
    ''',
      substitutionValues: {'attractionId': '$attractionId'},
    );

    for (var row in results) {
      attractions.add({
        'name': row[0].toString(),
        'category': row[1].toString(),
        'string': row[2].toString(),
      });
    }
  } catch (e) {
    print('Error: $e');
  } finally {
    await conn.close();
  }

  return attractions;
}

class AboutTab extends StatelessWidget {
  final List<Map<String, dynamic>> data3;
  const AboutTab({super.key, required this.data3});

  @override
  Widget build(BuildContext context) {
    // Check if the data list is empty
    if (data3.isEmpty) {
      return const Center(child: Text('No data available.'));
    }

    // Extract the name from the first item
    String name = data3[0]['name'] ?? 'No name available';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold), // Style the name
        ),
        const SizedBox(height: 16),
        ...data3.skip(1).map<Widget>((item) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  '• ${item['category'] ?? 'No category available'}', // Bullet point for category
                  style: const TextStyle(fontSize: 16)), // Style category text
              Text(item['string'] ?? 'No string available', // Display string
                  style: const TextStyle(fontSize: 14)), // Style string text
              const SizedBox(height: 8), // Add some spacing
            ],
          );
        }).toList(),
      ],
    );
  }
}

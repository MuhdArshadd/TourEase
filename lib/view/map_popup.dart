import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'dart:typed_data';
import '../dbConnection/dbConnection.dart';

Future<List<Map<String, dynamic>>> getAttractionFromAzure(String id) async {
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
        tbl_places.places_image,
        tbl_places.name, 
        tbl_places.latitude, 
        tbl_places.longitude,
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
        TO_CHAR(tbl_places_operating_hours.sunday_end, 'HH24:MI') AS sunday_end,
        tbl_places_attribute.attribute_string,
        (SELECT 
            COALESCE(
                (SELECT SUM(rating_score) FROM tbl_places_rating WHERE places_id = @id) /
                (CASE 
                    WHEN (SELECT COUNT(*) FROM tbl_places_rating WHERE places_id = @id) > 0 
                    THEN (SELECT COUNT(*) FROM tbl_places_rating WHERE places_id = @id) 
                    ELSE 1 
                END), 
            0) AS average_rating
        )
    FROM 
        tbl_places
    JOIN 
        tbl_places_attribute ON tbl_places.places_id = tbl_places_attribute.places_id
    JOIN 
        tbl_places_operating_hours ON tbl_places.places_id = tbl_places_operating_hours.places_id
    JOIN 
        tbl_places_rating ON tbl_places_rating.places_id = tbl_places.places_id
    WHERE 
       tbl_places.places_id = @id;
    ''',
      substitutionValues: {'id': id},
    );

    for (var row in results) {
      attractions.add({
        'places_image': row[0] as Uint8List,
        'name': row[1].toString(),
        'latitude': row[2].toString(),
        'longitude': row[3].toString(),
        'is24': row[4].toString(),
        'monday_start': row[5].toString(),
        'monday_end': row[6].toString(),
        'tuesday_start': row[7].toString(),
        'tuesday_end': row[8].toString(),
        'wednesday_start': row[9].toString(),
        'wednesday_end': row[10].toString(),
        'thursday_start': row[11].toString(),
        'thursday_end': row[12].toString(),
        'friday_start': row[13].toString(),
        'friday_end': row[14].toString(),
        'saturday_start': row[15].toString(),
        'saturday_end': row[16].toString(),
        'sunday_start': row[17].toString(),
        'sunday_end': row[18].toString(),
        'attribute_string': row[19].toString(),
        'average_rating': row[20].toString(),
      });
    }
  } catch (e) {
    print('Error: $e');
  } finally {
    await conn.close();
  }

  return attractions;
}

class MapPopupPage extends StatefulWidget {
  final String placeId;
  const MapPopupPage(
      {super.key, required this.placeId}); // Store placeId in constructor

  @override
  _MapPopupPageState createState() => _MapPopupPageState();
}

class _MapPopupPageState extends State<MapPopupPage> {
  bool isFavorite = false;

  Future<List<Map<String, dynamic>>> fetchAttractions() {
    return getAttractionFromAzure(widget.placeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Map Overview'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchAttractions(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No attractions found.'));
              } else {
                var attraction = snapshot.data!.first;
                print(attraction['average_rating']);
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                                16.0), // Adjust the border radius as needed
                            child: Container(
                              height: 250,
                              width: 360,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      Image.memory(attraction['places_image'])
                                          .image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          // const Positioned(
                          //   top: 0.0,
                          //   left: 0.0,
                          //   child: Chip(
                          //     label: Text(
                          //       'Live: Pesta Layang-Layang',
                          //       style: TextStyle(fontSize: 12),
                          //     ),
                          //     backgroundColor: Colors.white,
                          //     materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          //   ),
                          // ),
                        ],
                      ),

                      const SizedBox(height: 16.0),
                      // Beach Information
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            attraction['name'], // Use placeId here
                            style: const TextStyle(
                                fontSize: 24.0, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                isFavorite =
                                    !isFavorite; // Toggle favorite state
                              });
                              // Add any additional favorite handling here if needed
                            },
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      /*Text(
                        attraction['name'], // Use placeId here
                        style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                      ),*/
                      const Text(
                        'Busy',
                        style: TextStyle(color: Colors.red),
                      ),
                      const Text(
                        '17:00-20:00',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      //const SizedBox(height: 8.0),
                      Row(
                        children: [
                          StarRating(
                            rating: double.tryParse(
                                    attraction['average_rating'] ?? '0') ??
                                0.0, // Set your rating here
                            starSize:
                                20.0, // Optional: set the size of the stars
                            starColor: Colors
                                .amber, // Optional: set the color of the stars
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      const Text(
                        'Special Features',
                        style: TextStyle(fontSize: 18),
                      ),
                      Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.nature_outlined,
                                color: Colors.green),
                            title: const Text('Picturesque'),
                            subtitle: Text(attraction['attribute_string']),
                          ),
                          const Divider()
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      const Text(
                        'Recent Reviews',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        height: 150.0, // Adjust height as needed
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: const [
                            ReviewCard(
                              reviewerName: 'Audrey',
                              reviewDate: '4 January 2024',
                              rating: 4.5,
                              reviewText: 'Great place. Highly recommend!',
                            ),
                            SizedBox(width: 12.0),
                            ReviewCard(
                              reviewerName: 'Audrey',
                              reviewDate: '17 November 2023',
                              rating: 4.5,
                              reviewText: 'Great place. Highly recommend!',
                            ),
                            // Add more ReviewCards if needed
                          ],
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to see more reviews page
                        },
                        style: ElevatedButton.styleFrom(
                          side: const BorderSide(
                              color: Colors.black), // border color
                        ),
                        child: const Text('See Reviews'),
                      ),
                    ],
                  ),
                );
              }
            }));
  }
}

class StarRating extends StatelessWidget {
  final double rating; // Rating value, e.g., 4.5
  final double starSize; // Size of each star
  final Color starColor; // Color of the stars

  const StarRating({
    super.key,
    required this.rating,
    this.starSize = 24.0, // Default star size
    this.starColor = Colors.amber, // Default star color
  });

  @override
  Widget build(BuildContext context) {
    // Full stars count
    int fullStars = rating.floor();
    // Half star or not
    bool hasHalfStar = (rating - fullStars) >= 0.5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Full stars
        for (int i = 0; i < fullStars; i++)
          Icon(Icons.star, color: starColor, size: starSize),
        // Half star
        if (hasHalfStar)
          Icon(Icons.star_half, color: starColor, size: starSize),
        // Empty stars
        for (int i = 0; i < (5 - fullStars - (hasHalfStar ? 1 : 0)); i++)
          Icon(Icons.star_border, color: starColor, size: starSize),
      ],
    );
  }
}

class ReviewCard extends StatelessWidget {
  final String reviewerName;
  final String reviewDate;
  final double rating;
  final String reviewText;

  const ReviewCard({
    super.key,
    required this.reviewerName,
    required this.reviewDate,
    required this.rating,
    required this.reviewText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180.0, // Adjust width as needed
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 16.0,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 8.0),
              Text(
                reviewerName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 4.0),
          StarRating(
            rating: rating,
            starSize: 16.0,
            starColor: Colors.amber,
          ),
          const SizedBox(height: 4.0),
          Text(reviewText),
          const SizedBox(height: 4.0),
          Text(
            reviewDate,
            style: const TextStyle(color: Colors.grey, fontSize: 12.0),
          ),
        ],
      ),
    );
  }
}

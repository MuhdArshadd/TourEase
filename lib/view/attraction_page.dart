import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/location_state.dart';
import 'login_user.dart';
import 'attraction_detail_page.dart';
import 'custom_drawer.dart';
import 'login_state.dart';

import '../dbConnection/dbConnection.dart';
import 'package:postgres/postgres.dart';
import 'dart:typed_data';

class AttractionPage extends StatefulWidget {
  final String? profileImageUrl;
  const AttractionPage(
      {super.key,
      this.profileImageUrl,
      required void Function(bool status) onLoginChanged});

  @override
  _AttractionPageState createState() => _AttractionPageState();
}

class _AttractionPageState extends State<AttractionPage> {
  late Future<List<Map<String, dynamic>>> attractionsFuture;

  @override
  void initState() {
    super.initState();
    final locationState = Provider.of<LocationState>(context, listen: false);
    double? latitude = locationState.latitude;
    double? longitude = locationState.longitude;
    attractionsFuture = getPlacesFromAzure(latitude!, longitude!);
  }

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
        automaticallyImplyLeading: false,
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
                  loginState.updateLoginStatus(true);
                }
              },
            ),
          ] else ...[
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: CircleAvatar(
                    backgroundImage: widget.profileImageUrl != null
                        ? NetworkImage(widget.profileImageUrl!)
                        : const AssetImage('assets/profile_picture.jpg')
                            as ImageProvider,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                );
              },
            ),
          ],
        ],
      ),
      endDrawer: CustomDrawer(
        profileImageUrl: widget.profileImageUrl,
        onLoginChanged: loginState.updateLoginStatus,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: ' Search for attractions',
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
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: attractionsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No attractions found.'));
                  }

                  final attractions = snapshot.data!;

                  return ListView(
                    children: <Widget>[
                      const Text(
                        'Attractions Near You',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: attractions.length,
                        itemBuilder: (context, index) {
                          final attraction = attractions[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AttractionDetailPage(
                                      attractionId:
                                          int.parse(attraction['places_id'])),
                                ),
                              );
                            },
                            child: AttractionCard(
                              imageBytes: attraction['imageBytes'],
                              title: attraction['title'],
                              distance: attraction['distance'],
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AttractionCard extends StatelessWidget {
  final Uint8List imageBytes;
  final String title;
  final String distance;

  const AttractionCard({
    super.key,
    required this.imageBytes,
    required this.title,
    required this.distance,
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
            Container(
              height: 100,
              color: Colors.grey[300],
              child: Image.memory(imageBytes, fit: BoxFit.cover),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(distance),
          ],
        ),
      ),
    );
  }
}

Future<List<Map<String, dynamic>>> getPlacesFromAzure(
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
      SELECT places_id, places_image, name, latitude, longitude,
      (6371 * acos(
        cos(radians($latitude)) * cos(radians(latitude)) * cos(radians(longitude) - radians($longitude)) +
        sin(radians($latitude)) * sin(radians(latitude))
      )) AS distance
      FROM tbl_places
      WHERE places_image IS NOT NULL
      ORDER BY distance
      LIMIT 5
    ''');

    for (var row in results) {
      attractions.add({
        'places_id': row[0].toString(),
        'imageBytes': row[1] as Uint8List,
        'title': row[2].toString(),
        'distance': '${row[5].toStringAsFixed(2)} KM away',
      });
    }
  } catch (e) {
    print('Error: $e');
  } finally {
    await conn.close();
  }

  return attractions;
}

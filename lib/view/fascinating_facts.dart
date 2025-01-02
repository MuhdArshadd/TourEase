import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'bottom_nav_bar.dart';
import 'custom_drawer.dart';
import 'fascinating_view_page.dart';
import 'login_state.dart';

class FascinatingFactsPage extends StatefulWidget {
  final String? profileImageUrl; // URL for the profile image
  const FascinatingFactsPage({super.key, this.profileImageUrl});

  @override
  _FascinatingFactsPageState createState() => _FascinatingFactsPageState();
}

class _FascinatingFactsPageState extends State<FascinatingFactsPage> {
  int _selectedIndex = 0;

  // Navigation logic for the BottomNavigationBar
  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      if (index == 0) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } else {
      setState(() {
        _selectedIndex = index;
      });

      switch (index) {
        case 0:
          break;
        case 1:
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainPage(selectedIndex: 1)),
                (Route<dynamic> route) => false,
          );
          break;
        case 2:
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainPage(selectedIndex: 2)),
                (Route<dynamic> route) => false,
          );
          break;
        case 3:
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainPage(selectedIndex: 3)),
                (Route<dynamic> route) => false,
          );
          break;
      }
    }
  }

  final List<Map<String, String>> facts = [
    {
      'title': 'Malaysian Rainforest',
      'shortDescription': 'The rainforests of Malaysia are some of the oldest in the world, teeming with diverse wildlife and plant species.',
      'fullDescription': 'The rainforests of Malaysia are among the oldest...',
      'image': 'assets/nature.webp',
    },
    {
      'title': 'Cultural Diversity',
      'shortDescription': 'Malaysia is a melting pot of different cultures...',
      'fullDescription': 'Malaysia’s cultural diversity is a blend of various...',
      'image': 'assets/culture.jpg', // Ensure the path is correct
    },
  ];

  void _onFactTap(String image,String title, String shortDescription, String fullDescription) {
    // Navigate to FascinatingViewPage with both short and full descriptions
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FascinatingViewPage(
          image: image,
          title: title,
          shortDescription: shortDescription,
          fullDescription: fullDescription,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loginState = Provider.of<LoginState>(context); // Access login state
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Tour',
                  style: TextStyle(
                      color: Color(0xff0b036c),
                      fontWeight: FontWeight.bold,
                      fontSize: 24
                  ),
                ),
                TextSpan(
                  text: 'Ease',
                  style: TextStyle(
                    color: Color(0xffe80000),
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ]
          ),
        ),
        actions: [
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: CircleAvatar(
                  backgroundImage: widget.profileImageUrl != null
                      ? NetworkImage(widget.profileImageUrl!)
                      : const AssetImage('assets/profile_picture.jpg') as ImageProvider,
                ),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          ),
        ],
      ),
      endDrawer: CustomDrawer(
        profileImageUrl: widget.profileImageUrl,
        onLoginChanged: loginState.updateLoginStatus,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12.0),
              const Text(
                'Interesting Facts',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const Text(
                'Discover the must-visit places in Malaysia',
                style: TextStyle(fontSize: 12),
              ),
              // Facts List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: facts.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: GestureDetector(
                      onTap: () => _onFactTap(
                        facts[index]['image'] ?? 'assets/nature.webp',
                        facts[index]['title'] ?? 'No Title',
                        facts[index]['shortDescription'] ?? 'No Description',
                        facts[index]['fullDescription'] ?? 'No Full Description',
                      ),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 160,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                              ),
                              child: Center(
                                child: Image.asset(
                                  facts[index]['image'] ?? 'assets/event_logo.webp', // Default fallback image
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    facts[index]['title'] ?? 'No Title',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    facts[index]['shortDescription'] ?? 'No Short Description',
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
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

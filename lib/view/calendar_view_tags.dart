import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:TourEase/view/calendar_view.dart';
import '../main.dart';
import 'bottom_nav_bar.dart';
import 'custom_drawer.dart';
import 'login_state.dart';

class CalendarViewTags extends StatefulWidget {
  final String? profileImageUrl; // URL for the profile image

  const CalendarViewTags({super.key, this.profileImageUrl});

  @override
  _CalendarViewTagsState createState() => _CalendarViewTagsState();
}

class _CalendarViewTagsState extends State<CalendarViewTags> {
  get profileImageUrl => null;
  int _selectedIndex = 2;

  // Navigation logic for the BottomNavigationBar
  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      // If the user taps on the already selected 'review' tab, navigate to the ReviewPage
      if (index == 2) {
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
        //stay
          break;
        case 3:
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainPage(selectedIndex: 2)), // Calendar tab
                (Route<dynamic> route) => false,
          );

          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginState = Provider.of<LoginState>(context); // Access login state
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
        onLoginChanged: loginState.updateLoginStatus,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: ' Search for events, categories, tags',
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
            const SizedBox(height: 14.0),
            const Text(
              'Music',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.music_note_outlined, color: Colors.black),
                  title: const Text('Live Music Night'),
                  subtitle: const Text('Oct 5, 3:00 PM'),
                  trailing: const Text(
                    'Concert Hall',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  onTap: () {
                    // TODO: Navigate to event details
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.queue_music, color: Colors.blue),
                  title: const Text('Rock Fest'),
                  subtitle: const Text('Oct 12, 6:00 PM'),
                  trailing: const Text(
                    'Outdoor Arena',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  onTap: () {
                    // TODO: Navigate to event details
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CalendarViewPage(placeId: '2',),
                      ),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.queue_music, color: Colors.blue),
                  title: const Text('Rock Fest'),
                  subtitle: const Text('Oct 12, 6:00 PM'),
                  trailing: const Text(
                    'Outdoor Arena',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  onTap: () {
                    // TODO: Navigate to event details
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CalendarViewPage(placeId: '2',),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Related Events',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.grey[200],
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4.0,
                          spreadRadius: 2.0,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 100,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(8.0),
                                ),
                                image: DecorationImage(
                                  image: AssetImage('assets/music_event.webp'), // Placeholder image
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(4.0),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  bottomRight: Radius.circular(8.0),
                                ),
                              ),
                              child: const Text(
                                'Music',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Concert', style: TextStyle(fontSize: 16)),
                              SizedBox(height: 4.0),
                              Text('Live Music Night', style: TextStyle(fontSize: 14)),
                              SizedBox(height: 4.0),
                              Text('Oct 10, 7:00 PM', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.grey[200],
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4.0,
                          spreadRadius: 2.0,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 100,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(8.0),
                                ),
                                image: DecorationImage(
                                  image: AssetImage('assets/culinary_event.webp'), // Placeholder image
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(4.0),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  bottomRight: Radius.circular(8.0),
                                ),
                              ),
                              child: const Text(
                                'Culinary',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Food', style: TextStyle(fontSize: 16)),
                              SizedBox(height: 4.0),
                              Text('Gourmet Food Tasting', style: TextStyle(fontSize: 14)),
                              SizedBox(height: 4.0),
                              Text('Oct 18, 6:30 PM', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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

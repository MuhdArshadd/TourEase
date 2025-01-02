import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'bottom_nav_bar.dart';
import 'custom_drawer.dart';
import 'login_state.dart';

class FascinatingViewPage extends StatefulWidget {
  final String image;
  final String title;
  final String shortDescription;
  final String fullDescription;


  const FascinatingViewPage({
    super.key,
    required this.image,
    required this.title,
    required this.shortDescription,
    required this.fullDescription,
  });

  get profileImageUrl => null;



  @override
  _FascinatingViewPageState createState() => _FascinatingViewPageState();
}

class _FascinatingViewPageState extends State<FascinatingViewPage> {
  bool isExpanded = false;

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

  @override
  Widget build(BuildContext context) {
    final loginState = Provider.of<LoginState>(context); // Access login state
    return Scaffold(
      appBar: AppBar(
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Discover the must-visit places in Malaysia',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 16),
              Container(
                height: 200,
                color: Colors.grey[300],
                child: Center(
                  child: Image.asset(widget.image),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isExpanded ? widget.fullDescription : widget.shortDescription,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0b036c),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text(
                    isExpanded ? "Show Less <" : "See More >",
                    style: const TextStyle(fontSize: 14,color: Colors.white),
                  ),
                ),
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


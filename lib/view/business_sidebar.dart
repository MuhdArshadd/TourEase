import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:TourEase/view/home_page.dart';

import '../main.dart';
import 'login_state.dart';

class BusinessSidebar extends StatelessWidget {
  final String? profileImageUrl;

  const BusinessSidebar({
    super.key,
    required this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: const Text('Khalis Zakwan'), // Replace with dynamic data if needed
            accountEmail: const Text('biss@gmail.com'), // Replace with dynamic data if needed
            currentAccountPicture: CircleAvatar(
              backgroundImage: profileImageUrl != null
                  ? NetworkImage(profileImageUrl!)
                  : const AssetImage('assets/default_profile.jpg') as ImageProvider,
            ),
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
          ),
          // Add a Spacer to push the button down
          const Spacer(), // This takes up remaining space
          ListTile(
            title: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 35),
                ),
                onPressed: () {
                  Provider.of<LoginState>(context, listen: false).updateLoginStatus(false);
                  //Navigator.pop(context); // Close the drawer
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MainPage(selectedIndex: 0)), // Navigate to homepage
                        (Route<dynamic> route) => false, // Clear the stack
                  );
                },
                child: const Text('Log out', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

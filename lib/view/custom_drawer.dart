import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:TourEase/view/ai_chat_page.dart';
import '../main.dart';
import 'favourite_places_page.dart';
import 'login_state.dart';
import 'user_profile.dart';

class CustomDrawer extends StatelessWidget {
  final String? profileImageUrl;
  final Function(bool) onLoginChanged;

  const CustomDrawer({
    super.key,
    required this.profileImageUrl,
    required this.onLoginChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: const Text('Hana Humaira'), // Replace with dynamic data if needed
            accountEmail: const Text('pompompurin@gmail.com'), // Replace with dynamic data if needed
            currentAccountPicture: CircleAvatar(
              backgroundImage: profileImageUrl != null
                  ? NetworkImage(profileImageUrl!)
                  : const AssetImage('assets/profile_picture.jpg') as ImageProvider,
            ),
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('User Profile'),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MainPage(selectedIndex: 3)), // Calendar tab
                    (Route<dynamic> route) => false,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Favourite Places'),
            onTap: () {
              Navigator.push(
                context,
                //Ni sementara dia akan ke map popup nnti aku tukar
                MaterialPageRoute(builder: (context) => FavouritePlacesPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Chat with AI'),
            onTap: () {
              Navigator.push(
                context,
                //Ni sementara dia akan ke map popup nnti aku tukar
                MaterialPageRoute(builder: (context) => const AIChatPage()),
              );
              // Handle the action for Chat with AI
            },
          ),
          const Divider(),
          ListTile(
            title: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 35),
                ),
                onPressed: () {
                  //onLoginChanged(false); // Log out action
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

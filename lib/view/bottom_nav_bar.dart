import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:TourEase/view/register_main.dart';
import 'package:TourEase/view/search_fullmap_page.dart';
import 'package:TourEase/view/user_profile.dart';

import 'login_state.dart';
import 'login_user.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  //final VoidCallback onFabPressed; // Callback for FAB action

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    //required this.onFabPressed, // Receive the callback for FAB
  });

  @override
  Widget build(BuildContext context) {
    final loginState = Provider.of<LoginState>(context); // Access login state
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // BottomAppBar with icons
        BottomAppBar(
          notchMargin: 10.0,
          //shape: const CircularNotchedRectangle(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Home Icon
                IconButton(
                  icon: Icon(
                    Icons.home_outlined,
                    color: selectedIndex == 0 ? Colors.blue : Colors.grey,
                  ),
                  onPressed: () => onItemTapped(0),
                ),
                // Map Icon
                IconButton(
                  icon: Icon(
                    Icons.map_outlined,
                    color: selectedIndex == 1 ? Colors.blue : Colors.grey,
                  ),
                  onPressed: () => onItemTapped(1),
                ),
                const SizedBox(width: 40), // Space for FAB
                // Calendar Icon
                IconButton(
                  icon: Icon(
                    Icons.calendar_today_outlined,
                    color: selectedIndex == 2 ? Colors.blue : Colors.grey,
                  ),
                  onPressed: () => onItemTapped(2),
                ),
                // Profile Icon
                IconButton(
                  icon: Icon(
                    Icons.person_outline,
                    color: selectedIndex == 3 ? Colors.blue : Colors.grey,
                  ),
                  //onPressed: () => onItemTapped(3),
                  onPressed: () async {
                    if (loginState.isLoggedIn) {
                      onItemTapped(3); // Navigate to User Profile
                    } else {
                      //onItemTapped(4); // Navigate to Review Main
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginPage(onLoginChanged: (isLoggedIn) {
                              if (isLoggedIn) loginState.updateLoginStatus;
                            })
                        ),
                      );
                      if(result == true){
                        loginState.updateLoginStatus(true); //update login status
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),

        // Floating Action Button positioned over the bottom app bar
        Positioned(
          bottom: 15.0, // Adjust the position of FAB
          child: SizedBox(
            height: 65.0,
            width: 65.0,
            child: FloatingActionButton(
              backgroundColor: const Color(0xff0b036c),
              shape: const StadiumBorder(),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullMapPage(
                    ),
                  ),
                );
              }, // Call the provided callback
              child: const Icon(
                Icons.search,
                color: Colors.white,
                size: 30.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

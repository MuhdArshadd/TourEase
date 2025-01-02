import 'package:flutter/material.dart';
import 'package:TourEase/view/register_business_acc.dart';
import 'package:TourEase/view/register_user.dart';

class RegisterMainPage extends StatelessWidget {
  const RegisterMainPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
     appBar: AppBar(
       elevation: 2,
     ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Create Account',
                style: TextStyle(color: Color(0xff0b036c), fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12.0),
              const Text(
                'Choose your account type',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0b036c),// Button color
                  padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 140),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterUserPage()),
                  );
                },
                child: const Text(
                  'Personal',
                  style: TextStyle(
                    color: Colors.white,fontSize: 16
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0b036c),// Button color
                  padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 140),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterBusinessPage()),
                  );
                },
                child: const Text(
                  'Business',
                  style: TextStyle(
                      color: Colors.white,fontSize: 16
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
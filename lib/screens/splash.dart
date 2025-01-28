import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pn_fl_jewellery_empire/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Method to check if the user is logged in
  Future<void> _checkLoginStatus() async {
    // Wait for a few seconds before navigating
    Timer(const Duration(seconds: 3), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isLoggedIn = prefs.getString('token') != null;

      // Navigate based on login status
      if (isLoggedIn) {
        Navigator.pushReplacementNamed(context, '/home'); // Navigate to home screen
      } else {
        Navigator.pushReplacementNamed(context, '/login'); // Navigate to login screen
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(fixPadding * 2.0),
          children: [
            Center(
              child: Image.asset(
                "assets/splash/logo.jpg", // Your splash logo
                height: 80.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

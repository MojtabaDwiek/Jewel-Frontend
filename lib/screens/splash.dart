import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pn_fl_jewellery_empire/theme/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushNamed(context, '/login');
    });
    super.initState();
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
                "assets/splash/app_icon.png",
                height: 80.0,
              ),
            ),
            const Text(
              "JEWELRY EMPIRE",
              style: TextStyle(
                color: blackColor,
                fontSize: 26.0,
                fontWeight: FontWeight.w400,
                fontFamily: 'Arya',
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}

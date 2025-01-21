import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pn_fl_jewellery_empire/theme/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  DateTime? backPressTime;

  @override
  Widget build(BuildContext context) {
    MediaQuery.sizeOf(context);
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        bool backStatus = onPopInvoked();
        if (backStatus) {
          exit(0);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(fixPadding * 2.0,
                fixPadding * 3.0, fixPadding * 2.0, fixPadding * 2.0),
            children: [
              contentText(),
              heightBox(fixPadding * 15),
              userNameOrEmailField(),
              heightBox(fixPadding * 2.8),
              passwordField(),
              heightBox(2.0),
              
              heightBox(fixPadding * 2.8),
              loginButton(),
              heightBox(fixPadding * 2.8),
              
              heightSpace,
              heightSpace,
              
            ],
          ),
        ),
       
      ),
    );
  }

  


  loginButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/home');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: fixPadding * 2.0, vertical: fixPadding * 1.5),
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: blackColor,
        ),
        alignment: Alignment.center,
        child: const Text(
          "Login",
          style: medium19White,
        ),
      ),
    );
  }


  passwordField() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Password",
          style: regular15Grey,
        ),
        TextField(
          obscureText: true,
          obscuringCharacter: "•",
          cursorColor: primaryColor,
          style: regular17Black,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            isDense: true,
            border: InputBorder.none,
            enabledBorder: underlineInputBorder,
            focusedBorder: underlineInputBorder,
            hintText: "Enter Password",
            hintStyle: regular17Grey,
            contentPadding:
                EdgeInsets.only(top: fixPadding * 0.7, bottom: fixPadding),
          ),
        )
      ],
    );
  }

  userNameOrEmailField() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Username",
          style: regular15Grey,
        ),
        TextField(
          cursorColor: primaryColor,
          style: regular17Black,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            isDense: true,
            border: InputBorder.none,
            enabledBorder: underlineInputBorder,
            focusedBorder: underlineInputBorder,
            hintText: "Enter Username",
            hintStyle: regular17Grey,
            contentPadding:
                EdgeInsets.only(top: fixPadding * 0.7, bottom: fixPadding),
          ),
        )
      ],
    );
  }

  contentText() {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
    children: [
      SizedBox(height: 10), // Add space at the top to push the text down
      Text(
        "Login",
        style: TextStyle(
          fontSize: 40, // Increase font size
          fontWeight: FontWeight.bold, // Make it bold
          color: Colors.black, // Set text color
        ),
      ),
    ],
  );
}

  onPopInvoked() {
    DateTime now = DateTime.now();
    if (backPressTime == null ||
        now.difference(backPressTime!) >= const Duration(seconds: 2)) {
      backPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: blackColor,
          duration: Duration(milliseconds: 1500),
          behavior: SnackBarBehavior.floating,
          content: Text(
            "Press back once again to exit",
            style: medium16White,
          ),
        ),
      );
      return false;
    } else {
      return true;
    }
  }
}

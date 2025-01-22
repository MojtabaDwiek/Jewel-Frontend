import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pn_fl_jewellery_empire/theme/theme.dart'; // Ensure this file exists
import 'package:pn_fl_jewellery_empire/services/api_service.dart'; // Import the API service

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  DateTime? backPressTime;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // Track loading state

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token != null) {
      // User is already logged in, navigate to the home screen
      Navigator.pushNamed(context, '/home');
    }
  }

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
            padding: const EdgeInsets.fromLTRB(
              fixPadding * 2.0,
              fixPadding * 3.0,
              fixPadding * 2.0,
              fixPadding * 2.0,
            ),
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

  Widget loginButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _handleLogin, // Disable button while loading
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: fixPadding * 2.0,
          vertical: fixPadding * 1.5,
        ),
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: _isLoading ? Colors.grey : blackColor, // Change color when loading
        ),
        alignment: Alignment.center,
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white) // Show loading indicator
            : const Text(
                "Login",
                style: medium19White,
              ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    // Input validation
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both username and password'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Start loading
    });

    try {
      // Call the API service for login
      final response = await ApiService.login(username, password); // Use the correct method
      final String token = response['token'];
      final user = response['user']; // This could be a customer or retailer

      // Save the token using shared_preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      print('Login successful: $user');
      Navigator.pushNamed(context, '/home');
    } catch (error) {
      // Show error message if login fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: $error'),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  Widget passwordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Password",
          style: regular15Grey,
        ),
        TextField(
          controller: _passwordController,
          obscureText: true,
          obscuringCharacter: "•",
          cursorColor: primaryColor,
          style: regular17Black,
          keyboardType: TextInputType.visiblePassword,
          decoration: const InputDecoration(
            isDense: true,
            border: InputBorder.none,
            enabledBorder: underlineInputBorder,
            focusedBorder: underlineInputBorder,
            hintText: "Enter Password",
            hintStyle: regular17Grey,
            contentPadding:
                EdgeInsets.only(top: fixPadding * 0.7, bottom: fixPadding),
          ),
        ),
      ],
    );
  }

  Widget userNameOrEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Username",
          style: regular15Grey,
        ),
        TextField(
          controller: _usernameController,
          cursorColor: primaryColor,
          style: regular17Black,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            isDense: true,
            border: InputBorder.none,
            enabledBorder: underlineInputBorder,
            focusedBorder: underlineInputBorder,
            hintText: "Enter Username",
            hintStyle: regular17Grey,
            contentPadding:
                EdgeInsets.only(top: fixPadding * 0.7, bottom: fixPadding),
          ),
        ),
      ],
    );
  }

  Widget contentText() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 10),
        Text(
          "Login",
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  bool onPopInvoked() {
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
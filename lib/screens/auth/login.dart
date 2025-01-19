import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ant_design.dart';
import 'package:iconify_flutter_plus/icons/bx.dart';
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
    final size = MediaQuery.sizeOf(context);
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
              heightBox(fixPadding * 2.8),
              userNameOrEmailField(),
              heightBox(fixPadding * 2.8),
              passwordField(),
              heightBox(2.0),
              forgetPasswordText(),
              heightBox(fixPadding * 2.8),
              loginButton(),
              heightBox(fixPadding * 2.8),
              orText(),
              heightSpace,
              heightSpace,
              loginWithGoogle(size),
              heightSpace,
              height5Space,
              loginWithFacebook(size),
              heightSpace,
              height5Space,
              loginWithApple(size),
            ],
          ),
        ),
        bottomNavigationBar: registerNowButton(context),
      ),
    );
  }

  registerNowButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      padding: const EdgeInsets.fromLTRB(
          fixPadding * 2.0, fixPadding, fixPadding * 2.0, fixPadding * 2.0),
      child: Text.rich(
        TextSpan(
          text: "Don’t have an account?",
          style: regular15Grey,
          children: [
            const TextSpan(text: " "),
            TextSpan(
              text: "Register Now",
              style: medium15Black,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pushNamed(context, '/register');
                },
            )
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  loginWithApple(Size size) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.all(fixPadding * 1.3),
      decoration: BoxDecoration(
        color: blackColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Iconify(
            AntDesign.apple_filled,
            size: 24.0,
            color: whiteColor,
          ),
          widthSpace,
          widthSpace,
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width - 140),
            child: const Text(
              "Continue with Apple",
              style: medium16White,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }

  loginWithFacebook(Size size) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.all(fixPadding * 1.3),
      decoration: BoxDecoration(
        color: blueColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Iconify(
            Bx.bxl_facebook,
            size: 24.0,
            color: whiteColor,
          ),
          widthSpace,
          widthSpace,
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width - 140),
            child: const Text(
              "Continue with Facebook",
              style: medium16White,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }

  loginWithGoogle(Size size) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.all(fixPadding * 1.3),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: blackColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            "assets/icons/google_icon.png",
            height: 24.0,
            width: 24.0,
            fit: BoxFit.cover,
          ),
          widthSpace,
          widthSpace,
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width - 140),
            child: const Text(
              "Continue with Google",
              style: medium16Black,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }

  orText() {
    return const Text(
      "OR",
      style: regular15Grey,
      textAlign: TextAlign.center,
    );
  }

  loginButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/register');
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

  forgetPasswordText() {
    return Text(
      "Forget Password?",
      style: regular15Black.copyWith(decoration: TextDecoration.underline),
      textAlign: TextAlign.end,
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
          "Username or Email",
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
            hintText: "Enter Username or Email",
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Login",
          style: semibold20Black,
        ),
        Text(
          "Please Login to continue",
          style: regular15Black,
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

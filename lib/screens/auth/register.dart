import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pn_fl_jewellery_empire/theme/theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heightSpace,
            heightSpace,
            backButton(context),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(
                    left: fixPadding * 2.0,
                    right: fixPadding * 2.0,
                    bottom: fixPadding * 2.0),
                children: [
                  registerContent(),
                  heightBox(fixPadding * 2.8),
                  fullNameField(),
                  heightBox(fixPadding * 2.8),
                  emailField(),
                  heightBox(fixPadding * 2.8),
                  mobileNumberField(),
                  heightBox(fixPadding * 2.8),
                  passwordField(),
                  height5Space,
                  agreeText(),
                  heightBox(fixPadding * 2.8),
                  registerButton(),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: loginNowButton(context),
    );
  }

  loginNowButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      padding: const EdgeInsets.fromLTRB(
          fixPadding * 2.0, fixPadding, fixPadding * 2.0, fixPadding * 2.0),
      child: Text.rich(
        TextSpan(
          text: "Already have an account?",
          style: regular15Grey,
          children: [
            const TextSpan(text: " "),
            TextSpan(
              text: "Login Now",
              style: medium15Black,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pushNamed(context, '/login');
                },
            )
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  registerButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/otp');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: fixPadding * 1.5, horizontal: fixPadding * 2.0),
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: blackColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        alignment: Alignment.center,
        child: const Text(
          "Register",
          style: medium19White,
        ),
      ),
    );
  }

  agreeText() {
    return Text.rich(
      TextSpan(
        text: "By creating account or logging your agree to our ",
        style: regular15Grey.copyWith(height: 1.5),
        children: const [
          TextSpan(
            text: "Terms & Condition",
            style: medium15Black,
          ),
          TextSpan(
            text: " and ",
            style: regular15Grey,
          ),
          TextSpan(
            text: "Privacy Policy.",
            style: medium15Black,
          ),
        ],
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
          style: regular17Black,
          cursorColor: primaryColor,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            border: InputBorder.none,
            enabledBorder: underlineInputBorder,
            focusedBorder: underlineInputBorder,
            hintText: "Enter Password",
            hintStyle: regular17Grey,
            isDense: true,
            contentPadding:
                EdgeInsets.only(top: fixPadding * 0.7, bottom: fixPadding),
          ),
        )
      ],
    );
  }

  mobileNumberField() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Mobile Number",
          style: regular15Grey,
        ),
        TextField(
          style: regular17Black,
          cursorColor: primaryColor,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            border: InputBorder.none,
            enabledBorder: underlineInputBorder,
            focusedBorder: underlineInputBorder,
            hintText: "Enter Mobile Number",
            hintStyle: regular17Grey,
            isDense: true,
            contentPadding:
                EdgeInsets.only(top: fixPadding * 0.7, bottom: fixPadding),
          ),
        )
      ],
    );
  }

  emailField() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Email Address",
          style: regular15Grey,
        ),
        TextField(
          style: regular17Black,
          cursorColor: primaryColor,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            border: InputBorder.none,
            enabledBorder: underlineInputBorder,
            focusedBorder: underlineInputBorder,
            hintText: "Enter Email Address",
            hintStyle: regular17Grey,
            isDense: true,
            contentPadding:
                EdgeInsets.only(top: fixPadding * 0.7, bottom: fixPadding),
          ),
        )
      ],
    );
  }

  fullNameField() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Full Name",
          style: regular15Grey,
        ),
        TextField(
          style: regular17Black,
          cursorColor: primaryColor,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            border: InputBorder.none,
            enabledBorder: underlineInputBorder,
            focusedBorder: underlineInputBorder,
            hintText: "Enter Full Name",
            hintStyle: regular17Grey,
            isDense: true,
            contentPadding:
                EdgeInsets.only(top: fixPadding * 0.7, bottom: fixPadding),
          ),
        )
      ],
    );
  }

  registerContent() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Register",
          style: semibold20Black,
        ),
        Text(
          "Please Register using your personal details to contiue.",
          style: regular15Black,
        )
      ],
    );
  }

  backButton(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
      onPressed: () {
        Navigator.pop(context);
      },
      icon: const Icon(
        Icons.west,
        color: blackColor,
      ),
    );
  }
}

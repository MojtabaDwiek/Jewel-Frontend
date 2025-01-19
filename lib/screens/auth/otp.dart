import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:pn_fl_jewellery_empire/theme/theme.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
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
                  verticationContent(),
                  heightSpace,
                  heightSpace,
                  otpField(),
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  continueButton(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  continueButton() {
    return GestureDetector(
      onTap: () {
        Timer(const Duration(seconds: 3), () {
          Navigator.popAndPushNamed(context, '/bottombar');
        });
        pleaseWaitDialog();
      },
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(
            horizontal: fixPadding * 2.0, vertical: fixPadding * 1.5),
        decoration: BoxDecoration(
          color: blackColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        alignment: Alignment.center,
        child: const Text(
          "Continue",
          style: medium19White,
        ),
      ),
    );
  }

  pleaseWaitDialog() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: whiteColor,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: fixPadding * 3.2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 30.0,
                  width: 30.0,
                  child: CircularProgressIndicator(
                    color: blackColor,
                    strokeWidth: 2.5,
                  ),
                ),
                heightSpace,
                height5Space,
                Text(
                  "Please wait...",
                  style: regular15Grey,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  otpField() {
    return Pinput(
      cursor: Container(
        height: 20.0,
        width: 1.5,
        color: primaryColor,
      ),
      keyboardType: TextInputType.number,
      onCompleted: (value) {
        Timer(const Duration(seconds: 3), () {
          Navigator.popAndPushNamed(context, '/bottombar');
        });
        pleaseWaitDialog();
      },
      defaultPinTheme: const PinTheme(
        height: 50.0,
        textStyle: regular17Black,
        margin: EdgeInsets.symmetric(horizontal: fixPadding * 0.4),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: blackColor),
          ),
        ),
      ),
      focusedPinTheme: const PinTheme(
        height: 50.0,
        textStyle: regular17Black,
        margin: EdgeInsets.symmetric(horizontal: fixPadding * 0.4),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: primaryColor),
          ),
        ),
      ),
    );
  }

  verticationContent() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Verification",
          style: semibold20Black,
        ),
        Text(
          "Enter verification code. We just sent you on +79 147 825 698",
          style: regular15Black,
        ),
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

import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFFFF7A00);
const Color blackColor = Colors.black;
const Color whiteColor = Colors.white;
const Color greyColor = Color(0xFF949494);
const Color blueColor = Color(0xFF4267B2);
const Color borderColor = Color(0xFFEBF0FF);
const Color greyC4Color = Color(0xFFC4C4C4);
const Color f0Color = Color(0xFFF0F0F0);
const Color lightGreenColor = Color(0xFF009688);
const Color lightBlueColor = Color(0xFF00A7F7);
const Color lightRedColor = Color(0xFFDD5A5A);
const Color redColor = Color(0xFFFF0000);

const double fixPadding = 10.0;

const SizedBox heightSpace = SizedBox(height: fixPadding);
const SizedBox height5Space = SizedBox(height: fixPadding / 2);
const SizedBox widthSpace = SizedBox(width: fixPadding);
const SizedBox width5Space = SizedBox(width: fixPadding / 2);

SizedBox heightBox(double height) => SizedBox(height: height);
SizedBox widthBox(double width) => SizedBox(width: width);

const headerBoxDecoration = BoxDecoration(
  color: whiteColor,
  border: Border(
    bottom: BorderSide(color: borderColor),
  ),
);

const underlineInputBorder =
    UnderlineInputBorder(borderSide: BorderSide(color: blackColor));

const TextStyle extrabold24White =
    TextStyle(color: whiteColor, fontSize: 24.0, fontWeight: FontWeight.w800);

const TextStyle bold18Primary =
    TextStyle(color: primaryColor, fontSize: 18.0, fontWeight: FontWeight.w700);

const TextStyle bold16Primary =
    TextStyle(color: primaryColor, fontSize: 16.0, fontWeight: FontWeight.w700);

const TextStyle bold14Primary =
    TextStyle(color: primaryColor, fontSize: 14.0, fontWeight: FontWeight.w700);

const TextStyle bold22White =
    TextStyle(color: whiteColor, fontSize: 22.0, fontWeight: FontWeight.w700);

const TextStyle bold14Black =
    TextStyle(color: blackColor, fontSize: 14.0, fontWeight: FontWeight.w700);

const TextStyle semibold20Black =
    TextStyle(color: blackColor, fontSize: 20.0, fontWeight: FontWeight.w600);

const TextStyle semibold18Black =
    TextStyle(color: blackColor, fontSize: 18.0, fontWeight: FontWeight.w600);

const TextStyle semibold16Black =
    TextStyle(color: blackColor, fontSize: 16.0, fontWeight: FontWeight.w600);

const TextStyle medium19White =
    TextStyle(color: whiteColor, fontSize: 19.0, fontWeight: FontWeight.w500);

const TextStyle medium19Primary =
    TextStyle(color: primaryColor, fontSize: 19.0, fontWeight: FontWeight.w500);

const TextStyle medium14Primary =
    TextStyle(color: primaryColor, fontSize: 14.0, fontWeight: FontWeight.w500);

const TextStyle medium16White =
    TextStyle(color: whiteColor, fontSize: 16.0, fontWeight: FontWeight.w500);

const TextStyle medium18Black =
    TextStyle(color: blackColor, fontSize: 18.0, fontWeight: FontWeight.w500);

const TextStyle medium16Black =
    TextStyle(color: blackColor, fontSize: 16.0, fontWeight: FontWeight.w500);

const TextStyle medium15Black =
    TextStyle(color: blackColor, fontSize: 15.0, fontWeight: FontWeight.w500);

const TextStyle medium18Grey =
    TextStyle(color: greyColor, fontSize: 18.0, fontWeight: FontWeight.w500);

const TextStyle medium14Grey =
    TextStyle(color: greyColor, fontSize: 14.0, fontWeight: FontWeight.w500);

const TextStyle medium13Grey =
    TextStyle(color: greyColor, fontSize: 13.0, fontWeight: FontWeight.w500);

const TextStyle regular18Black =
    TextStyle(color: blackColor, fontSize: 18.0, fontWeight: FontWeight.w400);

const TextStyle regular17Black =
    TextStyle(color: blackColor, fontSize: 17.0, fontWeight: FontWeight.w400);

const TextStyle regular16Black =
    TextStyle(color: blackColor, fontSize: 16.0, fontWeight: FontWeight.w400);

const TextStyle regular15Black =
    TextStyle(color: blackColor, fontSize: 15.0, fontWeight: FontWeight.w400);

const TextStyle regular17Grey =
    TextStyle(color: greyColor, fontSize: 17.0, fontWeight: FontWeight.w400);

const TextStyle regular16Grey =
    TextStyle(color: greyColor, fontSize: 16.0, fontWeight: FontWeight.w400);

const TextStyle regular15Grey =
    TextStyle(color: greyColor, fontSize: 15.0, fontWeight: FontWeight.w400);

const TextStyle regular14Grey =
    TextStyle(color: greyColor, fontSize: 14.0, fontWeight: FontWeight.w400);

const TextStyle regular16GreyC4 =
    TextStyle(color: greyC4Color, fontSize: 16.0, fontWeight: FontWeight.w400);

const TextStyle regular17White =
    TextStyle(color: whiteColor, fontSize: 17.0, fontWeight: FontWeight.w400);

const TextStyle regular15White =
    TextStyle(color: whiteColor, fontSize: 15.0, fontWeight: FontWeight.w400);

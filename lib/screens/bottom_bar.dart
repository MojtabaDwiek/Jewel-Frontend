import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/carbon.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:pn_fl_jewellery_empire/screens/cart/cart.dart';
import 'package:pn_fl_jewellery_empire/screens/favourite/favourite.dart';
import 'package:pn_fl_jewellery_empire/screens/home/home.dart';
import 'package:pn_fl_jewellery_empire/screens/search/search.dart';
import 'package:pn_fl_jewellery_empire/theme/theme.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key, this.index});

  final int? index;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  late int selectedIndex;

  DateTime? backPressTime;

  final pages = const [
    HomeScreen(),
    SearchScreen(),
    CartScreen(),
    FavouriteScreen()
  
  ];

  @override
  void initState() {
    setState(() {
      selectedIndex = widget.index ?? 0;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        bool backStatus = onPopInvoked();
        if (backStatus) {
          exit(0);
        }
      },
      child: Scaffold(
        body: pages.elementAt(selectedIndex),
        bottomNavigationBar: bottombar(context),
      ),
    );
  }

  bottombar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: fixPadding),
      decoration: BoxDecoration(
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: blackColor.withOpacity(0.1),
            blurRadius: 6.0,
            offset: const Offset(0, -2),
          )
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(splashColor: Colors.transparent),
        child: BottomNavigationBar(
          selectedItemColor: primaryColor,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          selectedFontSize: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            itemWidget(Carbon.home),
            itemWidget(Carbon.search),
            itemWidget(Ph.handbag),
            itemWidget(Ph.heart_straight),
            
          ],
        ),
      ),
    );
  }

  itemWidget(String icon) {
    return BottomNavigationBarItem(
        icon: Column(
          children: [
            Iconify(
              icon,
              color: blackColor,
            ),
            height5Space,
            Container(
              height: 6.0,
              width: 6.0,
              decoration: const BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
            )
          ],
        ),
        activeIcon: Column(
          children: [
            Iconify(
              icon,
              color: primaryColor,
            ),
            height5Space,
            Container(
              height: 6.0,
              width: 6.0,
              decoration: const BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
            )
          ],
        ),
        label: "");
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

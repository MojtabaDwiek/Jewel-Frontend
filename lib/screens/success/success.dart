import 'package:flutter/material.dart';
import 'package:pn_fl_jewellery_empire/theme/theme.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        Navigator.pushNamed(context, '/bottombar');
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(fixPadding * 2.0),
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/success/success-image.png",
                        height: size.height * 0.14,
                      ),
                    ),
                    heightSpace,
                    heightSpace,
                    heightSpace,
                    const Text(
                      "Order Placed Successfully!",
                      style: regular18Black,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/bottombar');
              },
              child: const Text(
                "BACK TO HOME",
                style: bold14Primary,
              ),
            )
          ],
        ),
      ),
    );
  }
}

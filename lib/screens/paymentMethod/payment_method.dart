import 'package:flutter/material.dart';
import 'package:pn_fl_jewellery_empire/theme/theme.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  final paymentMethodList = [
    {"image": "assets/paymentMethod/credit_card.png", "title": "Credit Card"},
    {"image": "assets/paymentMethod/paypal.png", "title": "PayPal"},
    {"image": "assets/paymentMethod/stripe.png", "title": "Stripe"},
    {"image": "assets/paymentMethod/google_pay.png", "title": "Google Pay"},
    {"image": "assets/paymentMethod/cash.png", "title": "Cash on Delivery"},
  ];

  int selectedPaymentMethod = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          header(),
          paymentListContent(),
        ],
      ),
      bottomNavigationBar: confirmButton(),
    );
  }

  confirmButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/success');
      },
      child: Container(
        margin: const EdgeInsets.all(fixPadding * 2.0),
        padding: const EdgeInsets.symmetric(
            vertical: fixPadding * 1.5, horizontal: fixPadding * 2.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: blackColor,
        ),
        child: const Text(
          "Confirm",
          style: medium19White,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  paymentListContent() {
    return Expanded(
      child: ListView.builder(
        itemCount: paymentMethodList.length,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(
            horizontal: fixPadding * 2.0, vertical: fixPadding),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedPaymentMethod = index;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(fixPadding * 1.5),
              margin: const EdgeInsets.symmetric(vertical: fixPadding),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                    color: selectedPaymentMethod == index
                        ? blackColor
                        : borderColor),
              ),
              child: Row(
                children: [
                  Image.asset(
                    paymentMethodList[index]['image'].toString(),
                    height: 28.0,
                    width: 28.0,
                    fit: BoxFit.cover,
                  ),
                  widthSpace,
                  width5Space,
                  Expanded(
                    child: Text(
                      paymentMethodList[index]['title'].toString(),
                      style: medium16Black,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  header() {
    return Container(
      margin: const EdgeInsets.only(top: fixPadding),
      decoration: headerBoxDecoration,
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        leading: IconButton(
          padding: const EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.west,
            color: blackColor,
          ),
        ),
        titleSpacing: fixPadding * 1.5,
        title: const Text(
          "Select Payment Method",
          style: semibold20Black,
        ),
      ),
    );
  }
}

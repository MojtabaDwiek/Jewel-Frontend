import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:pn_fl_jewellery_empire/theme/theme.dart';
import 'package:pn_fl_jewellery_empire/widget/column_builder.dart';

class SelectAddressScreen extends StatefulWidget {
  const SelectAddressScreen({super.key});

  @override
  State<SelectAddressScreen> createState() => _SelectAddressScreenState();
}

class _SelectAddressScreenState extends State<SelectAddressScreen> {
  final addressList = [
    {
      "title": "Home",
      "name": "Samantha Smith",
      "number": "+79 147 896 562",
      "address":
          "Kocherstr. 6, Zimmer 773, 25682, Nord Tino, Sachsen-Anhalt, Germany"
    },
    {
      "title": "Office",
      "name": "Samantha Smith",
      "number": "+79 147 896 562",
      "address":
          "Kocherstr. 6, Zimmer 773, 25682, Nord Tino, Sachsen-Anhalt, Germany"
    },
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          header(),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(fixPadding * 2.0, fixPadding,
                  fixPadding * 2.0, fixPadding * 2.0),
              children: [
                shippingAddressListContent(),
                heightSpace,
                addNewAddressBox()
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: nextButton(context),
    );
  }

  nextButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/paymentMethod');
        },
        child: Container(
          margin: const EdgeInsets.all(fixPadding * 2.0),
          padding: const EdgeInsets.symmetric(
              horizontal: fixPadding * 2.0, vertical: fixPadding * 1.5),
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: blackColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: const Text(
            "Next",
            style: medium19White,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  addNewAddressBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: fixPadding * 4.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/addAddress');
        },
        child: DottedBorder(
          color: greyC4Color,
          padding: const EdgeInsets.all(0.5),
          dashPattern: const [4, 5],
          borderType: BorderType.RRect,
          radius: const Radius.circular(10.0),
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: fixPadding * 2.0, vertical: fixPadding * 2.5),
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.add,
                  color: greyC4Color,
                  size: 22.0,
                ),
                height5Space,
                Text(
                  "Add New Address",
                  style: regular16GreyC4,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  shippingAddressListContent() {
    return ColumnBuilder(
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: Container(
              width: double.maxFinite,
              padding: const EdgeInsets.symmetric(
                  horizontal: fixPadding * 1.2, vertical: fixPadding),
              margin: const EdgeInsets.symmetric(vertical: fixPadding),
              decoration: BoxDecoration(
                border: Border.all(
                    color: selectedIndex == index ? blackColor : borderColor),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    addressList[index]['title'].toString(),
                    style: medium18Black,
                  ),
                  height5Space,
                  Text(
                    "${addressList[index]['name']} |${addressList[index]['number']}",
                    style: regular15Grey,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    addressList[index]['address'].toString(),
                    style: regular15Grey,
                  )
                ],
              ),
            ),
          );
        },
        itemCount: addressList.length);
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
          "Select Shipping Address",
          style: semibold20Black,
        ),
      ),
    );
  }
}

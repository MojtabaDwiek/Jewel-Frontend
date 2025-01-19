import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:iconify_flutter_plus/icons/uil.dart';
import 'package:pn_fl_jewellery_empire/theme/theme.dart';
import 'package:pn_fl_jewellery_empire/widget/column_builder.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final cartItemList = [
    {
      "image": "assets/home/Jewelry-1.png",
      "name": "Silver Plated Ring",
      "size": "48",
      "item": 2,
      "price": 120.00
    },
    {
      "image": "assets/home/Jewelry-10.png",
      "name": "Silver Grace Ring",
      "size": "46",
      "item": 1,
      "price": 125.25
    },
    {
      "image": "assets/home/Jewelry-3.png",
      "name": "Diamond Earrings",
      "size": "M",
      "item": 1,
      "price": 149.50
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          header(),
          Expanded(
            child: cartItemList.isEmpty
                ? emptyListContent()
                : ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(fixPadding * 2.0,
                        fixPadding, fixPadding * 2.0, fixPadding * 2.0),
                    children: [
                      cartItemListContent(),
                      heightSpace,
                      heightSpace,
                      priceInfo(),
                      heightSpace,
                      heightSpace,
                      proceedToCheckout(),
                    ],
                  ),
          )
        ],
      ),
    );
  }

  emptyListContent() {
    return Center(
      child: ListView(
        padding: const EdgeInsets.all(fixPadding * 2.0),
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        children: const [
          Iconify(
            Ph.handbag,
            size: 26.0,
            color: greyColor,
          ),
          heightSpace,
          Text(
            "Cart is Empty",
            style: medium18Grey,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  proceedToCheckout() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/selectAddress');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: fixPadding * 2.0, vertical: fixPadding * 1.5),
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: blackColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        alignment: Alignment.center,
        child: const Text(
          "Proceed to Checkout",
          style: medium19White,
        ),
      ),
    );
  }

  priceInfo() {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(fixPadding),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Sub Total",
                    style: regular16Black,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                widthSpace,
                Text(
                  "\$394.75",
                  style: regular16Black,
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(fixPadding),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Delivery",
                    style: regular16Black,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                widthSpace,
                Text(
                  "Free",
                  style: regular16Black,
                )
              ],
            ),
          ),
          DottedBorder(
            dashPattern: const [5, 9],
            color: borderColor,
            padding: EdgeInsets.zero,
            child: Container(
              width: double.maxFinite,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(fixPadding),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Total",
                    style: semibold16Black,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                widthSpace,
                Text(
                  "\$394.75",
                  style: semibold16Black,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  cartItemListContent() {
    return ColumnBuilder(
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(fixPadding),
          margin: const EdgeInsets.symmetric(vertical: fixPadding),
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(fixPadding),
                clipBehavior: Clip.hardEdge,
                height: 80.0,
                width: 85.0,
                decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: blackColor.withOpacity(0.1),
                        blurRadius: 20.0,
                        offset: const Offset(0, 10),
                      )
                    ]),
                alignment: Alignment.center,
                child: Image.asset(
                  cartItemList[index]['image'].toString(),
                  fit: BoxFit.cover,
                ),
              ),
              widthSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cartItemList[index]['name'].toString(),
                                style: regular16Black,
                                overflow: TextOverflow.ellipsis,
                              ),
                              heightBox(3.0),
                              Text(
                                "Size: ${cartItemList[index]['size']}",
                                style: regular14Grey,
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        ),
                        Text(
                          "\$${(cartItemList[index]['price'] as double).toStringAsFixed(2)}",
                          style: regular16Black,
                        ),
                      ],
                    ),
                    heightSpace,
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              addRemoveButton(Icons.remove, () {
                                if ((cartItemList[index]['item'] as int) > 1) {
                                  setState(() {
                                    cartItemList[index]['item'] =
                                        (cartItemList[index]['item'] as int) -
                                            1;
                                  });
                                }
                              }),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: fixPadding * 1.5),
                                child: Text(
                                  cartItemList[index]['item'].toString(),
                                  style: bold14Black,
                                ),
                              ),
                              addRemoveButton(Icons.add, () {
                                setState(() {
                                  cartItemList[index]['item'] =
                                      (cartItemList[index]['item'] as int) + 1;
                                });
                              }),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              cartItemList.removeAt(index);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: blackColor,
                                duration: Duration(milliseconds: 1500),
                                behavior: SnackBarBehavior.floating,
                                content: Text(
                                  "Removed from shopping cart",
                                  style: medium16White,
                                ),
                              ),
                            );
                          },
                          child: const Iconify(
                            Uil.trash_alt,
                            size: 22.0,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
      itemCount: cartItemList.length,
    );
  }

  addRemoveButton(IconData icon, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 26.0,
        width: 26.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(color: borderColor)),
        alignment: Alignment.center,
        child: Icon(
          icon,
          color: blackColor,
          size: 18.0,
        ),
      ),
    );
  }

  header() {
    return Container(
      padding: const EdgeInsets.only(top: fixPadding),
      decoration: headerBoxDecoration,
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        centerTitle: false,
        titleSpacing: fixPadding * 2.0,
        elevation: 0.0,
        title: const Text(
          "Shopping Cart",
          style: semibold20Black,
        ),
      ),
    );
  }
}

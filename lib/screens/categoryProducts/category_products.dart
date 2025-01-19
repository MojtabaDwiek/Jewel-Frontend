import 'package:flutter/material.dart';
import 'package:pn_fl_jewellery_empire/theme/theme.dart';

class CategoryProductsScreen extends StatefulWidget {
  const CategoryProductsScreen({super.key});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  final categoryProductList = [
    {
      "image": "assets/home/Jewelry-1.png",
      "name": "Silver Plated Ring",
      "price": 100.00
    },
    {
      "image": "assets/home/Jewelry-6.png",
      "name": "Diamond Ring",
      "price": 119.50
    },
    {
      "image": "assets/home/Jewelry-12.png",
      "name": "Silver Ring",
      "price": 120.50
    },
    {
      "image": "assets/home/Jewelry-10.png",
      "name": "Silver Grace Ring",
      "price": 125.25
    },
    {
      "image": "assets/home/Jewelry-11.png",
      "name": "Silver Ring",
      "price": 124.50
    },
    {
      "image": "assets/home/Jewelry-13.png",
      "name": "Platinum Plated Ring",
      "price": 149.50
    },
    {
      "image": "assets/home/Jewelry-14.png",
      "name": "Steel Metal Ring",
      "price": 120.50
    },
    {
      "image": "assets/home/Jewelry-1.png",
      "name": "Silver Plated Ring",
      "price": 100.00
    },
    {
      "image": "assets/home/Jewelry-6.png",
      "name": "Diamond Ring",
      "price": 119.50
    },
    {
      "image": "assets/home/Jewelry-11.png",
      "name": "Silver Ring",
      "price": 124.50
    },
    {
      "image": "assets/home/Jewelry-6.png",
      "name": "Diamond Ring",
      "price": 119.50
    },
    {
      "image": "assets/home/Jewelry-11.png",
      "name": "Silver Ring",
      "price": 124.50
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          header(context),
          productListContent(),
        ],
      ),
    );
  }

  productListContent() {
    return Expanded(
        child: GridView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(fixPadding * 2.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: fixPadding * 2.0,
        crossAxisSpacing: fixPadding * 2.0,
        childAspectRatio: 0.8,
      ),
      itemCount: categoryProductList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/productDetail');
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: fixPadding * 1.9),
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(
                    child: Image.asset(
                      categoryProductList[index]['image'].toString(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: fixPadding * 1.5),
                  width: double.maxFinite,
                  height: 1.0,
                  color: borderColor,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: fixPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        categoryProductList[index]['name'].toString(),
                        style: regular16Black,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '\$${(categoryProductList[index]['price'] as double).toStringAsFixed(2)}',
                        style: semibold16Black,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    ));
  }

  header(BuildContext context) {
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
          "Rings",
          style: semibold20Black,
        ),
      ),
    );
  }
}

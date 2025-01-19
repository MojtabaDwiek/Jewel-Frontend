import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bx.dart';
import 'package:pn_fl_jewellery_empire/screens/bottom_bar.dart';
import 'package:pn_fl_jewellery_empire/theme/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final posterList = [
    {
      "image": "assets/home/poster-image.png",
      "title": "Buy Your Elegant\nJewelry",
    },
    {
      "image": "assets/home/poster-image.png",
      "title": "Buy Your Elegant\nJewelry",
    },
  ];

  final categoryList = [
    {"image": "assets/home/Jewelry-1.png", "title": "Rings"},
    {"image": "assets/home/Jewelry-2.png", "title": "Bracelets"},
    {"image": "assets/home/Jewelry-3.png", "title": "Earrings "},
    {"image": "assets/home/Jewelry-4.png", "title": "Necklace"},
    {"image": "assets/home/Jewelry-1.png", "title": "Rings"},
    {"image": "assets/home/Jewelry-2.png", "title": "Bracelets"},
    {"image": "assets/home/Jewelry-3.png", "title": "Earrings "},
    {"image": "assets/home/Jewelry-4.png", "title": "Necklace"},
  ];

  final recommendedList = [
    {
      "image": "assets/home/Jewelry-1.png",
      "name": "Silver Plated Ring",
      "price": "100.00"
    },
    {
      "image": "assets/home/Jewelry-5.png",
      "name": "Diamond Earrings",
      "price": "149.50"
    },
    {
      "image": "assets/home/Jewelry-6.png",
      "name": "Sunshine Ring",
      "price": "299.50"
    },
    {
      "image": "assets/home/Jewelry-7.png",
      "name": "Diamond Bracelet",
      "price": "249.50"
    },
    {
      "image": "assets/home/Jewelry-8.png",
      "name": "Silver Earrings",
      "price": "120.00"
    },
    {
      "image": "assets/home/Jewelry-9.png",
      "name": "Necklace",
      "price": "150.50"
    },
  ];

  final popularList = [
    {
      "image": "assets/home/Jewelry-6.png",
      "name": "Silver Ring",
      "price": "120.00"
    },
    {
      "image": "assets/home/Jewelry-4.png",
      "name": "Necklace",
      "price": "150.50"
    },
    {
      "image": "assets/home/Jewelry-7.png",
      "name": "Bracelet",
      "price": "199.50"
    },
    {
      "image": "assets/home/Jewelry-10.png",
      "name": "Silver Ring",
      "price": "100.00"
    },
    {
      "image": "assets/home/Jewelry-3.png",
      "name": "Silver Earrings",
      "price": "120.00"
    },
    {
      "image": "assets/home/Jewelry-9.png",
      "name": "Necklace",
      "price": "150.50"
    },
    {
      "image": "assets/home/Jewelry-2.png",
      "name": "Bracelet",
      "price": "199.50"
    },
    {
      "image": "assets/home/Jewelry-11.png",
      "name": "Silver Ring",
      "price": "100.00"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header(),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(top: fixPadding * 2.0),
              children: [
                posters(),
                heightSpace,
                heightSpace,
                heightSpace,
                categoryListContent(),
                heightSpace,
                heightSpace,
                recommendedForYou(),
                heightSpace,
                heightSpace,
                popularListContent(),
              ],
            ),
          )
        ],
      ),
    );
  }

  popularListContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title("Popular"),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
              fixPadding * 2.0, fixPadding, fixPadding * 2.0, fixPadding * 2.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: fixPadding * 2.0,
            crossAxisSpacing: fixPadding * 2.0,
            childAspectRatio: 0.8,
          ),
          itemCount: popularList.length,
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
                          popularList[index]['image'].toString(),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: fixPadding * 1.5),
                      width: double.maxFinite,
                      height: 1.0,
                      color: borderColor,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: fixPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            popularList[index]['name'].toString(),
                            style: regular16Black,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '\$${popularList[index]['price']}',
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
        )
      ],
    );
  }

  recommendedForYou() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title("Recommended for You"),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(fixPadding),
          child: Row(
            children: List.generate(
              recommendedList.length,
              (index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/productDetail');
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: fixPadding * 1.9),
                    width: 158.0,
                    margin: const EdgeInsets.symmetric(horizontal: fixPadding),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.asset(
                            recommendedList[index]['image'].toString(),
                            height: 95.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: fixPadding * 1.5),
                          width: double.maxFinite,
                          height: 1.0,
                          color: borderColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: fixPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recommendedList[index]['name'].toString(),
                                style: regular16Black,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '\$${recommendedList[index]['price']}',
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
            ),
          ),
        )
      ],
    );
  }

  categoryListContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title("Category"),
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(fixPadding),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              categoryList.length,
              (index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/categoryProducts');
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: fixPadding * 1.5),
                    width: 110.0,
                    margin: const EdgeInsets.symmetric(horizontal: fixPadding),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          categoryList[index]['image'].toString(),
                          fit: BoxFit.cover,
                          height: 83.0,
                        ),
                        heightSpace,
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: fixPadding),
                          child: Text(
                            categoryList[index]['title'].toString(),
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
          ),
        )
      ],
    );
  }

  title(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
      child: Text(
        title,
        style: semibold18Black,
      ),
    );
  }

  posters() {
    return CarouselSlider(
      items: List.generate(
        posterList.length,
        (index) {
          return Container(
            width: double.maxFinite,
            clipBehavior: Clip.hardEdge,
            margin: const EdgeInsets.symmetric(horizontal: fixPadding * 0.5),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: AssetImage(
                  posterList[index]['image'].toString(),
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: whiteColor.withOpacity(0.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    posterList[index]['title'].toString(),
                    style: bold22White,
                    overflow: TextOverflow.ellipsis,
                  ),
                  heightSpace,
                  heightSpace,
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: fixPadding * 2.0,
                        vertical: fixPadding * 0.4),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: const Text(
                      "Get Now",
                      style: medium15Black,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
      options: CarouselOptions(
        height: 155.0,
        viewportFraction: 0.9,
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
        elevation: 0.0,
        titleSpacing: 0.0,
        centerTitle: true,
        leading: const IconButton(
          onPressed: null,
          icon: Icon(
            Icons.sort,
            color: blackColor,
          ),
        ),
        title: const Text(
          "Featured",
          style: semibold20Black,
        ),
        actions: [
          IconButton(
            padding: const EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BottomBar(index: 1),
                ),
              );
            },
            icon: const Iconify(
              Bx.search,
              size: 22.0,
            ),
          ),
        ],
      ),
    );
  }
}

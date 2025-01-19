import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bx.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:pn_fl_jewellery_empire/theme/theme.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final popularSearchList = [
    "Bracelets",
    "Charms",
    "Rings",
    "Body Jewelry",
    "Anklets",
    "Necklace"
  ];

  final recentSearchList = ["Anklets", "Bracelets"];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        left: false,
        right: false,
        child: Column(
          children: [
            height5Space,
            searchField(),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(top: fixPadding * 2.0),
                children: [
                  popularSearches(),
                  recentSearch(),
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  recommendedForYou(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  recommendedForYou() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
          child: Text(
            "Recommended for You",
            style: semibold18Black,
          ),
        ),
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

  recentSearch() {
    return recentSearchList.isEmpty
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                heightSpace,
                heightSpace,
                heightSpace,
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "RECENT SEARCHES",
                        style: medium14Primary,
                      ),
                    ),
                    widthSpace,
                    InkWell(
                      onTap: () {
                        recentSearchList.clear();
                        setState(() {});
                      },
                      child: const Text(
                        "Clear all",
                        style: medium14Grey,
                      ),
                    )
                  ],
                ),
                heightSpace,
                Wrap(
                  spacing: fixPadding,
                  runSpacing: fixPadding,
                  children: List.generate(
                    recentSearchList.length,
                    (index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: fixPadding * 2.0,
                            vertical: fixPadding * 0.6),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(
                              color: borderColor,
                              strokeAlign: BorderSide.strokeAlignOutside),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              recentSearchList[index].toString(),
                              style: regular15Black,
                            ),
                            width5Space,
                            InkWell(
                              onTap: () {
                                setState(() {
                                  recentSearchList.removeAt(index);
                                });
                              },
                              child: const Icon(
                                Icons.close,
                                color: blackColor,
                                size: 16.0,
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          );
  }

  popularSearches() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "POPULAR SEARCHES",
            style: medium14Primary,
          ),
          heightSpace,
          Wrap(
            spacing: fixPadding,
            runSpacing: fixPadding,
            children: List.generate(
              popularSearchList.length,
              (index) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: fixPadding * 2.0, vertical: fixPadding * 0.6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                        color: borderColor,
                        strokeAlign: BorderSide.strokeAlignOutside),
                  ),
                  child: Text(
                    popularSearchList[index].toString(),
                    style: regular15Black,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  searchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: fixPadding * 2.0, vertical: fixPadding),
      child: TextField(
        cursorColor: primaryColor,
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: greyC4Color),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: blackColor),
          ),
          hintText: "Search",
          hintStyle: regular16Grey,
          prefixIconConstraints:
              const BoxConstraints(minWidth: 35.0, maxWidth: 35.0),
          prefixIcon: const Align(
            alignment: Alignment.centerLeft,
            child: Iconify(
              Bx.search,
              size: 20.0,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: fixPadding),
          suffixIcon: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/searchFilter');
            },
            icon: const Iconify(
              Ph.sliders,
              size: 22.0,
            ),
          ),
        ),
      ),
    );
  }
}

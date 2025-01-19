import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:pn_fl_jewellery_empire/theme/theme.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  final favouriteList = [
    {
      "image": "assets/home/Jewelry-1.png",
      "name": "Silver Plated Ring",
      "price": "100.00"
    },
    {
      "image": "assets/home/Jewelry-6.png",
      "name": "Silver Plated Ring",
      "price": "100.00"
    },
    {
      "image": "assets/home/Jewelry-12.png",
      "name": "Silver Plated Ring",
      "price": "100.00"
    },
    {
      "image": "assets/home/Jewelry-10.png",
      "name": "Silver Plated Ring",
      "price": "100.00"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          header(),
          Expanded(
            child: favouriteList.isEmpty
                ? emptyListContent()
                : favouriteListContent(),
          ),
        ],
      ),
    );
  }

  emptyListContent() {
    return Center(
      child: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(fixPadding * 2.0),
        children: const [
          Iconify(
            Ph.heart_straight,
            size: 26.0,
            color: greyColor,
          ),
          heightSpace,
          Text(
            "Nothing in Favourite",
            style: medium18Grey,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  favouriteListContent() {
    return GridView.builder(
      padding: const EdgeInsets.all(fixPadding * 2.0),
      itemCount: favouriteList.length,
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: fixPadding * 2.0,
        crossAxisSpacing: fixPadding * 2.0,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/productDetail');
          },
          child: Container(
            padding: const EdgeInsets.only(bottom: fixPadding * 1.9),
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
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: fixPadding * 1.9),
                        child: Center(
                          child: Image.asset(
                            favouriteList[index]['image'].toString(),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(fixPadding),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                favouriteList.removeAt(index);
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(milliseconds: 1500),
                                  backgroundColor: blackColor,
                                  content: Text(
                                    "Removed from favourite",
                                    style: medium16White,
                                  ),
                                ),
                              );
                            },
                            child: const Iconify(
                              Ph.heart_straight_fill,
                              size: 20.0,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  height: 1.0,
                  color: borderColor,
                  margin:
                      const EdgeInsets.symmetric(vertical: fixPadding * 1.5),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: fixPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        favouriteList[index]['name'].toString(),
                        style: regular16Black,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "\$${favouriteList[index]['price']}",
                        style: semibold16Black,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
          "Favourite",
          style: semibold20Black,
        ),
      ),
    );
  }
}

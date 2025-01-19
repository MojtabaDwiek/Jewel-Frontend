import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:pn_fl_jewellery_empire/screens/bottom_bar.dart';
import 'package:pn_fl_jewellery_empire/theme/theme.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int currentImageIndex = 0;

  bool isFavourite = false;

  final colorList = const [
    Color(0xFFF7D000),
    Color(0xFFDCDCDE),
  ];

  int selectedColor = 1;

  final sizeList = ["46", "48", "50", "52", "56", "58", "60"];
  int selectedSize = 1;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          header(size, context),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                heightSpace,
                heightSpace,
                jewelryInfo(),
                heightSpace,
                heightSpace,
                colorsAndReviewInfo(),
                heightSpace,
                heightSpace,
                sizeInfo(),
                heightSpace,
                heightSpace,
                description(),
                heightSpace,
                heightSpace,
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: addToCartButton(),
    );
  }

  addToCartButton() {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BottomBar(index: 2),
            ),
          );
        },
        child: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(
              vertical: fixPadding * 1.5, horizontal: fixPadding * 2.0),
          margin: const EdgeInsets.all(fixPadding * 2.0),
          decoration: BoxDecoration(
            color: blackColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: const Text(
            "Add to Cart",
            style: medium19White,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  description() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Description",
            style: medium16Black,
          ),
          height5Space,
          Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Volutpat eu tortor quis nunc lectus faucibus sit vitae auctor faucibus. Consectetur nec amet varius dui dui non et ante.",
            style: regular15Grey,
          ),
          height5Space,
          Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Volutpat eu tortor quis nunc lectus faucibus sit vitae auctor faucibus. ",
            style: regular15Grey,
          ),
        ],
      ),
    );
  }

  sizeInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
          child: Text(
            "Size",
            style: medium16Black,
          ),
        ),
        heightSpace,
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: fixPadding * 1.25),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              sizeList.length,
              (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedSize = index;
                    });
                  },
                  child: Container(
                    height: 34.0,
                    width: 34.0,
                    margin: const EdgeInsets.symmetric(
                        horizontal: fixPadding * 0.75),
                    decoration: BoxDecoration(
                      color: selectedSize == index ? primaryColor : whiteColor,
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(color: borderColor),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      sizeList[index].toString(),
                      style: selectedSize == index
                          ? regular15White
                          : regular15Grey,
                      overflow: TextOverflow.ellipsis,
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

  colorsAndReviewInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
      child: Row(
        children: [
          const Text(
            "Color",
            style: medium16Black,
          ),
          widthSpace,
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: fixPadding),
              child: Row(
                children: List.generate(
                  colorList.length,
                  (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedColor = index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: fixPadding * 0.75),
                        height: 24.0,
                        width: 24.0,
                        decoration: BoxDecoration(
                          color: colorList[index],
                          shape: BoxShape.circle,
                          boxShadow: selectedColor == index
                              ? [
                                  BoxShadow(
                                    color: blackColor.withOpacity(0.15),
                                    blurRadius: 4.0,
                                    offset: const Offset(0, 2),
                                  ),
                                  BoxShadow(
                                    color: blackColor.withOpacity(0.15),
                                    blurRadius: 2.0,
                                    offset: const Offset(0, -2),
                                  ),
                                ]
                              : null,
                          border: Border.all(
                              color: whiteColor,
                              strokeAlign: BorderSide.strokeAlignOutside),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          widthSpace,
          const Icon(
            CupertinoIcons.star_fill,
            color: primaryColor,
            size: 18.0,
          ),
          width5Space,
          const Text(
            "4.2 (350 reviews)",
            style: medium16Black,
          )
        ],
      ),
    );
  }

  jewelryInfo() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Attract Ring Round Silver Plated",
                  style: medium18Black,
                ),
                Text(
                  "GIVA RINGS",
                  style: medium13Grey,
                )
              ],
            ),
          ),
          widthSpace,
          Text(
            "\$120.00",
            style: bold18Primary,
          )
        ],
      ),
    );
  }

  header(Size size, BuildContext context) {
    return SliverAppBar(
      expandedHeight: size.height * 0.3,
      backgroundColor: whiteColor,
      shape: const RoundedRectangleBorder(
        side: BorderSide(
          color: borderColor,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
      ),
      toolbarHeight: 70.0,
      automaticallyImplyLeading: false,
      centerTitle: false,
      elevation: 0.0,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.west,
          color: blackColor,
        ),
      ),
      pinned: true,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: fixPadding * 0.5),
          child: Row(
            children: [
              favouriteIconButton(context),
              const IconButton(
                padding: EdgeInsets.symmetric(horizontal: fixPadding),
                onPressed: null,
                icon: Iconify(
                  Ph.share_network,
                  size: 21.0,
                  color: blackColor,
                ),
              ),
            ],
          ),
        )
      ],
      flexibleSpace: productImages(size),
    );
  }

  productImages(Size size) {
    return FlexibleSpaceBar(
      collapseMode: CollapseMode.pin,
      background: Stack(
        children: [
          Center(
            child: CarouselSlider(
              items: List.generate(
                4,
                (index) {
                  return Image.asset(
                    "assets/home/Jewelry-14.png",
                    fit: BoxFit.cover,
                  );
                },
              ),
              options: CarouselOptions(
                viewportFraction: 1.0,
                height: size.height * 0.3,
                initialPage: currentImageIndex,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentImageIndex = index;
                  });
                },
              ),
            ),
          ),
          Positioned(
            bottom: 15.0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                (index) {
                  return Container(
                    height: 10.0,
                    width: 10.0,
                    margin:
                        const EdgeInsets.symmetric(horizontal: fixPadding / 4),
                    decoration: BoxDecoration(
                      color: currentImageIndex == index ? greyC4Color : f0Color,
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  favouriteIconButton(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.symmetric(horizontal: fixPadding),
      onPressed: () {
        setState(() {
          isFavourite = !isFavourite;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: blackColor,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(milliseconds: 1500),
            content: Text(
              isFavourite ? "Added to favourite" : "Removed from favourite",
              style: medium16White,
            ),
          ),
        );
      },
      icon: Iconify(
        isFavourite ? Ph.heart_straight_fill : Ph.heart_straight,
        size: 22.0,
        color: blackColor,
      ),
    );
  }
}

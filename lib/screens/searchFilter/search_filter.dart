import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:pn_fl_jewellery_empire/theme/theme.dart';

class SearchFilterScreen extends StatefulWidget {
  const SearchFilterScreen({super.key});

  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  final featureList = [
    "Below 25mm",
    "Between 25-35mm",
    "35mm and above",
    "Plugs",
    "Tunnels"
  ];
  int selectedFeature = 2;

  final brandList = [
    {"name": "Sukkhi", "isSelected": false},
    {"name": "YouBella", "isSelected": false},
    {"name": "Peora", "isSelected": true},
    {"name": "Zaveri Pearls", "isSelected": false},
    {"name": "Zeneme", "isSelected": false},
    {"name": "Karatcart", "isSelected": false},
    {"name": "Mansiyaorange", "isSelected": false},
    {"name": "Lucky Jewelry", "isSelected": false}
  ];

  final materialList = [
    {"name": "Brass", "isSelected": false},
    {"name": "Yellow Gold", "isSelected": false},
    {"name": "Rose Gold", "isSelected": true},
    {"name": "Silver", "isSelected": false},
    {"name": "Platinum", "isSelected": false},
    {"name": "White Gold", "isSelected": false},
  ];

  double lValue = 0;
  double uValue = 200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          header(context),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(fixPadding * 2.0),
              children: [
                features(),
                heightSpace,
                heightSpace,
                heightSpace,
                brand(),
                heightSpace,
                heightSpace,
                heightSpace,
                material(),
                heightSpace,
                heightSpace,
                heightSpace,
                priceRange(),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: applyButton(context),
    );
  }

  applyButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
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
            "Apply",
            style: medium19White,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  priceRange() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title("PRICE RANGE"),
        FlutterSlider(
          values: [lValue, uValue],
          rangeSlider: true,
          max: 500,
          min: 0,
          handlerWidth: 20.0,
          handlerHeight: 20.0,
          trackBar: FlutterSliderTrackBar(
            activeTrackBarHeight: 6.0,
            inactiveTrackBarHeight: 6.0,
            activeTrackBar: const BoxDecoration(color: blackColor),
            inactiveTrackBar: BoxDecoration(
              color: borderColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          rightHandler: FlutterSliderHandler(
            child: Container(
              height: 20.0,
              width: 20.0,
              decoration: BoxDecoration(
                color: blackColor,
                shape: BoxShape.circle,
                border: Border.all(color: whiteColor, width: 1.5),
              ),
            ),
          ),
          handler: FlutterSliderHandler(
            child: Container(
              height: 20.0,
              width: 20.0,
              decoration: BoxDecoration(
                color: blackColor,
                shape: BoxShape.circle,
                border: Border.all(color: whiteColor, width: 1.5),
              ),
            ),
          ),
          tooltip: FlutterSliderTooltip(
            alwaysShowTooltip: true,
            positionOffset: FlutterSliderTooltipPositionOffset(top: 35),
            custom: (value) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Text(
                  "\$$value",
                  style: regular15Grey,
                ),
              );
            },
          ),
          onDragging: (handlerIndex, lowerValue, upperValue) {
            lValue = lowerValue;
            uValue = upperValue;
            setState(() {});
          },
        )
      ],
    );
  }

  material() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title("MATERIAL"),
        heightSpace,
        Wrap(
          spacing: fixPadding,
          runSpacing: fixPadding,
          children: List.generate(
            materialList.length,
            (index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    materialList[index]['isSelected'] =
                        !(materialList[index]['isSelected'] as bool);
                  });
                },
                child: materialList[index]['isSelected'] == true
                    ? selectedWidget(materialList[index]['name'].toString())
                    : unselectedWidget(materialList[index]['name'].toString()),
              );
            },
          ),
        )
      ],
    );
  }

  brand() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title("BRAND"),
        heightSpace,
        Wrap(
          spacing: fixPadding,
          runSpacing: fixPadding,
          children: List.generate(
            brandList.length,
            (index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    brandList[index]['isSelected'] =
                        !(brandList[index]['isSelected'] as bool);
                  });
                },
                child: brandList[index]['isSelected'] == true
                    ? selectedWidget(brandList[index]['name'].toString())
                    : unselectedWidget(brandList[index]['name'].toString()),
              );
            },
          ),
        )
      ],
    );
  }

  features() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title("FEATURES"),
        heightSpace,
        Wrap(
          spacing: fixPadding,
          runSpacing: fixPadding,
          children: List.generate(
            featureList.length,
            (index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    selectedFeature = index;
                  });
                },
                child: selectedFeature == index
                    ? selectedWidget(featureList[index].toString())
                    : unselectedWidget(featureList[index].toString()),
              );
            },
          ),
        )
      ],
    );
  }

  unselectedWidget(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: fixPadding * 2.0, vertical: fixPadding * 0.6),
      decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(
              color: borderColor, strokeAlign: BorderSide.strokeAlignOutside)),
      child: Text(
        title,
        style: regular15Black,
      ),
    );
  }

  selectedWidget(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: fixPadding * 2.0, vertical: fixPadding * 0.6),
      decoration: BoxDecoration(
        color: blackColor,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Text(
        title,
        style: regular15White,
      ),
    );
  }

  title(String title) {
    return Text(
      title,
      style: medium14Primary,
    );
  }

  header(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: fixPadding),
      decoration: headerBoxDecoration,
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        centerTitle: false,
        titleSpacing: fixPadding * 1.5,
        elevation: 0.0,
        leading: IconButton(
          padding: const EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.west),
        ),
        title: const Text(
          "Filters",
          style: semibold20Black,
        ),
      ),
    );
  }
}

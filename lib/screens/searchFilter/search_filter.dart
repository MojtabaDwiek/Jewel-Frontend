import 'package:flutter/material.dart';
import 'package:pn_fl_jewellery_empire/theme/theme.dart';

class SearchFilterScreen extends StatefulWidget {
  const SearchFilterScreen({super.key});

  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen>
    with SingleTickerProviderStateMixin {
  final sizeList = ["46", "48", "50", "52", "56", "58", "60"];
  final lengthList = ["1", "18", "20", "22", "24", "26", "28"];
  final weightList = ["1", "20", "30", "40", "50", "60", "70"];

  List<String> selectedSizes = [];
  List<String> selectedLengths = [];
  List<String> selectedWeights = [];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          header(context),
          TabBar(
            controller: _tabController,
            labelColor: blackColor,
            unselectedLabelColor: greyColor,
            indicatorColor: blackColor,
            tabs: const [
              Tab(text: "Size"),
              Tab(text: "Length"),
              Tab(text: "Weight"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                sizeFilter(),
                lengthFilter(),
                weightFilter(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: applyButton(context),
    );
  }

  Widget sizeFilter() {
    return ListView(
      padding: const EdgeInsets.all(fixPadding * 2.0),
      children: [
        Wrap(
          spacing: fixPadding,
          runSpacing: fixPadding,
          children: List.generate(
            sizeList.length,
            (index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    if (selectedSizes.contains(sizeList[index])) {
                      selectedSizes.remove(sizeList[index]);
                    } else {
                      selectedSizes.add(sizeList[index]);
                    }
                  });
                },
                child: selectedSizes.contains(sizeList[index])
                    ? selectedWidget(sizeList[index])
                    : unselectedWidget(sizeList[index]),
              );
            },
          ),
        )
      ],
    );
  }

  Widget lengthFilter() {
    return ListView(
      padding: const EdgeInsets.all(fixPadding * 2.0),
      children: [
        Wrap(
          spacing: fixPadding,
          runSpacing: fixPadding,
          children: List.generate(
            lengthList.length,
            (index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    if (selectedLengths.contains(lengthList[index])) {
                      selectedLengths.remove(lengthList[index]);
                    } else {
                      selectedLengths.add(lengthList[index]);
                    }
                  });
                },
                child: selectedLengths.contains(lengthList[index])
                    ? selectedWidget(lengthList[index])
                    : unselectedWidget(lengthList[index]),
              );
            },
          ),
        )
      ],
    );
  }

  Widget weightFilter() {
    return ListView(
      padding: const EdgeInsets.all(fixPadding * 2.0),
      children: [
        Wrap(
          spacing: fixPadding,
          runSpacing: fixPadding,
          children: List.generate(
            weightList.length,
            (index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    if (selectedWeights.contains(weightList[index])) {
                      selectedWeights.remove(weightList[index]);
                    } else {
                      selectedWeights.add(weightList[index]);
                    }
                  });
                },
                child: selectedWeights.contains(weightList[index])
                    ? selectedWidget(weightList[index])
                    : unselectedWidget(weightList[index]),
              );
            },
          ),
        )
      ],
    );
  }

  applyButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: GestureDetector(
        onTap: () {
          // Pass the selected filters back to the SearchScreen
          Navigator.pop(context, {
            'sizes': selectedSizes,
            'lengths': selectedLengths,
            'weights': selectedWeights,
          });
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
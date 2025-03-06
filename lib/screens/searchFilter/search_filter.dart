import 'package:flutter/material.dart';
import 'package:pn_fl_jewellery_empire/theme/theme.dart';

class SearchFilterScreen extends StatefulWidget {
  const SearchFilterScreen({super.key});

  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen>
    with SingleTickerProviderStateMixin {
  // Define carat and weight options
  final caratList = ["18", "21"];
  final weightList = ["200", "400", "600", "800", "1000", "1200", "1400"];

  List<String> selectedCarats = [];
  List<String> selectedWeights = [];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Two tabs: one for carat and one for weight
    _tabController = TabController(length: 2, vsync: this);
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
              Tab(text: "Carat"),
              Tab(text: "Weight"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                caratFilter(), // Carat filter
                weightFilter(), // Weight filter
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: applyButton(context),
    );
  }

  // Carat filter widget
  Widget caratFilter() {
    return ListView(
      padding: const EdgeInsets.all(fixPadding * 2.0),
      children: [
        Wrap(
          spacing: fixPadding,
          runSpacing: fixPadding,
          children: List.generate(
            caratList.length,
            (index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    if (selectedCarats.contains(caratList[index])) {
                      selectedCarats.remove(caratList[index]);
                    } else {
                      selectedCarats.add(caratList[index]);
                    }
                  });
                },
                child: selectedCarats.contains(caratList[index])
                    ? selectedWidget(caratList[index])
                    : unselectedWidget(caratList[index]),
              );
            },
          ),
        )
      ],
    );
  }

  // Weight filter widget
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
                  final selectedWeight = weightList[index];
                  // Convert weightList to integers for comparison
                  final selectedWeightValue = int.parse(selectedWeight);

                  // Clear the selectedWeights list
                  selectedWeights.clear();

                  // Add all weights less than or equal to the selected weight
                  for (final weight in weightList) {
                    final weightValue = int.parse(weight);
                    if (weightValue <= selectedWeightValue) {
                      selectedWeights.add(weight);
                    }
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

  // Apply button
  Widget applyButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: GestureDetector(
        onTap: () {
          // Pass the selected carat and weight filters back to the SearchScreen
          Navigator.pop(context, {
            'carats': selectedCarats,
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

  // Unselected widget
  Widget unselectedWidget(String title) {
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

  // Selected widget
  Widget selectedWidget(String title) {
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

  // Header widget
  Widget header(BuildContext context) {
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
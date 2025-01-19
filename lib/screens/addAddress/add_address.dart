import 'package:flutter/material.dart';
import 'package:pn_fl_jewellery_empire/theme/theme.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final addressTypeList = ["Home", "Office", "Other"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          header(),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                  horizontal: fixPadding * 2.0, vertical: fixPadding * 2.8),
              children: [
                areaNameField(),
                heightBox(fixPadding * 2.8),
                completeAddressField(),
                heightBox(fixPadding * 2.8),
                contactNumberField(),
                heightBox(fixPadding * 2.8),
                addressTypeField(),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: addButton(context),
    );
  }

  addButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          width: double.maxFinite,
          margin: const EdgeInsets.only(
              left: fixPadding * 2.0,
              right: fixPadding * 2.0,
              bottom: fixPadding * 2.0),
          padding: const EdgeInsets.symmetric(
              vertical: fixPadding * 1.5, horizontal: fixPadding * 2.0),
          decoration: BoxDecoration(
            color: blackColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: const Text(
            "Add",
            style: medium19White,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  addressTypeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title("Address Type"),
        DropdownButtonFormField(
          dropdownColor: whiteColor,
          items: List.generate(
            addressTypeList.length,
            (index) {
              return DropdownMenuItem(
                value: addressTypeList[index],
                child: Text(
                  addressTypeList[index].toString(),
                  style: regular17Black.copyWith(fontFamily: 'Mukta'),
                ),
              );
            },
          ),
          onChanged: (value) {},
          style: regular17Black,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: blackColor,
          ),
          hint: Text(
            "Select Address Type",
            style: regular17Grey.copyWith(fontFamily: 'Mukta'),
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            enabledBorder: underlineInputBorder,
            focusedBorder: underlineInputBorder,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: fixPadding),
            // hintText: "Select Address Type",
            // hintStyle: regular17Grey,
          ),
        )
      ],
    );
  }

  contactNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title("Contact Number"),
        const TextField(
          cursorColor: primaryColor,
          style: regular17Black,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            border: InputBorder.none,
            enabledBorder: underlineInputBorder,
            focusedBorder: underlineInputBorder,
            hintText: "Enter Contact Number",
            hintStyle: regular17Grey,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: fixPadding),
          ),
        )
      ],
    );
  }

  completeAddressField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title("Complete Address"),
        const TextField(
          cursorColor: primaryColor,
          style: regular17Black,
          keyboardType: TextInputType.streetAddress,
          decoration: InputDecoration(
            border: InputBorder.none,
            enabledBorder: underlineInputBorder,
            focusedBorder: underlineInputBorder,
            hintText: "Enter Complete Address",
            hintStyle: regular17Grey,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: fixPadding),
          ),
        )
      ],
    );
  }

  areaNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title("Area Name"),
        const TextField(
          keyboardType: TextInputType.name,
          cursorColor: primaryColor,
          style: regular17Black,
          decoration: InputDecoration(
            border: InputBorder.none,
            enabledBorder: underlineInputBorder,
            focusedBorder: underlineInputBorder,
            hintText: "Enter Area Name",
            hintStyle: regular17Grey,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: fixPadding),
          ),
        )
      ],
    );
  }

  title(String title) {
    return Text(
      title,
      style: regular15Grey,
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
        centerTitle: false,
        titleSpacing: fixPadding * 1.5,
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
        title: const Text(
          "Add New Address",
          style: semibold20Black,
        ),
      ),
    );
  }
}

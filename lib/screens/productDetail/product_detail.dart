import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart'; // For network images
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:pn_fl_jewellery_empire/screens/bottom_bar.dart';
import 'package:pn_fl_jewellery_empire/theme/theme.dart';
import 'package:pn_fl_jewellery_empire/services/api_service.dart'; // Import your API service

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int currentImageIndex = 0;
  bool isFavourite = false;
  final sizeList = ["46", "48", "50", "52", "56", "58", "60"];
  int selectedSize = 1;
  int selectedLength = 1; // Added for lengths functionality

  late int productId; // Change to int
  Map<String, dynamic>? productDetails;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null) {
      productId = args as int; // Ensure productId is treated as int
      print('Product ID: $productId'); // Debug statement
      _fetchProductDetails();
    } else {
      print('No product ID provided'); // Debug statement
    }
  }

  Future<void> _fetchProductDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final details = await ApiService.fetchProductDetails(productId);
      print('Fetched product details: $details'); // Debug statement

      // Ensure sizes and lengths are treated as List<dynamic>
      if (details['sizes'] != null) {
        details['sizes'] = details['sizes'] as List<dynamic>;
      } else {
        details['sizes'] = []; // Default to an empty list if sizes is null
      }

      if (details['lengths'] != null) {
        details['lengths'] = details['lengths'] as List<dynamic>;
      } else {
        details['lengths'] = []; // Default to an empty list if lengths is null
      }

      setState(() {
        productDetails = details;
      });
    } catch (e) {
      print('Error fetching product details: $e'); // Debug statement
      setState(() {
        _errorMessage = 'Failed to fetch product details: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : CustomScrollView(
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
                          sizeInfo(),
                          if (productDetails!['lengths'] != null &&
                              productDetails!['lengths'].isNotEmpty) ...[
                            heightSpace,
                            heightSpace,
                            lengthsInfo(),
                          ],
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
          print('Add to cart button pressed'); // Debug statement
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
            children: (productDetails!['sizes'] as List<dynamic>).map((size) {
              return GestureDetector(
                onTap: () {
                  print('Selected size: $size'); // Debug statement
                  setState(() {
                    selectedSize = productDetails!['sizes'].indexOf(size);
                  });
                },
                child: Container(
                  height: 34.0,
                  width: 34.0,
                  margin: const EdgeInsets.symmetric(
                      horizontal: fixPadding * 0.75),
                  decoration: BoxDecoration(
                    color: selectedSize == productDetails!['sizes'].indexOf(size)
                        ? primaryColor
                        : whiteColor,
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: borderColor),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    size.toString(),
                    style: selectedSize == productDetails!['sizes'].indexOf(size)
                        ? regular15White
                        : regular15Grey,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }

  lengthsInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
          child: Text(
            "Lengths",
            style: medium16Black,
          ),
        ),
        heightSpace,
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: fixPadding * 1.25),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: (productDetails!['lengths'] as List<dynamic>).map((length) {
              return GestureDetector(
                onTap: () {
                  print('Selected length: $length'); // Debug statement
                  setState(() {
                    selectedLength = productDetails!['lengths'].indexOf(length);
                  });
                },
                child: Container(
                  height: 34.0,
                  width: 34.0,
                  margin: const EdgeInsets.symmetric(horizontal: fixPadding * 0.75),
                  decoration: BoxDecoration(
                    color: selectedLength == productDetails!['lengths'].indexOf(length)
                        ? primaryColor
                        : whiteColor,
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: borderColor),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    length.toString(),
                    style: selectedLength == productDetails!['lengths'].indexOf(length)
                        ? regular15White
                        : regular15Grey,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }

  jewelryInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productDetails!['name'],
                  style: medium18Black,
                ),
                Text(
                  productDetails!['category'] ?? 'No category',
                  style: medium13Grey,
                )
              ],
            ),
          ),
          widthSpace,
          Text(
            productDetails!['weight'], // Display weight without $ sign
            style: bold18Primary,
          )
        ],
      ),
    );
  }

  header(Size size, BuildContext context) {
    return SliverAppBar(
      expandedHeight: size.height * 0.25, // Reduced image size
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
          print('Back button pressed'); // Debug statement
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
          child: favouriteIconButton(context), // Favorite button on top right
        ),
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
              items: [
                CachedNetworkImage(
                  imageUrl:
                      'http://192.168.0.104:8000/storage/${productDetails!['image']}',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) {
                    print('Error loading image: $error'); // Debug statement
                    return const Icon(Icons.error); // Display an error icon
                  },
                ),
              ],
              options: CarouselOptions(
                viewportFraction: 1.0,
                height: size.height * 0.25, // Reduced image height
                initialPage: currentImageIndex,
                onPageChanged: (index, reason) {
                  print('Image changed to index: $index'); // Debug statement
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
                1, // Only one image in this example
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
        print('Favourite button pressed'); // Debug statement
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
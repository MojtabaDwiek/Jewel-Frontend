import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart'; // For network images
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:pn_fl_jewellery_empire/Models/CartItem.dart';
import 'package:pn_fl_jewellery_empire/screens/bottom_bar.dart';
import 'package:pn_fl_jewellery_empire/theme/theme.dart';
import 'package:pn_fl_jewellery_empire/services/api_service.dart'; // Import your API service
import 'package:provider/provider.dart'; // Import provider package
import 'package:pn_fl_jewellery_empire/cart_provider.dart'; // Import your CartProvider
import 'package:photo_view/photo_view.dart'; // For zoomable images

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int currentImageIndex = 0;
  bool isFavourite = false;
  final sizeList = ["46", "48", "50", "52", "56", "58", "60"];
  int selectedSize = 0; // Default to the first size
  int selectedLength = 0; // Default to the first length

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
      _fetchProductDetails();
    } else {
      setState(() {
        _errorMessage = 'Product ID is missing.';
      });
    }
  }

  Future<void> _fetchProductDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Fetching product details from the API
      final details = await ApiService.fetchProductDetails(productId);

      // Ensure sizes and lengths are treated as List<dynamic> if they exist
      details['sizes'] = details['sizes'] != null
          ? List<String>.from(details['sizes'] as List<dynamic>)
          : []; // Default to an empty list if sizes is null

      details['lengths'] = details['lengths'] != null
          ? List<String>.from(details['lengths'] as List<dynamic>)
          : []; // Default to an empty list if lengths is null

      // Reset selectedSize and selectedLength if the lists are empty
      if (details['sizes'].isEmpty) {
        selectedSize = -1; // No valid size selected
      }

      if (details['lengths'].isEmpty) {
        selectedLength = -1; // No valid length selected
      }

      // Checking if the data is fetched successfully and mounted before updating the UI
      if (mounted) {
        setState(() {
          productDetails = details; // Save the fetched product details to state
        });
      }
    } catch (e) {
      // Handling any error that occurs during the fetch process
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to fetch product details: $e'; // Set the error message
        });
      }
    } finally {
      // Ensuring that the loading state is stopped, even if there's an error
      if (mounted) {
        setState(() {
          _isLoading = false; // Stop loading spinner after data fetch
        });
      }
    }
  }

  // Method to add product to favorites
  Future<void> _addToFavorites() async {
    try {
      // Attempt to add the product to favorites
      await ApiService.addToFavorites(productId);

      setState(() {
        isFavourite = true; // Mark as favorite after successful addition
      });

      // Show success SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green, // Success color
          behavior: SnackBarBehavior.floating,
          duration: Duration(milliseconds: 1500),
          content: Text(
            "Added to favorites",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );
    } catch (e) {
      // If the error is due to product already being in favorites, show that message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orange, // Color for "already in favorites"
          behavior: SnackBarBehavior.floating,
          duration: Duration(milliseconds: 1500),
          content: Text(
            "This product is already in your favorites.",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );
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
                          jewelryInfo(), // Display jewelry info, now includes weight and carat
                          heightSpace,
                          heightSpace,
                          // Only show sizeInfo if sizes is not null and not empty
                          if (productDetails!['sizes'] != null && productDetails!['sizes'].isNotEmpty) ...[
                            sizeInfo(),
                            heightSpace,
                            heightSpace,
                          ],
                          // Only show lengths if lengths is not null or empty
                          if (productDetails!['lengths'] != null && productDetails!['lengths'].isNotEmpty) ...[
                            lengthsInfo(),
                            heightSpace,
                            heightSpace,
                          ],
                        ],
                      ),
                    )
                  ],
                ),
      bottomNavigationBar: addToCartButton(),
    );
  }

 Widget addToCartButton() {
  final cartProvider = Provider.of<CartProvider>(context, listen: false);
  TextEditingController noteController = TextEditingController();

  return Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
    child: GestureDetector(
      onTap: () async {
        // Show a dialog to add a note
        final String? note = await showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Add a Note (Optional)"),
              content: TextFormField(
                controller: noteController,
                decoration: const InputDecoration(
                  hintText: "Enter your note here...",
                ),
                maxLines: 3,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(noteController.text);
                  },
                  child: const Text("Add to Cart"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel"),
                ),
              ],
            );
          },
        );

        // If the user cancels the dialog, return
        if (note == null) return;

        // Ensure productDetails is not null
        if (productDetails == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text("Product details are missing."),
            ),
          );
          return;
        }

        // Debug: Print the entire productDetails map
        print("Product Details Map: $productDetails");

        // Validate required fields
        final id = productDetails!['id']?.toString();
        final name = productDetails!['name']?.toString();
        final category = productDetails!['category']?.toString();
        final weight = double.tryParse(productDetails!['weight']?.toString() ?? '0') ?? 0.0;
        final imageUrl = productDetails!['images'] != null && productDetails!['images'].isNotEmpty
            ? productDetails!['images'][0].toString() // Use the first image in the list
            : 'https://example.com/fallback-image.jpg'; // Fallback URL if the list is empty
        final carat = productDetails?['carat'] != null
            ? double.tryParse(productDetails!['carat'].toString()) ?? 0.0
            : 0.0;

        // Check if required fields are missing
        if (id == null || name == null || category == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text("Required product details are missing."),
            ),
          );
          return;
        }

        // Create a CartItem object with the product details
        final cartItem = CartItem(
          id: id,
          name: name,
          category: category,
          weight: weight,
          selectedSize: productDetails?['sizes'] != null && productDetails!['sizes'].isNotEmpty
              ? productDetails!['sizes'][selectedSize].toString()
              : null,
          selectedLength: productDetails?['lengths'] != null && productDetails!['lengths'].isNotEmpty
              ? productDetails!['lengths'][selectedLength].toString()
              : null,
          carat: carat,
          imageUrl: imageUrl,
          quantity: 1,
          note: note,
        );

        // Add the product to the cart
        cartProvider.addToCart(cartItem);

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: blackColor,
            behavior: SnackBarBehavior.floating,
            duration: Duration(milliseconds: 1500),
            content: Text(
              "Added to cart",
              style: medium16White,
            ),
          ),
        );

        // Navigate to the cart screen (optional)
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
          vertical: fixPadding * 1.5,
          horizontal: fixPadding * 2.0,
        ),
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

  Widget sizeInfo() {
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
                  setState(() {
                    selectedSize = productDetails!['sizes'].indexOf(size);
                  });
                },
                child: Container(
                  height: 34.0,
                  width: 34.0,
                  margin: const EdgeInsets.symmetric(horizontal: fixPadding * 0.75),
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

  Widget lengthsInfo() {
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

  Widget jewelryInfo() {
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
                ),
              ],
            ),
          ),
          widthSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${productDetails!['weight']} g", // Append "g" after the weight
                style: bold18Primary,
              ),
              // Add Carat below the weight
              if (productDetails!['carat'] != null)
                Text(
                  "${productDetails!['carat']} ct", // Append "ct" after the carat value
                  style: bold18Primary,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget header(Size size, BuildContext context) {
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
          child: IconButton(
            onPressed: _addToFavorites, // Call addToFavorites directly
            icon: const Iconify(
              Ph.heart_straight,
              size: 22.0,
              color: blackColor,
            ),
          ),
        ),
      ],
      flexibleSpace: productImages(size),
    );
  }

  Widget productImages(Size size) {
  return FlexibleSpaceBar(
    collapseMode: CollapseMode.pin,
    background: Stack(
      children: [
        Center(
          child: CarouselSlider(
            items: (productDetails?['images'] as List<dynamic>?)
                ?.map((imageUrl) {
              // Construct the full URL for the image
              return GestureDetector(
                onTap: () {
                  // Show the image in full screen with zoom functionality
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        backgroundColor: Colors.transparent, // Make the dialog background transparent
                        insetPadding: EdgeInsets.zero, // Remove default padding
                        child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: PhotoView(
                            imageProvider: CachedNetworkImageProvider(
                              'http://192.168.0.110:8000/storage/$imageUrl',
                            ),
                            minScale: PhotoViewComputedScale.contained,
                            maxScale: PhotoViewComputedScale.covered * 2,
                            initialScale: PhotoViewComputedScale.contained,
                            backgroundDecoration: BoxDecoration(
                              color: Colors.white, // Set background color to white
                            ),
                            heroAttributes: PhotoViewHeroAttributes(
                              tag: imageUrl, // Unique tag for hero animation
                            ),
                            enableRotation: true, // Allow image rotation
                            basePosition: Alignment.center, // Center the image
                          ),
                        ),
                      );
                    },
                  );
                },
                child: CachedNetworkImage(
                  imageUrl: 'http://192.168.0.110:8000/storage/$imageUrl',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) {
                    return const Icon(Icons.error); // Display an error icon
                  },
                ),
              );
            }).toList() ??
                [], // Handle case when 'images' is null or empty
            options: CarouselOptions(
              viewportFraction: 1.0,
              height: size.height * 0.25, // Adjusted image height
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
              // Safely access the length of the images list
              (productDetails?['images'] as List<dynamic>?)?.length ?? 0,
              (index) {
                return Container(
                  height: 10.0,
                  width: 10.0,
                  margin: const EdgeInsets.symmetric(horizontal: fixPadding / 4),
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
}
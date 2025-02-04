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
      
      _fetchProductDetails();
    } else {
      
    }
  }

  Future<void> _fetchProductDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final details = await ApiService.fetchProductDetails(productId);
     

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

      if (mounted) {
        setState(() {
          productDetails = details;
        });
      }
    } catch (e) {
      
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to fetch product details: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
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
        backgroundColor: Colors.green,  // Success color
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
        backgroundColor: Colors.orange,  // Color for "already in favorites"
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
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: GestureDetector(
        onTap: () {
          // Pass the image path directly, without constructing the URL here
          final imagePath = productDetails!['image'];  // Image path stored in productDetails

          

          // Create a CartItem object with the product details
          final cartItem = CartItem(
            id: productDetails!['id'].toString(), // Product ID
            name: productDetails!['name'], // Product name
            category: productDetails!['category'], // Product category
            weight: double.parse(productDetails!['weight'].toString()), // Product weight
            selectedSize: productDetails!['sizes'][selectedSize].toString(), // Selected size
            selectedLength: productDetails!['lengths'][selectedLength].toString(), // Selected length
            quantity: 1, // Default quantity
            imageUrl: imagePath, // Passing image path directly
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
  "${productDetails!['weight']} g", // Append "kg" after the weight
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
                    
                    return const Icon(Icons.error); // Display an error icon
                  },
                ),
              ],
              options: CarouselOptions(
                viewportFraction: 1.0,
                height: size.height * 0.25, // Reduced image height
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
}
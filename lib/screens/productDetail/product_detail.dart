import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:pn_fl_jewellery_empire/Models/CartItem.dart';
import 'package:pn_fl_jewellery_empire/app_config.dart';
import 'package:pn_fl_jewellery_empire/screens/bottom_bar.dart';
import 'package:pn_fl_jewellery_empire/theme/theme.dart';
import 'package:pn_fl_jewellery_empire/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:pn_fl_jewellery_empire/cart_provider.dart';
import 'package:photo_view/photo_view.dart';


class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int currentImageIndex = 0;
  bool isFavourite = false;
  final sizeList = ["46", "48", "50", "52", "56", "58", "60"];
  int selectedSize = 0;
  int selectedLength = 0;

  late int productId;
  Map<String, dynamic>? productDetails;
  bool _isLoading = true;
  String _errorMessage = '';
  bool _isDisposed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null) {
      productId = args as int;
      _fetchProductDetails();
    } else {
      setState(() {
        _errorMessage = 'Product ID is missing.';
      });
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> _fetchProductDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final details = await ApiService.fetchProductDetails(productId);

      details['sizes'] = details['sizes'] != null
          ? List<String>.from(details['sizes'] as List<dynamic>)
          : [];

      details['lengths'] = details['lengths'] != null
          ? List<String>.from(details['lengths'] as List<dynamic>)
          : [];

      if (details['sizes'].isEmpty) {
        selectedSize = -1;
      }

      if (details['lengths'].isEmpty) {
        selectedLength = -1;
      }

      if (!_isDisposed && mounted) {
        setState(() {
          productDetails = details;
        });
      }
    } catch (e) {
      if (!_isDisposed && mounted) {
        setState(() {
          _errorMessage = 'Failed to fetch product details: $e';
        });
      }
    } finally {
      if (!_isDisposed && mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _addToFavorites() async {
    try {
      await ApiService.addToFavorites(productId);

      if (!_isDisposed && mounted) {
        setState(() {
          isFavourite = true;
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(milliseconds: 1500),
          content: Text(
            "Added to favorites",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orange,
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
                          if (productDetails!['sizes'] != null && productDetails!['sizes'].isNotEmpty) ...[
                            sizeInfo(),
                            heightSpace,
                            heightSpace,
                          ],
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

          if (note == null) return;

          if (productDetails == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.red,
                content: Text("Product details are missing."),
              ),
            );
            return;
          }

          final id = productDetails!['id']?.toString();
          final name = productDetails!['name']?.toString();
          final category = productDetails!['category']?.toString();
          final weight = double.tryParse(productDetails!['weight']?.toString() ?? '0') ?? 0.0;
          final imageUrl = productDetails!['images'] != null && productDetails!['images'].isNotEmpty
              ? productDetails!['images'][0].toString()
              : AppConfig.fallbackImageUrl; // Use fallback image URL from AppConfig
          final carat = productDetails?['carat'] != null
              ? double.tryParse(productDetails!['carat'].toString()) ?? 0.0
              : 0.0;

          if (id == null || name == null || category == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.red,
                content: Text("Required product details are missing."),
              ),
            );
            return;
          }

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

          cartProvider.addToCart(cartItem);

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
                "${productDetails!['weight']} g",
                style: bold18Primary,
              ),
              if (productDetails!['carat'] != null)
                Text(
                  "${productDetails!['carat']} ct",
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
      expandedHeight: size.height * 0.25,
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
            onPressed: _addToFavorites,
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
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          backgroundColor: Colors.transparent,
                          insetPadding: EdgeInsets.zero,
                          child: SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: PhotoView(
                              imageProvider: CachedNetworkImageProvider(
                                '${AppConfig.imageBaseUrl}/$imageUrl', // Use imageBaseUrl from AppConfig
                              ),
                              minScale: PhotoViewComputedScale.contained,
                              maxScale: PhotoViewComputedScale.covered * 2,
                              initialScale: PhotoViewComputedScale.contained,
                              backgroundDecoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              heroAttributes: PhotoViewHeroAttributes(
                                tag: imageUrl,
                              ),
                              enableRotation: true,
                              basePosition: Alignment.center,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: '${AppConfig.imageBaseUrl}/$imageUrl', // Use imageBaseUrl from AppConfig
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) {
                      return const Icon(Icons.error);
                    },
                    memCacheHeight: 200,
                    memCacheWidth: 200,
                  ),
                );
              }).toList() ??
                  [],
              options: CarouselOptions(
                viewportFraction: 1.0,
                height: size.height * 0.25,
                initialPage: currentImageIndex,
                onPageChanged: (index, reason) {
                  if (!_isDisposed && mounted) {
                    setState(() {
                      currentImageIndex = index;
                    });
                  }
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
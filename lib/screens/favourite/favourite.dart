import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:pn_fl_jewellery_empire/theme/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pn_fl_jewellery_empire/services/api_service.dart'; // Import your API service
import 'package:shared_preferences/shared_preferences.dart'; // For SharedPreferences

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  List<dynamic> favouriteList = [];
  bool _isLoading = true; // New state variable to track loading
  bool _isDisposed = false; // Track if the widget is disposed

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  @override
  void dispose() {
    _isDisposed = true; // Mark the widget as disposed
    super.dispose();
  }

  // Fetch the list of favorite items from the API
  Future<void> _loadFavorites() async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('User not logged in');
      }

      final favorites = await ApiService.viewFavorites(); // Use ApiService to fetch favorites

      if (!_isDisposed && mounted) {
        setState(() {
          // Extracting product data from the response and updating the favouriteList
          favouriteList = favorites.map((favorite) => favorite['product']).toList();
          _isLoading = false; // Set loading to false when data is fetched
        });
      }
    } catch (e) {
      if (!_isDisposed && mounted) {
        setState(() {
          _isLoading = false; // Stop loading if there's an error
        });
      }
    }
  }

  // Remove product from favorites
  Future<void> _removeFromFavorites(int productId) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('User not logged in');
      }

      await ApiService.removeFromFavorites(productId); // Use ApiService to remove from favorites

      if (!_isDisposed && mounted) {
        setState(() {
          favouriteList.removeWhere((item) => item['id'] == productId); // Remove the product from the list
        });
      }

      if (!_isDisposed && mounted) {
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
      }
    } catch (e) {
      // Handle error
    }
  }

  // Function to get the token from SharedPreferences
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      return null;
    }
    return token;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _header(),
          Expanded(
            child: _isLoading
                ? _loadingIndicator() // Show loading indicator if data is still being fetched
                : favouriteList.isEmpty
                    ? _emptyListContent()
                    : _favouriteListContent(),
          ),
        ],
      ),
    );
  }

  // Loading Indicator
  Widget _loadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(primaryColor), // Adjust this to your theme color
      ),
    );
  }

  Widget _emptyListContent() {
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

  Widget _favouriteListContent() {
    return GridView.builder(
      padding: const EdgeInsets.all(fixPadding * 2.0),
      itemCount: favouriteList.length,
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: fixPadding * 2.0,
        crossAxisSpacing: fixPadding * 2.0,
        childAspectRatio: 0.8, // Adjusted for better proportions
      ),
      itemBuilder: (context, index) {
        final product = favouriteList[index];

        // Ensure that the 'images' field is not null or empty
        List<String> imageUrls = [];
        if (product['images'] != null && product['images'].isNotEmpty) {
          imageUrls = List<String>.from(product['images']);
        }

        // If no images are available, show a fallback image
        String imageUrl = imageUrls.isNotEmpty
            ? 'http://192.168.0.110:8000/storage/${imageUrls[0]}' // Use the first image
            : 'http://192.168.0.110:8000/storage/default_image.png'; // Fallback image

        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/productDetail',
              arguments: product['id'], // Pass the product ID
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(
                    child: CachedNetworkImage(
                      imageUrl: imageUrl, // Display the first image in the array
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const CircularProgressIndicator(), // Loading indicator
                      errorWidget: (context, url, error) {
                        return const Icon(Icons.error); // Display an error icon
                      },
                      memCacheHeight: 200, // Optimize image caching
                      memCacheWidth: 200, // Optimize image caching
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: fixPadding * 1.5),
                  width: double.maxFinite,
                  height: 1.0,
                  color: borderColor, // Add a divider
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: fixPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name'], // Display product name
                        style: regular16Black,
                        overflow: TextOverflow.ellipsis, // Handle overflow
                      ),
                      Text(
                        '${product['weight']} g', // Display product weight
                        style: semibold16Black,
                        overflow: TextOverflow.ellipsis, // Handle overflow
                      )
                    ],
                  ),
                ),
                // Remove from Favourite Button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(fixPadding),
                    child: InkWell(
                      onTap: () async {
                        await _removeFromFavorites(product['id']);
                      },
                      child: const Iconify(
                        Ph.heart_straight_fill,
                        size: 20.0,
                        color: Colors.red, // Highlight the heart icon
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _header() {
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
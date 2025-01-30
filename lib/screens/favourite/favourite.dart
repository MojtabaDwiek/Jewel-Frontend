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

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  // Fetch the list of favorite items from the API
  Future<void> _loadFavorites() async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('User not logged in');
      }
      
      final favorites = await ApiService.viewFavorites(); // Use ApiService to fetch favorites
      print("Favorites: $favorites"); // Debugging to check if the API response is correct
      setState(() {
        // Extracting product data from the response and updating the favouriteList
        favouriteList = favorites.map((favorite) => favorite['product']).toList();
      });
    } catch (e) {
      print('Error fetching favorites: $e');
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
      setState(() {
        favouriteList.removeWhere((item) => item['id'] == productId); // Remove the product from the list
      });

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
    } catch (e) {
      print('Error removing from favorites: $e');
    }
  }

  // Function to get the token from SharedPreferences
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      print("No token found");
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
            child: favouriteList.isEmpty
                ? _emptyListContent()
                : _favouriteListContent(),
          ),
        ],
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
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final product = favouriteList[index]; // Now directly accessing the product
        final imageUrl = 'http://192.168.0.104:8000/storage/${product['image']}'; // Construct full URL
        
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/productDetail',
              arguments: product['id'], // Pass the product ID
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: fixPadding * 1.9),
            width: double.maxFinite,
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
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) {
                        return const Icon(Icons.error); // Display error icon if image fails to load
                      },
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: fixPadding * 1.5),
                  width: double.maxFinite,
                  height: 1.0,
                  color: borderColor,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: fixPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name'] ?? "Unknown Product", // Default text if name is null
                        style: regular16Black,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "${product['weight'] ?? 'N/A'}", // Use weight instead of price
                        style: semibold16Black,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
                // Remove icon button
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

import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bx.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:pn_fl_jewellery_empire/app_config.dart';
import 'package:pn_fl_jewellery_empire/theme/theme.dart';
import 'package:pn_fl_jewellery_empire/services/api_service.dart';
import 'package:cached_network_image/cached_network_image.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _allProducts = []; // To store all products
  List<dynamic> _searchResults = []; // To store search results
  bool _isLoading = false;
  String _errorMessage = '';
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _fetchProducts(); // Fetch all products when the screen is initialized
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> _fetchProducts() async {
    if (!mounted) return; // Ensure the widget is still mounted before proceeding

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final products = await ApiService.fetchProducts(); // Fetch all products
      if (!_isDisposed && mounted) {
        setState(() {
          _allProducts = products;
        });
      }
    } catch (e) {
      if (!_isDisposed && mounted) {
        setState(() {
          _errorMessage = 'Failed to fetch products: $e';
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

  void _performSearch(String query) {
    if (!mounted) return; // Ensure the widget is still mounted before proceeding

    setState(() {
      _searchResults = _allProducts
          .where((product) =>
              product['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        left: false,
        right: false,
        child: Column(
          children: [
            height5Space,
            searchField(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage.isNotEmpty
                      ? Center(
                          child: Text(
                            _errorMessage,
                            style: const TextStyle(color: Colors.red, fontSize: 16),
                          ),
                        )
                      : _searchController.text.isEmpty
                          ? _buildDefaultContent()
                          : _buildSearchResults(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultContent() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: fixPadding * 2.0),
      children: [
        popularSearches(),
        recentSearch(),
        heightSpace,
        heightSpace,
        heightSpace,
        popularListContent(), // Replaced recommendedForYou() with popularListContent()
      ],
    );
  }

 Widget _buildSearchResults() {
  return GridView.builder(
    shrinkWrap: true,
    physics: const BouncingScrollPhysics(),
    padding: const EdgeInsets.all(fixPadding * 2.0),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: fixPadding * 2.0,
      crossAxisSpacing: fixPadding * 2.0,
      childAspectRatio: 0.8,
    ),
    itemCount: _searchResults.length,
    itemBuilder: (context, index) {
      final product = _searchResults[index];

      // Ensure that the 'images' field is not null or empty
      List<String> imageUrls = [];
      if (product['images'] != null && product['images'].isNotEmpty) {
        imageUrls = List<String>.from(product['images']);
      }

      // Construct the image URL
      String imageUrl = imageUrls.isNotEmpty
          ? '${AppConfig.imageBaseUrl}/${imageUrls[0]}' // Use the first image
          : AppConfig.fallbackImageUrl; // Use fallback image URL from AppConfig

      // Debug the image URL
      print('Image URL: $imageUrl');

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
                    imageUrl: imageUrl, // Use the constructed URL
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) {
                      print('Error loading image: $error');
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
                color: borderColor,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: fixPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'],
                      style: regular16Black,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${product['weight']} g', // Display weight
                      style: semibold16Black,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}

  Widget popularListContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
          child: Text(
            "Popular",
            style: semibold18Black,
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
              fixPadding * 2.0, fixPadding, fixPadding * 2.0, fixPadding * 2.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: fixPadding * 2.0,
            crossAxisSpacing: fixPadding * 2.0,
            childAspectRatio: 0.8,
          ),
          itemCount: _allProducts.length > 6 ? 6 : _allProducts.length, // Limit to 6 products
          itemBuilder: (context, index) {
            final product = _allProducts[index];

            // Ensure that the 'images' field is not null or empty
            List<String> imageUrls = [];
            if (product['images'] != null && product['images'].isNotEmpty) {
              imageUrls = List<String>.from(product['images']);
            }

            // If no images are available, show a fallback image
            String imageUrl = imageUrls.isNotEmpty
                ? '${AppConfig.imageBaseUrl}/${imageUrls[0]}' // Use imageBaseUrl from AppConfig
                : AppConfig.fallbackImageUrl; // Use fallback image URL from AppConfig

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
                          imageUrl: imageUrl, // Display the first image in the array
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const CircularProgressIndicator(),
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
                      color: borderColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: fixPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['name'],
                            style: regular16Black,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${product['weight']} g', // Display weight
                            style: semibold16Black,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        )
      ],
    );
  }

  Widget recentSearch() {
    return const SizedBox(); // Remove recent search functionality
  }

  Widget popularSearches() {
    return const SizedBox(); // Remove popular searches functionality
  }

  Widget searchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: fixPadding * 2.0, vertical: fixPadding),
      child: TextField(
        controller: _searchController,
        cursorColor: primaryColor,
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: greyC4Color),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: blackColor),
          ),
          hintText: "Search",
          hintStyle: regular16Grey,
          prefixIconConstraints:
              const BoxConstraints(minWidth: 35.0, maxWidth: 35.0),
          prefixIcon: const Align(
            alignment: Alignment.centerLeft,
            child: Iconify(
              Bx.search,
              size: 20.0,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: fixPadding),
          suffixIcon: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/searchFilter');
            },
            icon: const Iconify(
              Ph.sliders,
              size: 22.0,
            ),
          ),
        ),
        onChanged: _performSearch, // Perform search as the user types
      ),
    );
  }
}
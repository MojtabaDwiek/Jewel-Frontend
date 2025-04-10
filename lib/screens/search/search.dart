import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bx.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:pn_fl_jewellery_empire/app_config.dart';
import 'package:pn_fl_jewellery_empire/theme/theme.dart';
import 'package:pn_fl_jewellery_empire/services/api_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pn_fl_jewellery_empire/screens/searchfilter/search_filter.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _allProducts = [];
  List<dynamic> _searchResults = [];
  List<String> _selectedCarats = [];
  List<String> _selectedWeights = [];
  bool _isLoading = false;
  String _errorMessage = '';
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchProducts() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final products = await ApiService.fetchProducts();
      if (!_isDisposed && mounted) {
        setState(() {
          _allProducts = products;
          _searchResults = products;
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
    if (!mounted) return;

    setState(() {
      if (query.isEmpty) {
        _searchResults = _allProducts;
      } else {
        _searchResults = _allProducts.where((product) {
          final productName = _normalizeText(product['name'].toString());
          final normalizedQuery = _normalizeText(query);
          
          // Check if either the original or normalized text matches
          return product['name'].toString().toLowerCase().contains(query.toLowerCase()) ||
                 productName.contains(normalizedQuery);
        }).toList();
      }
      _applyFilters();
    });
  }

  String _normalizeText(String input) {
    // Convert to lowercase and trim
    String normalized = input.toLowerCase().trim();
    
    // Remove Arabic diacritics
    normalized = normalized.replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '');
    
    // Normalize Arabic characters
    normalized = normalized
      .replaceAll('ة', 'ه')
      .replaceAll('أ', 'ا')
      .replaceAll('إ', 'ا')
      .replaceAll('آ', 'ا')
      .replaceAll('ى', 'ي');
    
    return normalized;
  }

  void _applyFilters() {
    setState(() {
      _searchResults = _allProducts.where((product) {
        bool matchesCarat = _selectedCarats.isEmpty ||
            _selectedCarats.contains(product['carat'].toString());
        bool matchesWeight = _selectedWeights.isEmpty ||
            _selectedWeights.contains(product['weight'].toString());
        
        final query = _searchController.text.toLowerCase();
        final productName = product['name'].toString().toLowerCase();
        final normalizedProductName = _normalizeText(productName);
        final normalizedQuery = _normalizeText(query);
        
        bool matchesSearch = query.isEmpty || 
            productName.contains(query) ||
            normalizedProductName.contains(normalizedQuery);
            
        return matchesCarat && matchesWeight && matchesSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bk.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            left: false,
            right: false,
            child: Column(
              children: [
                height5Space,
                _buildSearchField(),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultContent() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: fixPadding * 2.0),
      children: [
        _buildPopularSearches(),
        _buildRecentSearch(),
        heightSpace,
        heightSpace,
        heightSpace,
        _buildPopularListContent(),
      ],
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Text(
          'No products found',
          style: semibold16Black,
        ),
      );
    }

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
        final imageUrl = _getProductImageUrl(product);

        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/productDetail',
              arguments: product['id'],
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: fixPadding * 1.9),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: const Color(0xFFD4AF37),
                width: 2.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => 
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => 
                          const Icon(Icons.error),
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
                        maxLines: 1,
                      ),
                      Text(
                        '${product['weight']} g | ${product['carat']}K',
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

  String _getProductImageUrl(dynamic product) {
    final images = product['images'] ?? [];
    return images.isNotEmpty
        ? '${AppConfig.imageBaseUrl}/${images[0]}'
        : AppConfig.fallbackImageUrl;
  }

  Widget _buildPopularListContent() {
    final lastTenProducts = _allProducts.length <= 10
        ? _allProducts
        : _allProducts.sublist(_allProducts.length - 10);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
          child: Text(
            "Latest Products",
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
          itemCount: lastTenProducts.length,
          itemBuilder: (context, index) {
            final product = lastTenProducts[index];
            final imageUrl = _getProductImageUrl(product);

            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/productDetail',
                  arguments: product['id'],
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: fixPadding * 1.9),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: const Color(0xFFD4AF37),
                    width: 2.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Center(
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => 
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => 
                              const Icon(Icons.error),
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
                            '${product['weight']} g',
                            style: semibold16Black,
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

  Widget _buildRecentSearch() {
    return const SizedBox();
  }

  Widget _buildPopularSearches() {
    return const SizedBox();
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: fixPadding * 2.0, vertical: fixPadding),
      child: TextField(
        controller: _searchController,
        cursorColor: primaryColor,
        textDirection: TextDirection.rtl, // For better Arabic support
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: greyC4Color),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: blackColor),
          ),
          hintText: "ابحث عن منتج...", // Arabic placeholder
          hintStyle: regular16Grey,
          hintTextDirection: TextDirection.rtl,
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
            onPressed: () async {
              final filterResult = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchFilterScreen()),
              );

              if (filterResult != null) {
                setState(() {
                  _selectedCarats = filterResult['carats'];
                  _selectedWeights = filterResult['weights'];
                });
                _applyFilters();
              }
            },
            icon: const Iconify(
              Ph.sliders,
              size: 22.0,
            ),
          ),
        ),
        onChanged: _performSearch,
      ),
    );
  }
}
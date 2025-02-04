import 'package:flutter/material.dart';
import 'package:pn_fl_jewellery_empire/theme/theme.dart';
import 'package:cached_network_image/cached_network_image.dart'; // For network images
import 'package:pn_fl_jewellery_empire/services/api_service.dart'; // Import your API service

class CategoryProductsScreen extends StatefulWidget {
  const CategoryProductsScreen({super.key});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  List<dynamic> _categoryProducts = []; // To store products for the selected category
  bool _isLoading = false;
  String _errorMessage = '';
  String? categoryName; // To store the selected category name

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Retrieve the category name from the navigation arguments
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null) {
      categoryName = args as String;
      _fetchCategoryProducts(); // Fetch products for the selected category
    }
  }

  Future<void> _fetchCategoryProducts() async {
  // Start by setting the loading state
  setState(() {
    _isLoading = true;
    _errorMessage = '';
  });

  try {
    // Fetch all products from the API
    final products = await ApiService.fetchProducts();

    // Ensure we only display products that belong to the selected category
    final filteredProducts = products.where((product) {
      return product['category'] == categoryName;
    }).toList();

    // Only call setState if the widget is still mounted
    if (mounted) {
      setState(() {
        _categoryProducts = filteredProducts;
      });
    }
  } catch (e) {
    // Update error message if there's an issue with fetching products
    if (mounted) {
      setState(() {
        _errorMessage = 'Failed to fetch products: $e';
      });
    }
  } finally {
    // Set loading state to false after fetching is complete
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          header(context),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage.isNotEmpty
                  ? Center(
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    )
                  : productListContent(),
        ],
      ),
    );
  }

  Widget productListContent() {
    return Expanded(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(fixPadding * 2.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: fixPadding * 2.0,
          crossAxisSpacing: fixPadding * 2.0,
          childAspectRatio: 0.8,
        ),
        itemCount: _categoryProducts.length,
        itemBuilder: (context, index) {
          final product = _categoryProducts[index];
          final imageUrl =
              'http://192.168.0.104:8000/storage/${product['image']}'; // Construct full URL
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
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) {
                          return const Icon(Icons.error); // Display an error icon
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: fixPadding * 1.5),
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
                          '${product['weight']}', // Display weight
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
      ),
    );
  }

  Widget header(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: fixPadding),
      decoration: headerBoxDecoration,
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: false,
        automaticallyImplyLeading: false,
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
        titleSpacing: fixPadding * 1.5,
        title: Text(
          categoryName ?? "Category Products", // Display the category name
          style: semibold20Black,
        ),
      ),
    );
  }
}
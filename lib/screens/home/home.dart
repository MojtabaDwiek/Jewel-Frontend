import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bx.dart';
import 'package:pn_fl_jewellery_empire/screens/bottom_bar.dart';
import 'package:pn_fl_jewellery_empire/theme/theme.dart';
import 'package:cached_network_image/cached_network_image.dart'; // For network images
import 'package:pn_fl_jewellery_empire/services/api_service.dart'; // Import your API service
import 'package:shared_preferences/shared_preferences.dart'; // For logout functionality

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final posterList = [
    {
      "image": "assets/home/poster-image.png",
      "title": "Buy Your Elegant\nJewelry",
    },
    {
      "image": "assets/home/poster-image.png",
      "title": "Buy Your Elegant\nJewelry",
    },
  ];

  final categoryList = [
    {"image": "assets/home/Jewelry-1.png", "title": "كسر شفت"},
    {"image": "assets/home/Jewelry-2.png", "title": "تعاليق"},
    {"image": "assets/home/Jewelry-3.png", "title": "غورميت"},
    {"image": "assets/home/Jewelry-4.png", "title": "فرنكات"},
    {"image": "assets/home/Jewelry-1.png", "title": "تركي"},
    {"image": "assets/home/Jewelry-2.png", "title": "ليزر"},
    {"image": "assets/home/Jewelry-3.png", "title": "خواتم"},
  ];

  List<dynamic> _recommendedList = [];
  List<dynamic> _popularList = [];
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchProducts(); // Fetch products when the screen is initialized
  }

  Future<void> _fetchProducts() async {
  setState(() {
    _isLoading = true;
    _errorMessage = '';
  });

  try {
    final products = await ApiService.fetchProducts();

    // Check if the widget is still mounted before updating state
    if (mounted) {
      setState(() {
        _recommendedList = products; // Assign fetched products to recommended list
        _popularList = products; // Assign fetched products to popular list
      });
    }
  } catch (e) {
    // Check if the widget is still mounted before updating state
    if (mounted) {
      setState(() {
        _errorMessage = 'Failed to fetch products: $e';
      });
    }
  } finally {
    // Check if the widget is still mounted before updating state
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}


  // Logout functionality
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn'); // Clear login state
    await prefs.remove('token'); // Clear token

    // Navigate back to the login screen
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header(),
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
                    : RefreshIndicator(
                        onRefresh: _fetchProducts, // Trigger refresh on pull
                        child: ListView(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(top: fixPadding * 2.0),
                          children: [
                            posters(),
                            heightSpace,
                            heightSpace,
                            heightSpace,
                            categoryListContent(),
                            heightSpace,
                            heightSpace,
                            recommendedForYou(),
                            heightSpace,
                            heightSpace,
                            popularListContent(),
                          ],
                        ),
                      ),
          )
        ],
      ),
    );
  }

  Widget categoryListContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title("Category"),
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(fixPadding),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              categoryList.length,
              (index) {
                return GestureDetector(
                  onTap: () {
                    // Navigate to CategoryProductsScreen with the selected category
                    Navigator.pushNamed(
                      context,
                      '/categoryProducts',
                      arguments: categoryList[index]['title'], // Pass the category name
                    );
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: fixPadding * 1.5),
                    width: 110.0,
                    margin: const EdgeInsets.symmetric(horizontal: fixPadding),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          categoryList[index]['image'].toString(),
                          fit: BoxFit.cover,
                          height: 83.0,
                        ),
                        heightSpace,
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: fixPadding),
                          child: Text(
                            categoryList[index]['title'].toString(),
                            style: medium16Black,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }

  Widget recommendedForYou() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title("Recommended for You"),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(fixPadding),
          child: Row(
            children: List.generate(
              _recommendedList.length,
              (index) {
                final product = _recommendedList[index];
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
                    width: 158.0,
                    margin: const EdgeInsets.symmetric(horizontal: fixPadding),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: CachedNetworkImage(
                            imageUrl: imageUrl, // Use the constructed URL
                            height: 95.0,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const CircularProgressIndicator(),
                            errorWidget: (context, url, error) {
                              return const Icon(Icons.error); // Display an error icon
                            },
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
            ),
          ),
        )
      ],
    );
  }

  Widget popularListContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title("Popular"),
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
          itemCount: _popularList.length,
          itemBuilder: (context, index) {
            final product = _popularList[index];
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
                          imageUrl: imageUrl, // Use the constructed URL
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const CircularProgressIndicator(),
                          errorWidget: (context, url, error) {
                            return const Icon(Icons.error); // Display an error icon
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

  Widget title(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
      child: Text(
        title,
        style: semibold18Black,
      ),
    );
  }

  Widget posters() {
    return CarouselSlider(
      items: List.generate(
        posterList.length,
        (index) {
          return Container(
            width: double.maxFinite,
            clipBehavior: Clip.hardEdge,
            margin: const EdgeInsets.symmetric(horizontal: fixPadding * 0.5),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: AssetImage(
                  posterList[index]['image'].toString(),
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: whiteColor.withOpacity(0.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    posterList[index]['title'].toString(),
                    style: bold22White,
                    overflow: TextOverflow.ellipsis,
                  ),
                  heightSpace,
                  heightSpace,
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: fixPadding * 2.0,
                        vertical: fixPadding * 0.4),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: const Text(
                      "Get Now",
                      style: medium15Black,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
      options: CarouselOptions(
        height: 155.0,
        viewportFraction: 0.9,
      ),
    );
  }

  Widget header() {
    return Container(
      padding: const EdgeInsets.only(top: fixPadding),
      decoration: headerBoxDecoration,
      child: AppBar(
        automaticallyImplyLeading: false, // Remove the default back button
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        titleSpacing: 0.0,
        centerTitle: true,
        title: const Text(
          "Ghamloush Jewelry",
          style: semibold20Black,
        ),
        leading: IconButton(
          padding: const EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
          onPressed: _logout, // Trigger logout
          icon: const Icon(
            Icons.logout,
            size: 22.0,
          ),
        ),
        actions: [
          IconButton(
            padding: const EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BottomBar(index: 1),
                ),
              );
            },
            icon: const Iconify(
              Bx.search,
              size: 22.0,
            ),
          ),
        ],
      ),
    );
  }
}
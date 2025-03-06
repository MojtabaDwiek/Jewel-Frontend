import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bx.dart';
import 'package:pn_fl_jewellery_empire/app_config.dart';
import 'package:pn_fl_jewellery_empire/screens/bottom_bar.dart';
import 'package:pn_fl_jewellery_empire/theme/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pn_fl_jewellery_empire/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final poster = {
    "image": "assets/home/poster-image.png",
    "title": "Explore our Special Jewelry Collection",
  };

  final categoryList = [
    {"image": "assets/home/Jewelry-1.png", "title": "كسر شفت"},
    {"image": "assets/home/Jewelry-2.png", "title": "تعاليق"},
    {"image": "assets/home/Jewelry-3.png", "title": "غورميت"},
    {"image": "assets/home/Jewelry-4.png", "title": "فرنكات"},
    {"image": "assets/home/Jewelry-1.png", "title": "تركي"},
    {"image": "assets/home/Jewelry-2.png", "title": "ليزر"},
    {"image": "assets/home/Jewelry-3.png", "title": "خواتم"},
  ];

  List<dynamic> _popularList = [];
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final products = await ApiService.fetchProducts();
      if (mounted) {
        setState(() {
          _popularList = products;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to fetch products: $e';
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

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('token');
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Light grey background for the body
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bk.jpg"), // Background image
                fit: BoxFit.cover, // Cover the entire screen
              ),
            ),
          ),
          // Main Content
          Column(
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
                            onRefresh: _fetchProducts,
                            child: ListView(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.only(top: fixPadding * 2.0),
                              children: [
                                posterWidget(),
                                const SizedBox(height: 20),
                                categoryListContent(),
                                const SizedBox(height: 20),
                                popularListContent(),
                              ],
                            ),
                          ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget posterWidget() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/categoryProducts',
          arguments: "Special",
        );
      },
      child: Container(
        width: double.maxFinite,
        height: 155.0,
        margin: const EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
            image: AssetImage(poster['image'].toString()),
            fit: BoxFit.cover,
          ),
          border: Border.all(
            color: const Color(0xFFD4AF37), // Light gold color
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 2, 2, 2).withOpacity(0.4),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
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
                poster['title'].toString(),
                style: bold22White,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: fixPadding * 2.0, vertical: fixPadding * 0.4),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(
                    color: const Color(0xFFD4AF37), // Light gold color
                    width: 1.5,
                  ),
                ),
                child: const Text(
                  "Order Now",
                  style: medium15Black,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
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
                    Navigator.pushNamed(
                      context,
                      '/categoryProducts',
                      arguments: categoryList[index]['title'],
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
                      border: Border.all(
                        color: const Color(0xFFD4AF37), // Light gold color
                        width: 2.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 2, 2, 2).withOpacity(0.4),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          categoryList[index]['image'].toString(),
                          fit: BoxFit.cover,
                          height: 83.0,
                        ),
                        const SizedBox(height: 10),
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
            List<String> imageUrls = [];
            if (product['images'] != null && product['images'].isNotEmpty) {
              imageUrls = List<String>.from(product['images']);
            }
            String imageUrl = imageUrls.isNotEmpty
                ? '${AppConfig.imageBaseUrl}/${imageUrls[0]}' // Use the first image
                : AppConfig.fallbackImageUrl; // Fallback image

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
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: const Color(0xFFD4AF37), // Light gold color
                    width: 2.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 2, 2, 2).withOpacity(0.4),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
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
                          placeholder: (context, url) => const CircularProgressIndicator(),
                          errorWidget: (context, url, error) {
                            return const Icon(Icons.error);
                          },
                          memCacheHeight: 200,
                          memCacheWidth: 200,
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

  Widget header() {
    return Container(
      padding: const EdgeInsets.only(top: fixPadding),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/bk.jpg"), // Background image
          fit: BoxFit.cover, // Cover the entire header
        ),
        
      ),
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent, // Make AppBar transparent
        elevation: 0.0, // Remove shadow
        titleSpacing: 0.0,
        centerTitle: true,
        title: const Text(
          "Ghamloush Jewelry",
          style: semibold20Black,
        ),
        leading: IconButton(
          padding: const EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
          onPressed: _logout,
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
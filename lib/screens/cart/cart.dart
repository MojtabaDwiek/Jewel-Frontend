import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:iconify_flutter_plus/icons/uil.dart';
import 'package:pn_fl_jewellery_empire/theme/theme.dart';
import 'package:pn_fl_jewellery_empire/widget/column_builder.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:pn_fl_jewellery_empire/cart_provider.dart'; // Import CartProvider
import 'package:http/http.dart' as http; // For API calls
import 'package:url_launcher/url_launcher.dart'; // For opening WhatsApp
import 'dart:convert'; // For JSON parsing
import 'package:shared_preferences/shared_preferences.dart'; // For token storage

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Method to retrieve the token
  static Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Method to fetch the customer ID or retailer ID
  Future<String?> fetchUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final customerId = prefs.getString('customer_id');
    final retailerId = prefs.getString('retailer_id');

    // Return the appropriate ID
    return customerId ?? retailerId;
  }

  // Method to fetch retailer's phone number
  Future<String?> fetchRetailerPhone(String userId) async {
  const baseUrl = 'http://192.168.0.110:8000/api'; // Replace with your backend URL
  final url = Uri.parse('$baseUrl/customers/$userId/retailer-phone');

  // Debug: Log the constructed URL
  print('Debug: Constructed URL - $url');

  try {
    // Debug: Log the start of the HTTP request
    print('Debug: Making HTTP GET request to $url');

    final response = await http.get(url);

    // Debug: Log the response status code and body
    print('Debug: Response Status Code - ${response.statusCode}');
    print('Debug: Response Body - ${response.body}');

    if (response.statusCode == 200) {
      // Debug: Log the start of JSON decoding
      print('Debug: Decoding JSON response');

      final data = json.decode(response.body);

      // Debug: Log the decoded JSON data
      print('Debug: Decoded JSON Data - $data');

      // Check if the API call was successful
      if (data['success'] == true) {
        // Debug: Log successful retrieval of phone number
        print('Debug: Successfully retrieved retailer phone number');

        return data['data']['retailer_phone_number']; // Extract the phone number
      } else {
        // Debug: Log API error message
        print('Debug: API returned an error - ${data['message']}');

        throw Exception(data['message']); // Throw the error message from the API
      }
    } else if (response.statusCode == 404) {
      // Debug: Log HTTP error status code
      print('Debug: HTTP request failed with status code ${response.statusCode}');

      throw Exception('Retailer not found for this customer.');
    } else {
      // Debug: Log unexpected HTTP error
      print('Debug: Unexpected HTTP error - ${response.statusCode}');

      throw Exception('Failed to load retailer phone number: ${response.statusCode}');
    }
  } catch (e) {
    // Debug: Log any exceptions that occur
    print('Debug: Exception occurred - $e');

    throw Exception('An error occurred: $e');
  }
}

  // Method to open WhatsApp with Lebanon region formatting
  Future<void> openWhatsApp(String phoneNumber) async {
    // Format the phone number for Lebanon (add +961 prefix)
    final formattedPhoneNumber = phoneNumber.startsWith('+961')
        ? phoneNumber
        : '+961${phoneNumber.replaceAll(RegExp(r'[^0-9]'), '')}';

    final whatsappUrl = "https://wa.me/$formattedPhoneNumber";

    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      throw Exception('Could not launch WhatsApp');
    }
  }

  // Updated proceedToCheckout method
  Widget proceedToCheckout() {
    return GestureDetector(
      onTap: () async {
        try {
          // Fetch the user ID (customer_id or retailer_id)
          final userId = await fetchUserId();

          if (userId == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('User ID not found'),
              ),
            );
            return;
          }

          // Check if the user is a retailer
          final prefs = await SharedPreferences.getInstance();
          final retailerId = prefs.getString('retailer_id');

          if (retailerId != null) {
            // User is a retailer: Open a specified WhatsApp chat
            const supportPhoneNumber = '+96170764354'; // Replace with the support number
            await openWhatsApp(supportPhoneNumber);
          } else {
            // User is a customer: Fetch the retailer's phone number
            final phoneNumber = await fetchRetailerPhone(userId);

            if (phoneNumber != null) {
              // Open WhatsApp with the retailer's phone number
              await openWhatsApp(phoneNumber);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Retailer phone number not found'),
                ),
              );
            }
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: fixPadding * 2.0, vertical: fixPadding * 1.5),
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: blackColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        alignment: Alignment.center,
        child: const Text(
          "Proceed to Checkout",
          style: medium19White,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context); // Access CartProvider

    return Scaffold(
      body: Column(
        children: [
          header(),
          Expanded(
            child: cartProvider.cartItems.isEmpty
                ? emptyListContent()
                : ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(fixPadding * 2.0,
                        fixPadding, fixPadding * 2.0, fixPadding * 2.0),
                    children: [
                      cartItemListContent(cartProvider),
                      const SizedBox(height: 20), // Use SizedBox for spacing
                      const SizedBox(height: 20),
                      weightInfo(cartProvider), // Display total weight
                      const SizedBox(height: 20),
                      const SizedBox(height: 20),
                      proceedToCheckout(), // Updated button
                    ],
                  ),
          )
        ],
      ),
    );
  }

  Widget emptyListContent() {
    return Center(
      child: ListView(
        padding: const EdgeInsets.all(fixPadding * 2.0),
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        children: const [
          Iconify(
            Ph.handbag,
            size: 26.0,
            color: greyColor,
          ),
          SizedBox(height: 20),
          Text(
            "Cart is Empty",
            style: medium18Grey,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  Widget weightInfo(CartProvider cartProvider) {
    // Calculate total weight
    double totalWeight = cartProvider.cartItems.fold(
      0,
      (sum, item) => sum + (item.weight * item.quantity),
    );

    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(fixPadding),
        child: Row(
          children: [
            const Expanded(
              child: Text(
                "Total Weight",
                style: semibold16Black,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              "${totalWeight.toStringAsFixed(2)} g", // Display total weight
              style: semibold16Black,
            )
          ],
        ),
      ),
    );
  }

  Widget cartItemListContent(CartProvider cartProvider) {
    return ColumnBuilder(
      itemBuilder: (context, index) {
        final item = cartProvider.cartItems[index];

        // Base URL for images
        const baseUrl = 'http://192.168.0.110:8000/storage/'; // Replace with your actual server URL
        final imageUrl = item.imageUrl != null && item.imageUrl!.isNotEmpty
            ? '$baseUrl${item.imageUrl}' // Prepend the base URL to the image URL
            : 'https://example.com/fallback-image.jpg'; // Fallback image URL

        return Container(
          padding: const EdgeInsets.all(fixPadding),
          margin: const EdgeInsets.symmetric(vertical: fixPadding),
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              // Image part
              Container(
                padding: const EdgeInsets.all(fixPadding),
                height: 80.0,
                width: 85.0,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: blackColor.withOpacity(0.1),
                      blurRadius: 20.0,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: 85.0,
                    height: 80.0,
                    errorBuilder: (context, error, stackTrace) {
                      debugPrint("Error loading image: $error");
                      return const Icon(
                        Icons.shopping_bag, // Placeholder icon if image fails to load
                        size: 40.0,
                        color: greyColor,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name, // Use the name from CartItem
                                style: regular16Black,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 3),
                              // Display size only if it's not null
                              if (item.selectedSize != null)
                                Text(
                                  "Size: ${item.selectedSize}", // Use the size from CartItem
                                  style: regular14Grey,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              const SizedBox(height: 3),
                              // Display length only if it's not null
                              if (item.selectedLength != null)
                                Text(
                                  "Length: ${item.selectedLength}", // Use the length from CartItem
                                  style: regular14Grey,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              const SizedBox(height: 3),
                              Text(
                                "Weight: ${item.weight.toStringAsFixed(2)} g", // Use the weight from CartItem
                                style: regular14Grey,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 3),
                              // Display carat only if it's not null
                              Text(
                                "Carat: ${item.carat} ct", // Use the carat from CartItem
                                style: regular14Grey,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              addRemoveButton(Icons.remove, () {
                                if (item.quantity > 1) {
                                  cartProvider.updateQuantity(item, item.quantity - 1);
                                }
                              }),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: fixPadding * 1.5),
                                child: Text(
                                  item.quantity.toString(), // Use the quantity from CartItem
                                  style: bold14Black,
                                ),
                              ),
                              addRemoveButton(Icons.add, () {
                                cartProvider.updateQuantity(item, item.quantity + 1);
                              }),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            cartProvider.removeFromCart(item);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: blackColor,
                                duration: Duration(milliseconds: 1500),
                                behavior: SnackBarBehavior.floating,
                                content: Text(
                                  "Removed from shopping cart",
                                  style: medium16White,
                                ),
                              ),
                            );
                          },
                          child: const Iconify(
                            Uil.trash_alt,
                            size: 22.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      itemCount: cartProvider.cartItems.length,
    );
  }

  Widget addRemoveButton(IconData icon, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 26.0,
        width: 26.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(color: borderColor)),
        alignment: Alignment.center,
        child: Icon(
          icon,
          color: blackColor,
          size: 18.0,
        ),
      ),
    );
  }

  Widget header() {
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
          "Shopping Cart",
          style: semibold20Black,
        ),
      ),
    );
  }
}
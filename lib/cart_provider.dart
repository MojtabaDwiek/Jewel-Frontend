import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'Models/CartItem.dart'; // Import CartItem model

class CartProvider with ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  // Add a product to the cart
  void addToCart(CartItem item) {
    // Check if the item already exists in the cart
    final existingItem = _cartItems.firstWhere(
      (cartItem) =>
          cartItem.id == item.id &&
          cartItem.selectedSize == item.selectedSize &&
          cartItem.selectedLength == item.selectedLength &&
          cartItem.carat == item.carat &&
          cartItem.note == item.note, // Include note in the comparison
      orElse: () => CartItem(
        id: '',
        name: '',
        category: '',
        weight: 0,
        selectedSize: '',
        selectedLength: '',
        carat: item.carat, // Include carat here
        imageUrl: item.imageUrl, // Include imageUrl (nullable)
        note: item.note, // Include note (nullable)
        quantity: 0,
      ),
    );

    if (existingItem.id.isNotEmpty) {
      // If it exists, update the quantity
      existingItem.quantity += item.quantity;
    } else {
      // Otherwise, add a new item with the provided carat, imageUrl, and note
      _cartItems.add(item);
    }

    notifyListeners();
  }

  // Remove a product from the cart
  void removeFromCart(CartItem item) {
    _cartItems.remove(item);
    notifyListeners();
  }

  // Update the quantity of a product in the cart
  void updateQuantity(CartItem item, int newQuantity) {
    if (newQuantity > 0) {
      item.quantity = newQuantity;
    } else {
      // If the quantity is 0 or less, remove the item from the cart
      _cartItems.remove(item);
    }
    notifyListeners();
  }

  // Clear the entire cart
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // Calculate the total number of items in the cart
  int get totalItems {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  // Generate a checkout message including item details
  String generateCheckoutMessage() {
    StringBuffer message = StringBuffer();

    // Add a header for the order details
    message.writeln("Ghamloush Jewelry");
    message.writeln("====================");
    message.writeln();

    // Calculate total weight
    double totalWeight = _cartItems.fold(
      0,
      (sum, item) => sum + (item.weight * item.quantity),
    );

    // Add a header for the order summary
    message.writeln("📦 Order Summary");
    message.writeln("---------------------");

    // Loop through each item in the cart
    for (var item in _cartItems) {
      message.writeln("🔹 Product: ${item.name}");
      message.writeln("   - Category: ${item.category}");
      message.writeln("   - Weight: ${item.weight}g");
      if (item.selectedSize != null) {
        message.writeln("   - Size: ${item.selectedSize}");
      }
      if (item.selectedLength != null) {
        message.writeln("   - Length: ${item.selectedLength}");
      }
      if (item.carat != null) {
        message.writeln("   - Carat: ${item.carat} ct");
      }
      if (item.note != null && item.note!.isNotEmpty) {
        message.writeln("   - Note: ${item.note}");
      }
      message.writeln("   - Quantity: ${item.quantity}");
      message.writeln("   - Image: See attached image for this product.");
      message.writeln("---------------------");
    }

    // Add a footer with totals and a thank-you message
    message.writeln("📊 Order Totals");
    message.writeln("---------------------");
    message.writeln("   - Total Items: $totalItems");
    message.writeln("   - Total Weight: ${totalWeight.toStringAsFixed(2)}g");
    message.writeln();
    message.writeln("Thank you for choosing us! 🙏");

    return message.toString();
  }

  // Share the cart details with the first image of each cart item
  Future<void> shareCartWithImages() async {
    try {
      // Generate the message
      final message = generateCheckoutMessage();

      // Prepare a list of XFiles for the first image of each cart item
      List<XFile> imageFiles = [];

      for (var item in _cartItems) {
        if (item.imageUrl != null && item.imageUrl!.isNotEmpty) {
          // Construct the full image URL
          const baseUrl = 'http://192.168.0.110:8000/storage/'; // Replace with your server URL
          final fullImageUrl = '$baseUrl${item.imageUrl}';

          // Download the first image from the URL
          final response = await http.get(Uri.parse(fullImageUrl));
          if (response.statusCode == 200) {
            final tempDir = await getTemporaryDirectory();
            final file = File('${tempDir.path}/${item.id}.jpg');
            await file.writeAsBytes(response.bodyBytes);

            // Add the image file to the list
            imageFiles.add(XFile(file.path));

            // Break after processing the first image for this item
            break;
          }
        }
      }

      // Create a text file with the message
      final tempDir = await getTemporaryDirectory();
      final textFile = File('${tempDir.path}/order_summary.txt');
      await textFile.writeAsString(message);

      // Add the text file to the list of files
      imageFiles.add(XFile(textFile.path));

      // Share the files (images and text file)
      await Share.shareXFiles(imageFiles);
    } catch (e) {
      // Handle any errors
      print("Error sharing cart: $e");
    }
  }
}
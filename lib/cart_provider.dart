import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'Models/CartItem.dart'; // Import CartItem model
import 'app_config.dart'; // Import AppConfig

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

  // Generate a checkout message including item details and image URLs
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

      // Add the image URL under each item
      if (item.imageUrl != null && item.imageUrl!.isNotEmpty) {
        final fullImageUrl = '${AppConfig.imageBaseUrl}/${item.imageUrl}';
        message.writeln("   - Image: $fullImageUrl");
      } else {
        message.writeln("   - Image: No image available");
      }
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

  // Share the cart details with image URLs included in the message
  Future<void> shareCartWithImages() async {
    try {
      // Generate the message (which now includes image URLs)
      final message = generateCheckoutMessage();

      // Share the message
      await Share.share(message);
    } catch (e) {
      // Handle any errors
      print("Error sharing cart: $e");
    }
  }
}
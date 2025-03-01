import 'package:flutter/material.dart';
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

  // Generate a checkout message including item details and images
  String generateCheckoutMessage() {
  StringBuffer message = StringBuffer();
  message.writeln("Your order details:");
  message.writeln("====================");

  // Calculate total weight
  double totalWeight = _cartItems.fold(
    0,
    (sum, item) => sum + (item.weight * item.quantity),
  );

  for (var item in _cartItems) {
    message.writeln("Product: ${item.name}");
    message.writeln("Category: ${item.category}");
    message.writeln("Weight: ${item.weight}g");
    message.writeln("Size: ${item.selectedSize}");
    message.writeln("Length: ${item.selectedLength}");
    message.writeln("Carat: ${item.carat}");
    message.writeln("Note: ${item.note ?? 'No note'}");
    message.writeln("Quantity: ${item.quantity}");
    message.writeln("---------------------");
  }

  message.writeln("Total Items: $totalItems");
  message.writeln("Total Weight: ${totalWeight.toStringAsFixed(2)}g"); // Add total weight
  message.writeln("====================");
  message.writeln("Thank you for shopping with us!");

  return message.toString();
}
}
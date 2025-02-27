import 'package:flutter/material.dart';
import 'Models/CartItem.dart'; // Import CartItem model

class CartProvider with ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  // Modify the addToCart method to include carat and handle nullable imageUrl
  void addToCart(CartItem item) {
    // Check if the item already exists in the cart
    final existingItem = _cartItems.firstWhere(
      (cartItem) =>
          cartItem.id == item.id &&
          cartItem.selectedSize == item.selectedSize &&
          cartItem.selectedLength == item.selectedLength &&
          cartItem.carat == item.carat, // Include carat in the comparison
      orElse: () => CartItem(
        id: '',
        name: '',
        category: '',
        weight: 0,
        selectedSize: '',
        selectedLength: '',
        carat: item.carat, // Include carat here
        imageUrl: item.imageUrl, // Include imageUrl (nullable)
        quantity: 0,
      ),
    );

    if (existingItem.id.isNotEmpty) {
      // If it exists, update the quantity
      existingItem.quantity += item.quantity;
    } else {
      // Otherwise, add a new item with the provided carat and imageUrl
      _cartItems.add(item);
    }

    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _cartItems.remove(item);
    notifyListeners();
  }

  void updateQuantity(CartItem item, int newQuantity) {
    item.quantity = newQuantity;
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
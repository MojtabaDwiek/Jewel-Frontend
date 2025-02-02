class CartItem {
  final String id; // Product ID
  final String name; // Product name
  final String category; // Product category
  final double weight; // Product weight
  final String selectedSize; // Selected size
  final String selectedLength; // Selected length
  final String imageUrl; // Image URL for the product
  int quantity; // Quantity of the product

  CartItem({
    required this.id,
    required this.name,
    required this.category,
    required this.weight,
    required this.selectedSize,
    required this.selectedLength,
    required this.imageUrl, // Adding image URL to the constructor
    this.quantity = 1, // Default quantity is 1
  });
}

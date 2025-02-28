class CartItem {
  final String id; // Product ID (non-nullable)
  final String name; // Product name (non-nullable)
  final String category; // Product category (non-nullable)
  final double weight; // Product weight (non-nullable)
  final String? selectedSize; // Selected size (nullable)
  final String? selectedLength; // Selected length (nullable)
  final double? carat; // Carat value (nullable)
  final String? imageUrl; // Image URL for the product (nullable)
  final String? note; // Optional note for the product (nullable)
  int quantity; // Quantity of the product (non-nullable, default is 1)

  CartItem({
    required this.id,
    required this.name,
    required this.category,
    required this.weight,
    this.selectedSize, // Nullable size
    this.selectedLength, // Nullable length
    this.carat, // Nullable carat
    this.imageUrl, // Nullable image URL
    this.note, // Nullable note
    this.quantity = 1, // Default quantity is 1
  });
}
class Product {
  final int id;
  final String name;
  final List<String> sizes;
  final List<String> lengths;
  final String weight;
  final String image;
  final String category;
  final double price;

  Product({
    required this.id,
    required this.name,
    required this.sizes,
    required this.lengths,
    required this.weight,
    required this.image,
    required this.category,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      sizes: List<String>.from(json['sizes']),
      lengths: List<String>.from(json['lengths']),
      weight: json['weight'],
      image: json['image'],
      category: json['category'],
      price: double.parse(json['price'].toString()),
    );
  }
}
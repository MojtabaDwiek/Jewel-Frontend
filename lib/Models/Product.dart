class Product {
  final int id;
  final String name;
  final List<String> sizes;
  final List<String> lengths;
  final String weight;
  final List<String> images; // Multiple images field
  final String category;
  final double carat;

  Product({
    required this.id,
    required this.name,
    required this.sizes,
    required this.lengths,
    required this.weight,
    required this.images, // List of images
    required this.category,
    required this.carat,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      sizes: json['sizes'] != null ? List<String>.from(json['sizes']) : [],
      lengths: json['lengths'] != null ? List<String>.from(json['lengths']) : [],
      weight: json['weight'] ?? '', 
      images: json['images'] != null ? List<String>.from(json['images']) : [], // Parse images as list of strings
      category: json['category'] ?? '',
      
      carat: double.tryParse(json['carat'].toString()) ?? 0.0,
    );
  }
}

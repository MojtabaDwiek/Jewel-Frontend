import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://192.168.0.104:8000/api'; // Use HTTP for local development

  // Generic login method
  static Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      // Handle different status codes
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception('Invalid credentials');
      } else {
        throw Exception('Failed to login: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Fetch all products
  static Future<List<dynamic>> fetchProducts() async {
    final url = Uri.parse('$baseUrl/products'); // Endpoint to fetch products
    try {
      final response = await http.get(url);

      // Handle different status codes
      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Return the list of products
      } else {
        throw Exception('Failed to fetch products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Fetch a single product by ID
 static Future<Map<String, dynamic>> fetchProductDetails(int productId) async {
  final url = Uri.parse('$baseUrl/products/$productId');
  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> product = jsonDecode(response.body);

      // Decode sizes and lengths from JSON-encoded strings
      product['sizes'] = jsonDecode(product['sizes']) as List<dynamic>;
      product['lengths'] = jsonDecode(product['lengths']) as List<dynamic>;

      return product;
    } else if (response.statusCode == 404) {
      throw Exception('Product not found');
    } else {
      throw Exception('Failed to fetch product: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Network error: $e');
  }
}
}
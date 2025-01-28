import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.0.104:8000/api'; // Use HTTP for local development

 static Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Save token and user data to SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', data['token']);
        prefs.setString('user', jsonEncode(data['user']));

        print('Login successful: ${data['message']}');

        // Return the token and user data as a map
        return {
          'token': data['token'],
          'user': data['user'],
        };
      } else {
        print('Login failed: ${data['message']}');
        throw Exception(data['message']);
      }
    } catch (error) {
      print('Login error: $error');
      rethrow; // Re-throw the error so that it can be handled in the UI
    }
  }

  static Future<void> logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('No token found');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {'Authorization': 'Bearer $token'},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Clear token and user data from SharedPreferences
        prefs.remove('token');
        prefs.remove('user');

        print('Logout successful: ${data['message']}');
      } else {
        print('Logout failed: ${data['message']}');
        throw Exception(data['message']);
      }
    } catch (error) {
      print('Logout error: $error');
      throw error;
    }
  }

  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') != null;
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
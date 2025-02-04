import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.0.104:8000/api'; // Use HTTP for local development

  // Helper method to get the token from SharedPreferences
  static Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Login
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


        // Return the token and user data as a map
        return {
          'token': data['token'],
          'user': data['user'],
        };
      } else {
        throw Exception(data['message']);
      }
    } catch (error) {
      rethrow; // Re-throw the error so that it can be handled in the UI
    }
  }

  // Logout
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

      } else {
        throw Exception(data['message']);
      }
    } catch (error) {
      rethrow;
    }
  }

  // Check if the user is logged in
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

  // Add a product to favorites
  static Future<void> addToFavorites(int productId) async {
  try {
    final token = await _getToken();
    
    // Ensure token is valid
    if (token == null) {
      throw Exception('User not logged in');
    }

    // Log the token to ensure it's correctly retrieved (for debugging)

    // Create the request body and log it
    final body = jsonEncode({'product_id': productId});

    final response = await http.post(
      Uri.parse('$baseUrl/favorites/add'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    // Check the response and log details
    
    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to add product to favorites: ${response.statusCode}');
    }
  } catch (e) {
    // Log the error for debugging
    throw Exception('Error adding to favorites: $e');
  }
}


  // Remove a product from favorites
  static Future<void> removeFromFavorites(int productId) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('User not logged in');
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/favorites/remove/$productId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
      } else {
        throw Exception('Failed to remove product from favorites: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error removing from favorites: $e');
    }
  }

  // View all favorite products
  // View all favorite products
static Future<List<dynamic>> viewFavorites() async {
  final token = await _getToken();
  if (token == null) {
    throw Exception('User not logged in');
  }

  final url = Uri.parse('$baseUrl/favorites'); // Endpoint to fetch favorite products
  try {
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    // Handle response
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Assuming the response contains a 'favorites' key with a list of products
      return data['favorites'] as List<dynamic>;
    } else {
      throw Exception('Failed to fetch favorites: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching favorites: $e');
  }
}

}
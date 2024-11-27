import 'package:http/http.dart' as http;
import 'dart:convert';

class SubscriptionApiService {
  static const String baseUrl = 'http://bgoodserver.xyz:8001';

  static Future<http.Response> checkSubscriptionStatus(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/subscription/check_status'),
        headers: {
          'accept': 'application/json',
          'authorization': token,
        },
      );
      return response;
    } catch (e) {
      throw Exception('API request failed: $e');
    }
  }

  static Future<http.Response> getCategories(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/subscription/category'),
        headers: {
          'accept': 'application/json',
          'authorization': token,
        },
      );
      return response;
    } catch (e) {
      throw Exception('API request failed: $e');
    }
  }

  static Future<Map<String, dynamic>> createSubscription(String token, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/subscription/waiting'),
        headers: {
          'accept': 'application/json',
          'authorization': token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData;
      } else {
        final responseBody = utf8.decode(response.bodyBytes);
        throw Exception('Failed to create subscription: ${response.statusCode}\n$responseBody');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  static Future<http.Response> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/subscription/product'),
        headers: {
          'accept': 'application/json',
        },
      );
      return response;
    } catch (e) {
      throw Exception('API request failed: $e');
    }
  }

  static Future<http.Response> getCategoryList(String mode) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/subscription/category_list_new?level_1=$mode'),
        headers: {
          'accept': 'application/json',
        },
      );
      return response;
    } catch (e) {
      throw Exception('API request failed: $e');
    }
  }

  static Future<http.Response> getLandingData(String token, String level1) async {
    try {
      final encodedLevel1 = Uri.encodeComponent(level1);
      final response = await http.get(
        Uri.parse('$baseUrl/subscription/landing?level_1=$encodedLevel1&sort=created_at&order=desc'),
        headers: {
          'accept': 'application/json',
          'authorization': token,
        },
      );
      return response;
    } catch (e) {
      throw Exception('API request failed: $e');
    }
  }

  static Future<void> updateSubscription(String token, Map<String, dynamic> data) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/subscription/waiting'),
        headers: {
          'accept': 'application/json',
          'authorization': token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update subscription');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> cancelSubscription(String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/subscription/cancel'),
        headers: {
          'accept': 'application/json',
          'authorization': token,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to cancel subscription: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('API request failed: $e');
    }
  }
}
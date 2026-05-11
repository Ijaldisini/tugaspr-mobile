import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';

class ApiService {
  final String baseUrl = 'https://task.itprojects.web.id';

  Future<bool> login(String nim, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/login');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'username': nim, 'password': password}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final authData = AuthResponse.fromJson(data['data']);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', authData.token);
        return true;
      }
    } catch (e) {
      print('Error Login: $e');
    }
    return false;
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<List<ProductModel>> getProducts() async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/api/products');

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('--- GET PRODUCTS RESPONS ---');
      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        List productsJson = [];

        if (decodedResponse['data'] is List) {
          productsJson = decodedResponse['data'];
        } else if (decodedResponse['data'] is Map &&
            decodedResponse['data']['products'] != null) {
          productsJson = decodedResponse['data']['products'];
        } else if (decodedResponse['products'] is List) {
          productsJson = decodedResponse['products'];
        }

        return productsJson.map((json) => ProductModel.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error saat getProducts: $e');
    }
    return [];
  }

  Future<bool> addDraftProduct(ProductModel product) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/api/products');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(product.toJson()),
      );

      print('--- ADD DRAFT RESPONS ---');
      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error saat addDraftProduct: $e');
      return false;
    }
  }

  Future<bool> submitTugas(
    String name,
    int price,
    String description,
    String githubUrl,
  ) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/api/products/submit');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'price': price,
        'description': description,
        'github_url': githubUrl,
      }),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/config.dart';
import '../../../../core/network/logging_http_client.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../data/models/cart_item_model.dart';

class CartRepositoryImpl implements CartRepository {
  final http.Client client;

  CartRepositoryImpl({http.Client? client}) : client = client ?? LoggingHttpClient();

  List<CartItemModel> _parseCartResponse(String body) {
    final Map<String, dynamic> data = json.decode(body);
    final List<dynamic> itemsData = data['items'] ?? [];
    return itemsData.map((item) => CartItemModel.fromJson(item as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<CartItemModel>> fetchCart(String token) async {
    final url = Uri.parse('${Config.baseUrl}/api/cart/');
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return _parseCartResponse(response.body);
    } else {
      throw Exception('Failed to fetch cart. Error: ${response.body}');
    }
  }

  @override
  Future<List<CartItemModel>> addToCart(int productId, int quantity, String token) async {
    final url = Uri.parse('${Config.baseUrl}/api/cart/add/');
    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'product_id': productId,
        'quantity': quantity,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return _parseCartResponse(response.body);
    } else {
      throw Exception('Failed to add to cart. Error: ${response.body}');
    }
  }

  @override
  Future<List<CartItemModel>> removeFromCart(int productId, String token) async {
    final url = Uri.parse('${Config.baseUrl}/api/cart/delete/');
    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'product_id': productId,
      }),
    );

    if (response.statusCode == 200) {
      return _parseCartResponse(response.body);
    } else {
      throw Exception('Failed to remove from cart. Error: ${response.body}');
    }
  }

  @override
  Future<List<CartItemModel>> updateCartQuantity(int productId, int quantity, String token) async {
    final url = Uri.parse('${Config.baseUrl}/api/cart/update/');
    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'product_id': productId,
        'quantity': quantity,
      }),
    );

    if (response.statusCode == 200) {
      return _parseCartResponse(response.body);
    } else {
      throw Exception('Failed to update cart quantity. Error: ${response.body}');
    }
  }

  @override
  Future<double> fetchCartTotal(String token) async {
    final url = Uri.parse('${Config.baseUrl}/api/cart/total/');
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return double.tryParse(data['total'].toString()) ?? 0.0;
    } else {
      throw Exception('Failed to fetch cart total. Error: ${response.body}');
    }
  }
}

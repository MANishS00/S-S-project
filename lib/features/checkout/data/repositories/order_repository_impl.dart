import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/config.dart';
import '../../../../core/network/logging_http_client.dart';
import '../../domain/repositories/order_repository.dart';
import '../models/order_history_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final http.Client client;

  OrderRepositoryImpl({http.Client? client}) : client = client ?? LoggingHttpClient();

  @override
  Future<void> createOrder({
    required int userId,
    required String fullName,
    required String email,
    required double amountPaid,
    required Map<String, dynamic> shippingAddress,
    required List<Map<String, dynamic>> items,
  }) async {
    final url = Uri.parse('${Config.baseUrl}/api/create_order/');

    final body = jsonEncode({
      'user_id': userId,
      'full_name': fullName,
      'email': email,
      'amount_paid': amountPaid,
      'shipping_address': shippingAddress,
      'items': items,
    });

    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create order. Status: ${response.statusCode}');
    }
  }

  @override
  Future<List<OrderHistoryModel>> fetchOrderHistory(String token) async {
    final url = Uri.parse('${Config.baseUrl}/api/orders/history/');
    final response = await client.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final dynamic decoded = json.decode(response.body);
      List<dynamic> list;
      if (decoded is Map) {
        list = decoded['results'] ?? [];
      } else if (decoded is List) {
        list = decoded;
      } else {
        list = [];
      }
      return list.map((e) => OrderHistoryModel.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load order history: ${response.body}');
    }
  }
}

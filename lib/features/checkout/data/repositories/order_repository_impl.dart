import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/config.dart';
import '../../../../core/network/logging_http_client.dart';
import '../../domain/repositories/order_repository.dart';

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
}

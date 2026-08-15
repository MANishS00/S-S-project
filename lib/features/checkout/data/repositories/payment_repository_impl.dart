import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/config.dart';
import '../../../../core/network/logging_http_client.dart';
import '../../domain/repositories/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final http.Client client;

  PaymentRepositoryImpl({http.Client? client}) : client = client ?? LoggingHttpClient();

  @override
  Future<Map<String, dynamic>> initiatePayment(
    double totalAmount,
    List<Map<String, dynamic>> cartItems,
  ) async {
    final String initiatePaymentUrl = '${AppConfig.baseUrl}/payment/process/';

    final response = await client.post(
      Uri.parse(initiatePaymentUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'totalAmount': totalAmount,
        'cartItems': cartItems,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to initiate payment. Status: ${response.statusCode}');
    }
  }

  @override
  Future<void> executePayment(String paymentId, String payerId) async {
    final String executePaymentUrl =
        '${AppConfig.baseUrl}/payment/execute/?paymentId=$paymentId&PayerID=$payerId';

    final response = await client.get(Uri.parse(executePaymentUrl));

    if (response.statusCode != 200) {
      throw Exception('Failed to execute payment. Status: ${response.statusCode}');
    }
  }
}

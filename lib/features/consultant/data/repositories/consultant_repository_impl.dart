import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/config.dart';
import '../../../../core/network/logging_http_client.dart';
import '../../domain/repositories/consultant_repository.dart';

class ConsultantRepositoryImpl implements ConsultantRepository {
  final http.Client client;

  ConsultantRepositoryImpl({http.Client? client}) : client = client ?? LoggingHttpClient();

  @override
  Future<void> submitConsultantRequest({
    required String name,
    required String productService,
    required String mobileNumber,
    required String email,
    required String message,
  }) async {
    final url = Uri.parse('${AppConfig.baseUrl}/api/consultant/request/');
    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'person_name': name,
        'product_service': productService,
        'mobile_number': mobileNumber,
        'email': email,
        'message': message,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to submit consultant request: ${response.body}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> fetchConsultantRequests(String token) async {
    final url = Uri.parse('${AppConfig.baseUrl}/api/consultant/requests/');
    final response = await client.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to fetch consultant requests: ${response.body}');
    }
  }
}

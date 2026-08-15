import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/config.dart';
import '../../../../core/network/logging_http_client.dart';
import '../../domain/repositories/shipping_address_repository.dart';
import '../models/shipping_address_model.dart';

class ShippingAddressRepositoryImpl implements ShippingAddressRepository {
  final http.Client client;

  ShippingAddressRepositoryImpl({http.Client? client}) : client = client ?? LoggingHttpClient();

  @override
  Future<ShippingAddressModel?> fetchShippingAddress(String token) async {
    final url = Uri.parse('${AppConfig.baseUrl}/api/shipping-address/me/');
    final response = await client.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data != null && (data is Map && data.isNotEmpty)) {
        return ShippingAddressModel.fromJson(data.cast<String, dynamic>());
      }
      return null;
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to fetch shipping address. Status: ${response.statusCode}');
    }
  }

  @override
  Future<void> createOrUpdateShippingAddress(
    String token, {
    String? phone,
    String? fullName,
    String? email,
    String? address1,
    String? address2,
    String? city,
    String? state,
    String? zipcode,
    String? country,
  }) async {
    final url = Uri.parse('${AppConfig.baseUrl}/api/shipping-address/me/');
    final response = await client.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'phone': phone,
        'full_name': fullName,
        'email': email,
        'address1': address1,
        'address2': address2,
        'city': city,
        'state': state,
        'zipcode': zipcode,
        'country': country,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to update or create shipping address: ${response.body}');
    }
  }
}

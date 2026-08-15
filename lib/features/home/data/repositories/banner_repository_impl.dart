import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/config.dart';
import '../../../../core/network/logging_http_client.dart';
import '../../domain/repositories/banner_repository.dart';
import '../models/banner_model.dart';

class BannerRepositoryImpl implements BannerRepository {
  final http.Client client;

  BannerRepositoryImpl({http.Client? client}) : client = client ?? LoggingHttpClient();

  @override
  Future<List<BannerModel>> fetchBanners() async {
    final url = Uri.parse('${AppConfig.baseUrl}/api/banners/');
    final response = await client.get(url);

    if (response.statusCode == 200) {
      final dynamic decoded = jsonDecode(response.body);
      final List<dynamic> data = (decoded is Map) ? (decoded['results'] ?? []) : decoded;
      return data.map((item) => BannerModel.fromJson(item as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load banners');
    }
  }
}

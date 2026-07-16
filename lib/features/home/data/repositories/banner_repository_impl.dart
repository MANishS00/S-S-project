import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/config.dart';
import '../../domain/repositories/banner_repository.dart';
import '../models/banner_model.dart';

class BannerRepositoryImpl implements BannerRepository {
  final http.Client client;

  BannerRepositoryImpl({http.Client? client}) : client = client ?? http.Client();

  @override
  Future<List<BannerModel>> fetchBanners() async {
    final url = Uri.parse('${Config.baseUrl}/api/banners/');
    final response = await client.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => BannerModel.fromJson(item as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load banners');
    }
  }
}

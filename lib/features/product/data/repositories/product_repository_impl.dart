import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/config.dart';
import '../../domain/repositories/product_repository.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final http.Client client;

  ProductRepositoryImpl({http.Client? client}) : client = client ?? http.Client();

  @override
  Future<List<ProductModel>> fetchProducts() async {
    final url = Uri.parse('${Config.baseUrl}/api/products/');
    final response = await client.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> productData = data['results'] ?? [];
      return productData
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Future<List<ProductModel>> fetchProductsByCategory(int categoryId) async {
    final url = Uri.parse('${Config.baseUrl}/api/products/?category=$categoryId');
    final response = await client.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> productData = json.decode(response.body);
      return productData
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load products by category');
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/config.dart';
import '../../../../core/network/logging_http_client.dart';
import '../../domain/repositories/product_repository.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final http.Client client;

  ProductRepositoryImpl({http.Client? client})
      : client = client ?? LoggingHttpClient();

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
    final url =
        Uri.parse('${Config.baseUrl}/api/products/?category=$categoryId');
    final response = await client.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> productData = data['results'] ?? [];
      return productData
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load products by category');
    }
  }

  Future<List<ProductModel>> _fetchProductsFromUrl(
      Uri url, String errorMessage) async {
    final response = await client.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> productData = data['results'] ?? [];
      return productData
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(errorMessage);
    }
  }

  @override
  Future<List<ProductModel>> fetchFeaturedProducts() async {
    final url = Uri.parse('${Config.baseUrl}/api/products/featured/');
    return _fetchProductsFromUrl(url, 'Failed to load featured products');
  }

  @override
  Future<List<ProductModel>> fetchRecentProducts() async {
    final url = Uri.parse('${Config.baseUrl}/api/products/recent/');
    return _fetchProductsFromUrl(url, 'Failed to load recent products');
  }

  @override
  Future<List<ProductModel>> fetchSaleProducts() async {
    final url = Uri.parse('${Config.baseUrl}/api/products/sale/');
    return _fetchProductsFromUrl(url, 'Failed to load sale products');
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    final url = Uri.parse(
        '${Config.baseUrl}/api/products/search/?query=${Uri.encodeComponent(query)}');
    return _fetchProductsFromUrl(url, 'Failed to search products');
  }
}

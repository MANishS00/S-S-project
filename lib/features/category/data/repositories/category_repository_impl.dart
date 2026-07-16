import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/config.dart';
import '../../domain/repositories/category_repository.dart';
import '../models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final http.Client client;

  CategoryRepositoryImpl({http.Client? client}) : client = client ?? http.Client();

  @override
  Future<List<CategoryModel>> fetchCategories() async {
    final url = Uri.parse('${Config.baseUrl}/api/categories/');
    final response = await client.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List<dynamic> categoryData = jsonData['results'] ?? [];
      return categoryData
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}

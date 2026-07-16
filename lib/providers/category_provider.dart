// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart';
import '../models/category.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [];
  bool _isLoading = false;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;

  Future<void> fetchCategories() async {
  _isLoading = true;
  notifyListeners();

  final url = Uri.parse('${Config.baseUrl}/api/categories/');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);

      final List<dynamic> categoryData = jsonData['results'];

      _categories = categoryData
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load categories');
    }
  } catch (e) {
    print('Error fetching categories: $e');
    rethrow;
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}
}

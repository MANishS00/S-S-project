import 'package:flutter/material.dart';
import '../../data/models/category_model.dart';
import '../../domain/repositories/category_repository.dart';
import '../../data/repositories/category_repository_impl.dart';

class CategoryViewModel with ChangeNotifier {
  final CategoryRepository _repository;

  List<CategoryModel> _categories = [];
  bool _isLoading = false;

  CategoryViewModel({CategoryRepository? repository})
      : _repository = repository ?? CategoryRepositoryImpl();

  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;

  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();
    try {
      _categories = await _repository.fetchCategories();
    } catch (e) {
      // rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

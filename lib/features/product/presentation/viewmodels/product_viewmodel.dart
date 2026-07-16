import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';
import '../../domain/repositories/product_repository.dart';
import '../../data/repositories/product_repository_impl.dart';

class ProductViewModel with ChangeNotifier {
  final ProductRepository _repository;

  List<ProductModel> _products = [];
  bool _isLoading = false;

  ProductViewModel({ProductRepository? repository})
      : _repository = repository ?? ProductRepositoryImpl();

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();
    try {
      _products = await _repository.fetchProducts();
    } catch (e) {
      // rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProductsByCategory(int categoryId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _products = await _repository.fetchProductsByCategory(categoryId);
    } catch (e) {
      // rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

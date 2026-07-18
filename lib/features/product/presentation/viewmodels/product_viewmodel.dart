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

  List<ProductModel> _searchResults = [];
  List<ProductModel> get searchResults => _searchResults;

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

  Future<void> fetchFeaturedProducts() async {
    _isLoading = true;
    notifyListeners();
    try {
      _products = await _repository.fetchFeaturedProducts();
    } catch (_) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchRecentProducts() async {
    _isLoading = true;
    notifyListeners();
    try {
      _products = await _repository.fetchRecentProducts();
    } catch (_) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSaleProducts() async {
    _isLoading = true;
    notifyListeners();
    try {
      _products = await _repository.fetchSaleProducts();
    } catch (_) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchProducts(String query) async {
    _isLoading = true;
    notifyListeners();
    try {
      _searchResults = await _repository.searchProducts(query);
    } catch (_) {
      _searchResults = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

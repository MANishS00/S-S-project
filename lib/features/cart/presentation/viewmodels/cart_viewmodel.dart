import 'package:flutter/material.dart';
import '../../../product/data/models/product_model.dart';
import '../../data/models/cart_item_model.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../data/repositories/cart_repository_impl.dart';
import '../../../../core/utils/token_helper.dart';

class CartViewModel with ChangeNotifier {
  final CartRepository _cartRepository;
  final Map<int, CartItemModel> _cartItems = {};
  bool _isLoading = false;
  double _remoteTotal = 0.0;

  CartViewModel({CartRepository? cartRepository})
      : _cartRepository = cartRepository ?? CartRepositoryImpl();

  Map<int, CartItemModel> get cartItems => _cartItems;
  bool get isLoading => _isLoading;

  Future<void> fetchCart() async {
    final token = await TokenHelper.getValidToken();
    if (token == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final items = await _cartRepository.fetchCart(token);
      _cartItems.clear();
      for (var item in items) {
        _cartItems[item.product.id] = item;
      }
      _remoteTotal = await _cartRepository.fetchCartTotal(token);
    } catch (_) {
      // Keep local items on error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addToCart(ProductModel product, int quantity) async {
    final token = await TokenHelper.getValidToken();
    if (token != null) {
      _isLoading = true;
      notifyListeners();
      try {
        final items = await _cartRepository.addToCart(product.id, quantity, token);
        _cartItems.clear();
        for (var item in items) {
          _cartItems[item.product.id] = item;
        }
        _remoteTotal = await _cartRepository.fetchCartTotal(token);
      } catch (_) {
        _localAdd(product, quantity);
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    } else {
      _localAdd(product, quantity);
      notifyListeners();
    }
  }

  void _localAdd(ProductModel product, int quantity) {
    if (_cartItems.containsKey(product.id)) {
      if (_cartItems[product.id]!.quantity + quantity <= product.stockQuantity) {
        _cartItems[product.id]!.quantity += quantity;
      } else {
        _cartItems[product.id]!.quantity = product.stockQuantity;
      }
    } else {
      if (quantity <= product.stockQuantity) {
        _cartItems[product.id] = CartItemModel(product: product, quantity: quantity);
      } else {
        _cartItems[product.id] = CartItemModel(product: product, quantity: product.stockQuantity);
      }
    }
  }

  Future<void> removeFromCart(int productId) async {
    final token = await TokenHelper.getValidToken();
    if (token != null) {
      _isLoading = true;
      notifyListeners();
      try {
        final items = await _cartRepository.removeFromCart(productId, token);
        _cartItems.clear();
        for (var item in items) {
          _cartItems[item.product.id] = item;
        }
        _remoteTotal = await _cartRepository.fetchCartTotal(token);
      } catch (_) {
        _cartItems.remove(productId);
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    } else {
      _cartItems.remove(productId);
      notifyListeners();
    }
  }

  Future<void> incrementItem(int productId) async {
    if (!_cartItems.containsKey(productId)) return;
    final item = _cartItems[productId]!;
    if (item.quantity >= item.product.stockQuantity) return;

    final token = await TokenHelper.getValidToken();
    if (token != null) {
      _isLoading = true;
      notifyListeners();
      try {
        final items = await _cartRepository.updateCartQuantity(productId, item.quantity + 1, token);
        _cartItems.clear();
        for (var it in items) {
          _cartItems[it.product.id] = it;
        }
        _remoteTotal = await _cartRepository.fetchCartTotal(token);
      } catch (_) {
        item.quantity++;
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    } else {
      item.quantity++;
      notifyListeners();
    }
  }

  Future<void> decrementItem(int productId) async {
    if (!_cartItems.containsKey(productId)) return;
    final item = _cartItems[productId]!;

    if (item.quantity > 1) {
      final token = await TokenHelper.getValidToken();
      if (token != null) {
        _isLoading = true;
        notifyListeners();
        try {
          final items = await _cartRepository.updateCartQuantity(productId, item.quantity - 1, token);
          _cartItems.clear();
          for (var it in items) {
            _cartItems[it.product.id] = it;
          }
          _remoteTotal = await _cartRepository.fetchCartTotal(token);
        } catch (_) {
          item.quantity--;
        } finally {
          _isLoading = false;
          notifyListeners();
        }
      } else {
        item.quantity--;
        notifyListeners();
      }
    } else {
      await removeFromCart(productId);
    }
  }

  void clearCart() {
    _cartItems.clear();
    _remoteTotal = 0.0;
    notifyListeners();
  }

  int get itemCount => _cartItems.length;

  double get totalAmount {
    if (_remoteTotal > 0.0) {
      return _remoteTotal;
    }
    return _cartItems.values.fold(0.0, (sum, item) {
      final price = item.product.isSale ? item.product.salePrice : item.product.price;
      return sum + (price ?? 0.0) * item.quantity;
    });
  }

  List<Map<String, dynamic>> get cartItemsMap {
    return _cartItems.values.map((item) => item.toMap()).toList();
  }
}

import 'package:flutter/material.dart';
import '../../../product/data/models/product_model.dart';
import '../../data/models/cart_item_model.dart';

class CartViewModel with ChangeNotifier {
  final Map<int, CartItemModel> _cartItems = {};

  Map<int, CartItemModel> get cartItems => _cartItems;

  void addToCart(ProductModel product, int quantity) {
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
    notifyListeners();
  }

  void removeFromCart(int productId) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  void incrementItem(int productId) {
    if (_cartItems.containsKey(productId)) {
      if (_cartItems[productId]!.quantity < _cartItems[productId]!.product.stockQuantity) {
        _cartItems[productId]!.quantity++;
      }
      notifyListeners();
    }
  }

  void decrementItem(int productId) {
    if (_cartItems.containsKey(productId) && _cartItems[productId]!.quantity > 1) {
      _cartItems[productId]!.quantity--;
    } else {
      _cartItems.remove(productId);
    }
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  int get itemCount => _cartItems.length;

  double get totalAmount {
    return _cartItems.values.fold(0.0, (sum, item) {
      final price = item.product.isSale ? item.product.salePrice : item.product.price;
      return sum + (price ?? 0.0) * item.quantity;
    });
  }

  List<Map<String, dynamic>> get cartItemsMap {
    return _cartItems.values.map((item) => item.toMap()).toList();
  }
}

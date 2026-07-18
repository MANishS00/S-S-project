import '../../data/models/cart_item_model.dart';

abstract class CartRepository {
  Future<List<CartItemModel>> fetchCart(String token);
  Future<List<CartItemModel>> addToCart(int productId, int quantity, String token);
  Future<List<CartItemModel>> removeFromCart(int productId, String token);
  Future<List<CartItemModel>> updateCartQuantity(int productId, int quantity, String token);
  Future<double> fetchCartTotal(String token);
}

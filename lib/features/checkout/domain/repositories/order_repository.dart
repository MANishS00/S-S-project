import '../../data/models/order_history_model.dart';

abstract class OrderRepository {
  Future<void> createOrder({
    required int userId,
    required String fullName,
    required String email,
    required double amountPaid,
    required Map<String, dynamic> shippingAddress,
    required List<Map<String, dynamic>> items,
  });
  Future<List<OrderHistoryModel>> fetchOrderHistory(String token);
}

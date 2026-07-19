import 'package:flutter/material.dart';
import '../../domain/repositories/order_repository.dart';
import '../../domain/repositories/payment_repository.dart';
import '../../data/repositories/order_repository_impl.dart';
import '../../data/repositories/payment_repository_impl.dart';
import '../../data/models/order_history_model.dart';
import '../../../../core/utils/token_helper.dart';

class CheckoutViewModel with ChangeNotifier {
  final OrderRepository _orderRepository;
  final PaymentRepository _paymentRepository;

  bool _isLoading = false;

  CheckoutViewModel({
    OrderRepository? orderRepository,
    PaymentRepository? paymentRepository,
  })  : _orderRepository = orderRepository ?? OrderRepositoryImpl(),
        _paymentRepository = paymentRepository ?? PaymentRepositoryImpl();

  bool get isLoading => _isLoading;

  Future<void> createOrder({
    required int userId,
    required String fullName,
    required String email,
    required double amountPaid,
    required Map<String, dynamic> shippingAddress,
    required List<Map<String, dynamic>> items,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _orderRepository.createOrder(
        userId: userId,
        fullName: fullName,
        email: email,
        amountPaid: amountPaid,
        shippingAddress: shippingAddress,
        items: items,
      );
    } catch (e) {
      // rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> initiatePayment(
    double totalAmount,
    List<Map<String, dynamic>> cartItems,
  ) async {
    _isLoading = true;
    notifyListeners();
    try {
      return await _paymentRepository.initiatePayment(totalAmount, cartItems);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> executePayment(String paymentId, String payerId) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _paymentRepository.executePayment(paymentId, payerId);
    } catch (e) {
      // rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<OrderHistoryModel> _orderHistory = [];
  List<OrderHistoryModel> get orderHistory => _orderHistory;

  Future<void> fetchOrderHistory() async {
    final token = await TokenHelper.getValidToken();
    if (token == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      _orderHistory = await _orderRepository.fetchOrderHistory(token);
    } catch (_) {
      _orderHistory = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

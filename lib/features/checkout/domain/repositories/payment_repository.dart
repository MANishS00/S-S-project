abstract class PaymentRepository {
  Future<Map<String, dynamic>> initiatePayment(
    double totalAmount,
    List<Map<String, dynamic>> cartItems,
  );
  Future<void> executePayment(String paymentId, String payerId);
}

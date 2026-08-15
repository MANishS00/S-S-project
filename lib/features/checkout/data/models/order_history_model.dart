class OrderItemHistoryModel {
  final int id;
  final int quantity;
  final double price;
  final int order;
  final int productId;
  final int user;

  OrderItemHistoryModel({
    required this.id,
    required this.quantity,
    required this.price,
    required this.order,
    required this.productId,
    required this.user,
  });

  factory OrderItemHistoryModel.fromJson(Map<String, dynamic> json) {
    return OrderItemHistoryModel(
      id: json['id'] ?? 0,
      quantity: json['quantity'] ?? 0,
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      order: json['order'] ?? 0,
      productId: json['product'] ?? 0,
      user: json['user'] ?? 0,
    );
  }
}

class OrderHistoryModel {
  final int id;
  final List<OrderItemHistoryModel> items;
  final String fullName;
  final String email;
  final String shippingAddress;
  final double amountPaid;
  final String paymentMethod;
  final String paymentStatus;
  final String transactionId;
  final String status;
  final String trackingNumber;
  final String courierService;
  final DateTime? dateOrdered;
  final bool isShipped;
  final DateTime? shippedAt;
  final bool isDelivered;
  final DateTime? deliveredAt;
  final int user;

  OrderHistoryModel({
    required this.id,
    required this.items,
    required this.fullName,
    required this.email,
    required this.shippingAddress,
    required this.amountPaid,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.transactionId,
    required this.status,
    required this.trackingNumber,
    required this.courierService,
    this.dateOrdered,
    required this.isShipped,
    this.shippedAt,
    required this.isDelivered,
    this.deliveredAt,
    required this.user,
  });

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) {
    var rawItems = json['items'] as List<dynamic>? ?? [];
    List<OrderItemHistoryModel> itemsList = rawItems
        .map((e) => OrderItemHistoryModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return OrderHistoryModel(
      id: json['id'] ?? 0,
      items: itemsList,
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      shippingAddress: json['shipping_address'] ?? '',
      amountPaid: double.tryParse(json['amount_paid'].toString()) ?? 0.0,
      paymentMethod: json['payment_method'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      transactionId: json['transaction_id'] ?? '',
      status: json['status'] ?? 'Pending',
      trackingNumber: json['tracking_number'] ?? '',
      courierService: json['courier_service'] ?? '',
      dateOrdered: json['date_ordered'] != null ? DateTime.tryParse(json['date_ordered']) : null,
      isShipped: json['is_shipped'] ?? false,
      shippedAt: json['shipped_at'] != null ? DateTime.tryParse(json['shipped_at']) : null,
      isDelivered: json['is_delivered'] ?? false,
      deliveredAt: json['delivered_at'] != null ? DateTime.tryParse(json['delivered_at']) : null,
      user: json['user'] ?? 0,
    );
  }
}

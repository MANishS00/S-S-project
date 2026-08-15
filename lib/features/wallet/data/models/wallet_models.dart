class WalletBalanceModel {
  final double balance;
  final double pendingBalance;
  final double availableBalance;
  final DateTime? updatedAt;

  WalletBalanceModel({
    required this.balance,
    required this.pendingBalance,
    required this.availableBalance,
    this.updatedAt,
  });

  factory WalletBalanceModel.fromJson(Map<String, dynamic> json) {
    return WalletBalanceModel(
      balance: double.tryParse(json['balance'].toString()) ?? 0.0,
      pendingBalance: double.tryParse(json['pending_balance'].toString()) ?? 0.0,
      availableBalance: double.tryParse(json['available_balance'].toString()) ?? 0.0,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
    );
  }
}

class PayoutRequestModel {
  final int id;
  final double amount;
  final String status;
  final String statusDisplay;
  final String upiId;
  final String transactionId;
  final DateTime? createdAt;
  final double fee;
  final double tax;
  final double finalAmount;
  final String confirmationNote;

  PayoutRequestModel({
    required this.id,
    required this.amount,
    required this.status,
    required this.statusDisplay,
    required this.upiId,
    required this.transactionId,
    this.createdAt,
    required this.fee,
    required this.tax,
    required this.finalAmount,
    required this.confirmationNote,
  });

  factory PayoutRequestModel.fromJson(Map<String, dynamic> json) {
    return PayoutRequestModel(
      id: json['id'] ?? 0,
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      status: json['status'] ?? '',
      statusDisplay: json['status_display'] ?? '',
      upiId: json['upi_id'] ?? '',
      transactionId: json['transaction_id'] ?? '',
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      fee: double.tryParse(json['fee'].toString()) ?? 0.0,
      tax: double.tryParse(json['tax'].toString()) ?? 0.0,
      finalAmount: double.tryParse(json['final_amount'].toString()) ?? 0.0,
      confirmationNote: json['confirmation_note'] ?? '',
    );
  }
}

class WalletTransactionModel {
  final int id;
  final String transactionType;
  final String transactionTypeDisplay;
  final double amount;
  final String description;
  final DateTime? timestamp;

  WalletTransactionModel({
    required this.id,
    required this.transactionType,
    required this.transactionTypeDisplay,
    required this.amount,
    required this.description,
    this.timestamp,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      id: json['id'] ?? 0,
      transactionType: json['transaction_type'] ?? '',
      transactionTypeDisplay: json['transaction_type_display'] ?? '',
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      description: json['description'] ?? '',
      timestamp: json['timestamp'] != null ? DateTime.tryParse(json['timestamp']) : null,
    );
  }
}

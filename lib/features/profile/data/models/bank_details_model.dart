class BankDetailsModel {
  final int id;
  final String accountHolderName;
  final String email;
  final String phoneNumber;
  final String contactType;
  final String accountNumber;
  final String ifscCode;

  BankDetailsModel({
    required this.id,
    required this.accountHolderName,
    required this.email,
    required this.phoneNumber,
    required this.contactType,
    required this.accountNumber,
    required this.ifscCode,
  });

  factory BankDetailsModel.fromJson(Map<String, dynamic> json) {
    return BankDetailsModel(
      id: json['id'] ?? 0,
      accountHolderName: json['account_holder_name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      contactType: json['contact_type'] ?? '',
      accountNumber: json['account_number'] ?? '',
      ifscCode: json['ifsc_code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'account_holder_name': accountHolderName,
      'email': email,
      'phone_number': phoneNumber,
      'contact_type': contactType,
      'account_number': accountNumber,
      'ifsc_code': ifscCode,
    };
  }
}

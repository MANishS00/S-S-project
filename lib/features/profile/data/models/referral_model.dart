class ReferralModel {
  final String fullName;
  final String email;
  final DateTime? dateJoined;

  ReferralModel({
    required this.fullName,
    required this.email,
    this.dateJoined,
  });

  factory ReferralModel.fromJson(Map<String, dynamic> json) {
    return ReferralModel(
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      dateJoined: json['date_joined'] != null ? DateTime.tryParse(json['date_joined']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'email': email,
      'date_joined': dateJoined?.toIso8601String(),
    };
  }
}

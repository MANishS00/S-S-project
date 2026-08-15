class ShippingAddressModel {
  final int? id;
  final int? user;
  final String? phone;
  final String? fullName;
  final String? email;
  final String? address1;
  final String? address2;
  final String? city;
  final String? state;
  final String? zipcode;
  final String? country;

  ShippingAddressModel({
    this.id,
    this.user,
    this.phone,
    this.fullName,
    this.email,
    this.address1,
    this.address2,
    this.city,
    this.state,
    this.zipcode,
    this.country,
  });

  factory ShippingAddressModel.fromJson(Map<String, dynamic> json) {
    return ShippingAddressModel(
      id: json['id'] as int?,
      user: json['user'] as int?,
      phone: json['phone'] as String?,
      fullName: json['full_name'] as String?,
      email: json['email'] as String?,
      address1: json['address1'] as String?,
      address2: json['address2'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      zipcode: json['zipcode'] as String?,
      country: json['country'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user': user,
      'phone': phone,
      'full_name': fullName,
      'email': email,
      'address1': address1,
      'address2': address2,
      'city': city,
      'state': state,
      'zipcode': zipcode,
      'country': country,
    };
  }
}

class ProfileModel {
  final int user;
  final String? image;
  final String? phone;
  final String? address1;
  final String? address2;
  final String? city;
  final String? state;
  final String? zipcode;
  final String? country;

  ProfileModel({
    required this.user,
    this.image,
    this.phone,
    this.address1,
    this.address2,
    this.city,
    this.state,
    this.zipcode,
    this.country,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      user: json['user'] as int,
      image: json['image'] as String?,
      phone: json['phone'] as String?,
      address1: json['address1'] as String?,
      address2: json['address2'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      zipcode: json['zipcode'] as String?,
      country: json['country'] as String?,
    );
  }
}

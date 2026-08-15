class BannerModel {
  final String image;
  final String? caption;
  final DateTime createdAt;
  final bool inUse;

  BannerModel({
    required this.image,
    this.caption,
    required this.createdAt,
    required this.inUse,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      image: json['image'] as String,
      caption: json['caption'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      inUse: json['in_use'] as bool,
    );
  }
}

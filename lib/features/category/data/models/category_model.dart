class CategoryModel {
  final int id;
  final String name;
  final String? keyWords;
  final String? description;
  final String? image;
  final String? slug;

  CategoryModel({
    required this.id,
    required this.name,
    this.keyWords,
    this.description,
    this.image,
    this.slug,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      keyWords: json['key_words'] as String?,
      description: json['description'] as String?,
      image: json['image'] as String?,
      slug: json['slug'] as String?,
    );
  }
}

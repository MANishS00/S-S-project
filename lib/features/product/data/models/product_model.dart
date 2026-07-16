class ProductListResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<ProductModel> results;

  ProductListResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    return ProductListResponse(
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List<dynamic>)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ProductImageModel {
  final int id;
  final String imageUrl;

  ProductImageModel({
    required this.id,
    required this.imageUrl,
  });

  factory ProductImageModel.fromJson(Map<String, dynamic> json) {
    return ProductImageModel(
      id: json['id'] ?? 0,
      imageUrl: json['product_images'] ?? '',
    );
  }
}

class ProductModel {
  final int id;
  final String name;
  final String description;
  final String profileImage;
  final List<ProductImageModel> productImages;

  final double price;
  final double specialCommissionAmount;

  final bool isSale;
  final double? salePrice;
  final double discount;
  final double percentageDiscount;

  final DateTime? createdAt;
  final bool isListed;
  final bool isFeatured;

  final String slug;
  final int stockQuantity;

  final String? brand;
  final String? material;
  final ProductCategoryModel? category;

  final String? color;
  final String? size;
  final String? keyWords;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.profileImage,
    required this.productImages,
    required this.price,
    required this.specialCommissionAmount,
    required this.isSale,
    this.salePrice,
    required this.discount,
    required this.percentageDiscount,
    this.createdAt,
    required this.isListed,
    required this.isFeatured,
    required this.slug,
    required this.stockQuantity,
    this.brand,
    this.material,
    this.category,
    this.color,
    this.size,
    this.keyWords,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    List<ProductImageModel> parseImages(dynamic images) {
      if (images is List) {
        return images
            .map((e) => ProductImageModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    }

    return ProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      profileImage: json['profile_image'] ?? '',
      productImages: parseImages(json['product_images']),
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      specialCommissionAmount:
          double.tryParse(json['special_commission_amount'].toString()) ?? 0.0,
      isSale: json['is_sale'] ?? false,
      salePrice: json['sale_price'] != null
          ? double.tryParse(json['sale_price'].toString())
          : null,
      discount: double.tryParse(json['discount'].toString()) ?? 0.0,
      percentageDiscount:
          double.tryParse(json['percentage_discount'].toString()) ?? 0.0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      isListed: json['is_listed'] ?? false,
      isFeatured: json['is_featured'] ?? false,
      slug: json['slug'] ?? '',
      stockQuantity: json['stock_quantity'] ?? 0,
      brand: json['brand'],
      material: json['material'],
      category: json['category'] != null
          ? ProductCategoryModel.fromJson(json['category'])
          : null,
      color: json['color'],
      size: json['size'],
      keyWords: json['key_words'],
    );
  }

  bool get inStock => stockQuantity > 0;
}

class ProductCategoryModel {
  final int id;
  final String name;
  final String? description;
  final String? image;

  ProductCategoryModel({
    required this.id,
    required this.name,
    this.description,
    this.image,
  });

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProductCategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'],
      image: json['image'],
    );
  }
}

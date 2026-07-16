class ProductListResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<Product> results;

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
          .map((e) => Product.fromJson(e))
          .toList(),
    );
  }
}

class ProductImage {
  final int id;
  final String imageUrl;

  ProductImage({
    required this.id,
    required this.imageUrl,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'] ?? 0,
      imageUrl: json['product_images'] ?? '',
    );
  }
}

class Product {
  final int id;
  final String name;
  final String description;
  final String profileImage;
  final List<ProductImage> productImages;

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
  final ProductCategory? category;

  final String? color;
  final String? size;
  final String? keyWords;

  Product({
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

  factory Product.fromJson(Map<String, dynamic> json) {
    List<ProductImage> parseImages(dynamic images) {
      if (images is List) {
        return images
            .map((e) => ProductImage.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    }

    return Product(
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
          ? ProductCategory.fromJson(json['category'])
          : null,

      color: json['color'],
      size: json['size'],
      keyWords: json['key_words'],
    );
  }

  /// Derived property since API no longer sends `in_stock`
  bool get inStock => stockQuantity > 0;
}

class ProductCategory {
  final int id;
  final String name;
  final String? description;
  final String? image;

  ProductCategory({
    required this.id,
    required this.name,
    this.description,
    this.image,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'],
      image: json['image'],
    );
  }
}
import '../../data/models/product_model.dart';

abstract class ProductRepository {
  Future<List<ProductModel>> fetchProducts();
  Future<List<ProductModel>> fetchProductsByCategory(int categoryId);
  Future<List<ProductModel>> fetchFeaturedProducts();
  Future<List<ProductModel>> fetchRecentProducts();
  Future<List<ProductModel>> fetchSaleProducts();
  Future<List<ProductModel>> searchProducts(String query);
  Future<ProductModel> fetchProductById(int id);
}

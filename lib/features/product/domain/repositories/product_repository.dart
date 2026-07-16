import '../../data/models/product_model.dart';

abstract class ProductRepository {
  Future<List<ProductModel>> fetchProducts();
  Future<List<ProductModel>> fetchProductsByCategory(int categoryId);
}

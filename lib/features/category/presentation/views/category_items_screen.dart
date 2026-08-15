import 'package:app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../product/presentation/viewmodels/product_viewmodel.dart';
import '../../../product/presentation/views/product_item_widget.dart';
import '../../data/models/category_model.dart';

class CategoryItemsScreen extends StatelessWidget {
  final CategoryModel category;

  const CategoryItemsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final productVM = Provider.of<ProductViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      productVM.fetchProductsByCategory(category.id);
    });

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: Consumer<ProductViewModel>(
        builder: (context, productVM, child) {
          final categoryProducts = productVM.products.where((product) {
            return product.category?.id == category.id;
          }).toList();

          if (categoryProducts.isEmpty) {
            return const Center(child: Text('No products available in this category.'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.62,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: categoryProducts.length,
            itemBuilder: (ctx, index) {
              final product = categoryProducts[index];
              return ProductItem(product: product);
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/product_viewmodel.dart';
import 'product_item_widget.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(
      builder: (context, productVM, child) {
        if (productVM.products.isEmpty && !productVM.isLoading) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            productVM.fetchProducts();
          });
          return const Center(child: CircularProgressIndicator());
        } else if (productVM.isLoading && productVM.products.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 190,
                childAspectRatio: 1.8 / 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemCount: productVM.products.length,
              itemBuilder: (ctx, index) {
                final product = productVM.products[index];
                return ProductItem(product: product);
              },
            ),
          );
        }
      },
    );
  }
}

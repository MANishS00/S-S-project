import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/product_viewmodel.dart';
import 'product_item_widget.dart';

class DealsView extends StatelessWidget {
  const DealsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(
      builder: (context, productVM, child) {
        if (productVM.products.isEmpty) {
          if (!productVM.isLoading) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              productVM.fetchProducts();
            });
          }
          return const Center(child: CircularProgressIndicator());
        } else {
          final dealsProducts = productVM.products
              .where((product) => product.isSale)
              .toList();

          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: SizedBox(
              height: 240,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: dealsProducts.length,
                itemBuilder: (ctx, index) {
                  final product = dealsProducts[index];
                  return Container(
                    width: 170,
                    padding: const EdgeInsets.all(4.0),
                    child: ProductItem(product: product),
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }
}

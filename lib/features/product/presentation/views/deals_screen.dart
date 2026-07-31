import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/product_viewmodel.dart';
import 'product_item_widget.dart';

class DealsScreen extends StatelessWidget {
  const DealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4EEFF),
      appBar: AppBar(
        title: const Text('Deals'),
        backgroundColor: const Color(0xffF4EEFF),
      ),
      body: const SingleChildScrollView(
        child: DealsProductsView(),
      ),
    );
  }
}

class DealsProductsView extends StatelessWidget {
  const DealsProductsView({super.key});

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
          final dealsProducts =
              productVM.products.where((product) => product.isSale).toList();

          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 0.70, // Adjust to your card's height
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: dealsProducts.length,
              itemBuilder: (ctx, index) {
                final product = dealsProducts[index];
                return ProductItem(product: product);
              },
            ),
          );
        }
      },
    );
  }
}

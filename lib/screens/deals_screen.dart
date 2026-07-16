import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../widgets/product_item.dart';

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
    // final productProvider = Provider.of<ProductProvider>(context);

    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        if (productProvider.products.isEmpty) {
          // Fetch products only if they are not already fetched
          if (!productProvider.isLoading) {
            productProvider.fetchProducts();
          }
          return const Center(child: CircularProgressIndicator());
        } else {
          final dealsProducts =
              productProvider.products.where((product) => product.isSale).toList();

          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(), // Disable GridView scrolling
              shrinkWrap: true, // Ensure GridView takes only required space
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 2.3 / 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
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

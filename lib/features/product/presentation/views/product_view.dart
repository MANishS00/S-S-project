import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/product_viewmodel.dart';
import 'deals_screen.dart';
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
        }

        if (productVM.isLoading && productVM.products.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final products = productVM.products;
        final dealsProducts =
            products.where((product) => product.isSale).toList();

        final hasDeals = dealsProducts.isNotEmpty;

        return Column(
          children: [
            /// First 6 products
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length >= 6 ? 6 : products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.80, // Adjust to your card's height
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                return ProductItem(product: products[index]);
              },
            ),

            /// Deals section (only if deals exist)
            if (hasDeals) ...[
              const SizedBox(height: 16),
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xffA6B1E1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Deals",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const DealsScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "See More",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_double_arrow_right,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 270,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: dealsProducts.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: 170,
                      child: ProductItem(
                        product: dealsProducts[index],
                      ),
                    );
                  },
                ),
              ),
              // const SizedBox(height: 8),
            ],

            /// Remaining products
            if (products.length > 6)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: products.length - 6,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.70, // Adjust to your card's height
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  return ProductItem(
                    product: products[index + 6],
                  );
                },
              ),
          ],
        );
      },
    );
  }
}

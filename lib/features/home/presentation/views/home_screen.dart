import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../category/presentation/viewmodels/category_viewmodel.dart';
import '../../../category/presentation/views/category_view.dart';
import '../../../product/presentation/viewmodels/product_viewmodel.dart';
import '../../../product/presentation/views/deals_screen.dart';
import '../../../product/presentation/views/deals_view.dart';
import '../../../product/presentation/views/product_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => ProductViewModel()..fetchProducts()),
        ChangeNotifierProvider(
            create: (_) => CategoryViewModel()..fetchCategories()),
      ],
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<ProductViewModel>(
            builder: (context, productVM, _) {
              return Column(
                children: [
                  CategoryView(
                    categories:
                        Provider.of<CategoryViewModel>(context).categories,
                  ),
                  const SizedBox(height: 5),
                  // const BannerCarousel(),
                  const SizedBox(height: 5),
                  Container(
                    decoration: const BoxDecoration(color: Color(0xffA6B1E1)),
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Deals',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const DealsScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'See More',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                            const Icon(
                              Icons.keyboard_double_arrow_right,
                              size: 16.0,
                              color: Colors.white,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const DealsView(),
                  Container(
                    decoration: const BoxDecoration(color: Color(0xffA6B1E1)),
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Products',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                // Add products list navigation if needed
                              },
                              child: const Text(
                                'See More',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const ProductsView(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

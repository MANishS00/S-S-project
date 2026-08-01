import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/widgets/drawer.dart';
import 'package:app/features/cart/presentation/viewmodels/cart_viewmodel.dart';
import 'package:app/features/cart/presentation/views/cart_screen.dart';
import 'package:app/features/product/presentation/views/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../product/presentation/viewmodels/product_viewmodel.dart';
import '../../../product/presentation/views/product_view.dart';
import '../../../category/presentation/viewmodels/category_viewmodel.dart';
import '../../../category/presentation/views/home_category_row.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryViewModel>(context, listen: false).fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartVM = Provider.of<CartViewModel>(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => ProductViewModel()..fetchProducts()),
      ],
      child: Scaffold(
        backgroundColor: AppColors.white,
        key: _scaffoldKey,
        drawer: appDrawer(context),
        body: Stack(children: [
          Column(
            children: [
              // Top Custom Header Stack
              SizedBox(
                height: 170,
                child: Stack(
                  children: [
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            Color(0xFFd7eaff),
                            Color(0xFFE3F2FD),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    Positioned(
                      bottom: 30,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SearchScreen()),
                              );
                            },
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width - 35,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.08), // Shadow color
                                    blurRadius: 10, // Softness
                                    spreadRadius: 1, // Shadow spread
                                    offset: const Offset(0, 3), // X, Y position
                                  ),
                                ],
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.search, color: Colors.grey),
                                    SizedBox(width: 8),
                                    Text(
                                      'Search products...',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      left: 12,
                      right: 12,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.menu),
                            onPressed: () =>
                                _scaffoldKey.currentState?.openDrawer(),
                          ),
                          Text(
                            'Skyage',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.7),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Icon(
                              Icons.notifications,
                              color: Colors.black.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable Content area
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Categories Section
                        const HomeCategoryRow(),

                        // Products Section
                        Consumer<ProductViewModel>(
                          builder: (context, productVM, _) {
                            return const ProductsView();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (cartVM.itemCount > 0)
            Positioned(
              right: 0,
              bottom: 16,
              child: GestureDetector(
                onTap: () {
                  // Open Cart Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                },
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                  ),
                  decoration: const BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        Color(0xFFd7eaff),
                        Color(0xFFE3F2FD),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      bottomLeft: Radius.circular(40),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Cart Icon
                      const Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.black,
                        size: 32,
                      ),

                      const SizedBox(width: 12),

                      // Price + Items
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '₹ ${cartVM.totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${cartVM.itemCount} ${cartVM.itemCount == 1 ? 'item' : 'items'}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ]),
      ),
    );
  }
}

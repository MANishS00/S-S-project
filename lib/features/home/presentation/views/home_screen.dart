import 'package:app/core/widgets/drawer.dart';
import 'package:app/features/product/presentation/views/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../product/presentation/viewmodels/product_viewmodel.dart';
import '../../../product/presentation/views/product_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => ProductViewModel()..fetchProducts()),
      ],
      child: Scaffold(
        key: _scaffoldKey,
        drawer: appDrawer(context),
        body: Column(
          children: [
            SizedBox(
              height: 170,
              child: Stack(children: [
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
                        ),
                      ),
                    )),
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
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Icon(
                          Icons.notifications,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ), // Placeholder for the top section
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric( horizontal:  8.0),
                  child: Consumer<ProductViewModel>(
                    builder: (context, productVM, _) {
                      return const ProductsView();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

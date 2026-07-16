import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/product_model.dart';
import '../viewmodels/product_viewmodel.dart';
import 'product_item_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ProductModel> _searchResults = [];
  bool _isLoading = true;

  void _searchProducts() {
    final query = _searchController.text.toLowerCase();

    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final productVM = Provider.of<ProductViewModel>(context, listen: false);
    final allProducts = productVM.products;

    setState(() {
      _searchResults = allProducts.where((product) {
        return product.name.toLowerCase().contains(query) ||
            (product.category?.name.toLowerCase().contains(query) ?? false) ||
            (product.color?.toLowerCase().contains(query) ?? false) ||
            (product.keyWords?.toLowerCase().contains(query) ?? false) ||
            (product.brand?.toLowerCase().contains(query) ?? false) ||
            (product.material?.toLowerCase().contains(query) ?? false);
      }).toList();
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productVM = Provider.of<ProductViewModel>(context, listen: false);
      productVM.fetchProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      }).catchError((_) {
        setState(() {
          _isLoading = false;
        });
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search products...',
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: _searchProducts,
            ),
          ),
          onSubmitted: (value) => _searchProducts(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _searchResults.isEmpty
              ? const Center(child: Text('No products found.'))
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 2.3 / 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  itemCount: _searchResults.length,
                  itemBuilder: (ctx, index) {
                    final product = _searchResults[index];
                    return ProductItem(product: product);
                  },
                ),
    );
  }
}

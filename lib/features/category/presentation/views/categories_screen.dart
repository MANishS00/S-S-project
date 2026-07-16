import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/category_viewmodel.dart';
import 'category_item_widget.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryViewModel>().fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryVM = context.watch<CategoryViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xffF4EEFF),
      body: categoryVM.isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              itemCount: categoryVM.categories.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 3 / 2,
              ),
              itemBuilder: (_, index) =>
                  CategoryItem(category: categoryVM.categories[index]),
            ),
    );
  }
}

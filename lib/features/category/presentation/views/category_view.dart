import 'package:flutter/material.dart';
import '../../data/models/category_model.dart';
import 'category_item_widget.dart';

class CategoryView extends StatelessWidget {
  final List<CategoryModel> categories;

  const CategoryView({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return categories.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((category) {
                return CategoryItem(category: category);
              }).toList(),
            ),
          );
  }
}

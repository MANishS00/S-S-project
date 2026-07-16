import 'package:flutter/material.dart';
import '../../models/category.dart';
import '../../widgets/category_item.dart';

class CategoryView extends StatelessWidget {
  final List<Category> categories;

  const CategoryView({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return categories.isEmpty
        ? const Center(child: CircularProgressIndicator()) // Loading indicator if categories are empty
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal, // Enable horizontal scrolling
            child: Row(
              children: categories.map((category) {
                return CategoryItem(category: category);
              }).toList(),
            ),
          );
  }
}

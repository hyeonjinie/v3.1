import 'package:flutter/material.dart';
import 'package:v3_mvp/screens/products/widget/product_list_view.dart';
import 'package:v3_mvp/screens/products/widget/subcategory_selector.dart';
import '../../../../domain/models/product.dart';

class CategoryView extends StatelessWidget {
  final String category;
  final List<String> subcategories;
  final Map<String, int> selectedSubcategoryIndex;
  final Future<List<Product>> productsFuture;
  final ValueChanged<int> onSubcategorySelected;

  const CategoryView({
    Key? key,
    required this.category,
    required this.subcategories,
    required this.selectedSubcategoryIndex,
    required this.productsFuture,
    required this.onSubcategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SubcategorySelector(
          category: category,
          subcategories: subcategories,
          selectedSubcategoryIndex: selectedSubcategoryIndex[category]!,
          onSubcategorySelected: onSubcategorySelected,
        ),
        Expanded(
          child: ProductListView(
            subCategory: subcategories[selectedSubcategoryIndex[category]!],
            productsFuture: productsFuture,
          ),
        ),
      ],
    );
  }
}

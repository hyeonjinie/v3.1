import 'package:flutter/material.dart';
import 'package:v3_mvp/screens/products/widget/category_tabbar.dart';

class ProductContentsScreen extends StatefulWidget {
  const ProductContentsScreen({Key? key}) : super(key: key);

  @override
  State<ProductContentsScreen> createState() => _ProductContentsScreenState();
}

class _ProductContentsScreenState extends State<ProductContentsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [CategoryTabBar(), Text('Product Contents Screen')],
          ),
        ),
      ),
    );
  }
}

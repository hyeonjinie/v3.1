import 'package:flutter/material.dart';
import 'product_card.dart';
import '../../../../domain/models/product.dart';

class ProductListView extends StatelessWidget {
  final String subCategory;
  final Future<List<Product>> productsFuture;

  const ProductListView({
    Key? key,
    required this.subCategory,
    required this.productsFuture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: productsFuture.then((products) => products
          .where((product) => product.subCategory == subCategory)
          .toList()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
              childAspectRatio: 0.7,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final product = snapshot.data![index];
              return ProductCard(product: product);
            },
          );
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }
}

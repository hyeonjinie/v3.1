import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String imageUrl;

  const ProductImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
        return const Icon(Icons.error, size: 50, color: Colors.red);
      },
    );
  }
}

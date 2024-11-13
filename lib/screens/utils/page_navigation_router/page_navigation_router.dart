import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/models/product.dart';

class PageNavigationRouter {
  static void navigateToPage(BuildContext context, String route, {dynamic extra}) {
    context.go(route, extra: extra);
  }

  static Future<void> navigateToDetailPage(BuildContext context, String productId) async {
    final productDoc = await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .get();

    if (productDoc.exists) {
      final product = Product.fromDocument(productDoc);
      final productJson = jsonEncode(product.toJson());
      navigateToPage(context, '/detail', extra: productJson);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('상품 정보를 불러오는데 실패했습니다.')),
      );
    }
  }
}

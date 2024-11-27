import 'package:flutter/foundation.dart';
import 'package:v3_mvp/screens/info_center/subscription/new_subscription/models/subscription_category.dart';
import 'package:v3_mvp/screens/info_center/subscription/new_subscription/models/product.dart';

@immutable
class SubscriptionData {
  final List<SubscriptionCategory> categories;
  final List<Product> products;
  final Map<String, dynamic> rawData;
  final String mode;

  const SubscriptionData({
    required this.categories,
    required this.products,
    required this.rawData,
    required this.mode,
  });

  factory SubscriptionData.fromJson(Map<String, dynamic> json, String mode) {
    final List<dynamic> categoryList = json['categories'] as List<dynamic>;
    final List<dynamic> productsList = json['products'] as List<dynamic>;
    
    // products 리스트의 모든 항목을 Product로 변환
    final List<Product> allProducts = productsList
        .expand((item) {
          if (item is List) {
            return item.map((product) => 
              Product.fromJson(product as Map<String, dynamic>));
          } else if (item is Map<String, dynamic>) {
            return [Product.fromJson(item)];
          }
          return <Product>[];
        })
        .toList();

    return SubscriptionData(
      categories: categoryList
          .map((category) => SubscriptionCategory.fromJson(category as Map<String, dynamic>, mode))
          .toList(),
      products: allProducts,
      rawData: json,
      mode: mode,
    );
  }

  SubscriptionCategory? getCategoryByLevel(int level) {
    try {
      return categories.firstWhere((category) => category.level == level);
    } catch (e) {
      return null;
    }
  }

  List<Product> get items => products;
}

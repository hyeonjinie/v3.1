import 'package:v3_mvp/screens/info_center/subscription/new_subscription/models/category.dart';
import 'package:v3_mvp/screens/info_center/subscription/new_subscription/models/index.dart';
import 'package:v3_mvp/screens/info_center/subscription/new_subscription/models/product.dart';

class MockApiData {
  final List<CategoryLevel> categories;
  final List<Product>? products;
  final List<Index>? indices;

  MockApiData({
    required this.categories,
    this.products,
    this.indices,
  });

  factory MockApiData.fromJson(Map<String, dynamic> json) {
    return MockApiData(
      categories: (json['categories'] as List)
          .map((e) => CategoryLevel.fromJson(e))
          .toList(),
      products:
      (json['products'] as List?)?.map((e) => Product.fromJson(e)).toList(),
      indices:
      (json['indices'] as List?)?.map((e) => Index.fromJson(e)).toList(),
    );
  }
}
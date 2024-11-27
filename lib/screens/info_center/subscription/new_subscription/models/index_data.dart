import 'package:flutter/foundation.dart';
import 'package:v3_mvp/screens/info_center/subscription/new_subscription/models/subscription_category.dart';
import 'package:v3_mvp/screens/info_center/subscription/new_subscription/models/index.dart';

@immutable
class IndexData {
  final List<SubscriptionCategory> categories;
  final List<Index> indices;
  final Map<String, dynamic> rawData;

  const IndexData({
    required this.categories,
    required this.indices,
    required this.rawData,
  });

  factory IndexData.fromJson(Map<String, dynamic> json) {
    final List<dynamic> categoryList = json['categories'] as List<dynamic>;
    final List<dynamic> indexList = json['indices'] as List<dynamic>;

    return IndexData(
      categories: categoryList
          .map((category) => SubscriptionCategory.fromJson(category as Map<String, dynamic>, '지수'))
          .toList(),
      indices: indexList
          .map((index) => Index.fromJson(index as Map<String, dynamic>))
          .toList(),
      rawData: json,
    );
  }

  SubscriptionCategory? getCategoryByLevel(int level) {
    try {
      return categories.firstWhere((category) => category.level == level);
    } catch (e) {
      return null;
    }
  }
}

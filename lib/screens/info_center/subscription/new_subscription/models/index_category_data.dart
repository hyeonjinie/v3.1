import 'package:v3_mvp/screens/info_center/subscription/new_subscription/models/index.dart';
import 'package:v3_mvp/screens/info_center/subscription/new_subscription/models/category.dart';


class IndexCategoryData {
  final List<SubscriptionCategory> categories;
  final List<Index> indices;

  IndexCategoryData({
    required this.categories,
    required this.indices,
  });

  factory IndexCategoryData.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawIndices = json['indices'] as List? ?? [];
    print('IndexCategoryData.fromJson - Raw indices: $rawIndices');
    
    final indices = rawIndices.map((item) {
      try {
        final index = Index.fromJson(item as Map<String, dynamic>);
        print('Successfully parsed index: ${index.name}');
        return index;
      } catch (e) {
        print('Error parsing index: $e');
        return null;
      }
    }).whereType<Index>().toList();

    return IndexCategoryData(
      categories: (json['categories'] as List)
          .map((category) => SubscriptionCategory.fromJson(category))
          .toList(),
      indices: indices,
    );
  }
}

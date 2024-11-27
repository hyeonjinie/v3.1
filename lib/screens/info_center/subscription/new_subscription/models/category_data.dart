import 'package:v3_mvp/screens/info_center/subscription/new_subscription/models/product.dart';
import 'package:v3_mvp/screens/info_center/subscription/new_subscription/models/index.dart';
import 'package:v3_mvp/screens/info_center/subscription/new_subscription/models/category.dart';

class CategoryData {
  final List<SubscriptionCategory> categories;
  final List<List<dynamic>> items;

  CategoryData({
    required this.categories,
    required this.items,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json, String mode) {
    final itemsKey = mode == '가격' ? 'products' : 'indices';
    final List<dynamic> rawItems = json[itemsKey] as List? ?? [];
    
    print('CategoryData.fromJson - Raw items: $rawItems');
    
    // products 배열을 카테고리별로 그룹화
    final Map<String, List<dynamic>> groupedItems = {};
    
    if (mode == '가격') {
      for (var item in rawItems) {
        if (item is Map<String, dynamic> && item.containsKey('filters')) {
          final filters = item['filters'] as Map<String, dynamic>;
          final subtype = filters['subtype'] as String? ?? '기타';
          groupedItems.putIfAbsent(subtype, () => []).add(item);
        }
      }
    }
    
    // 카테고리 목록을 서버 데이터에서 가져오기
    final List<String> categoryOrder = (json['categoryOrder'] as List?)?.map((e) => e.toString()).toList() ?? 
        ['농산물', '수산물', '축산물'];  // 기본값 사용
    
    // 카테고리 순서대로 아이템 리스트 생성
    final items = categoryOrder.map((category) {
      final categoryItems = groupedItems[category] ?? [];
      print('Processing $category items: ${categoryItems.length}');
      
      return categoryItems.map((item) {
        try {
          if (mode == '가격') {
            final product = Product.fromJson(item as Map<String, dynamic>);
            print('Successfully parsed product: ${product.name}');
            return product;
          } else {
            final index = Index.fromJson(item as Map<String, dynamic>);
            print('Successfully parsed index: ${index.name}');
            return index;
          }
        } catch (e) {
          print('Error parsing item: $e');
          return null;
        }
      }).whereType<dynamic>().toList();
    }).toList();
    
    print('CategoryData.fromJson - Final items length: ${items.length}');
    for (var i = 0; i < items.length; i++) {
      print('items[$i] length: ${items[i].length}');
    }

    return CategoryData(
      categories: (json['categories'] as List)
          .map((category) => SubscriptionCategory.fromJson(category))
          .toList(),
      items: items,
    );
  }
}

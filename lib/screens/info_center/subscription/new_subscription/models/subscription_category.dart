import 'package:flutter/foundation.dart';

@immutable
class SubscriptionCategory {
  final int level;
  final dynamic options;
  final String mode;  // '가격' 또는 '지수' 모드 구분

  const SubscriptionCategory({
    required this.level,
    required this.options,
    required this.mode,
  });

  factory SubscriptionCategory.fromJson(Map<String, dynamic> json, String mode) {
    return SubscriptionCategory(
      level: json['level'] as int,
      options: json['options'],
      mode: mode,
    );
  }

  List<String> getOptionsForLevel(String? selectedCategory, String? selectedSubtype) {
    if (mode == '가격') {
      return _getPriceOptions(selectedCategory, selectedSubtype);
    } else {
      if (options == null) return [];

      switch (level) {
        case 1:
        case 2:
        case 3:
          // 단순 문자열 리스트
          if (options is List) {
            return List<String>.from(options as List);
          }
          return [];

        case 4:
          // 선택된 type에 따라 해당하는 옵션들을 반환
          if (options is List) {
            try {
              // selectedSubtype이 있으면 해당하는 옵션을 찾고, 없으면 '묶음' 옵션을 찾음
              final targetType = selectedSubtype ?? '묶음';
              print('Level 4 - Selected Type: $targetType'); // 디버깅용
              
              final map = (options as List).firstWhere(
                (item) => item is Map<String, dynamic> && item.containsKey(targetType),
                orElse: () => {},
              ) as Map<String, dynamic>;
              
              print('Level 4 - Found Map: $map'); // 디버깅용
              
              final values = map[targetType];
              if (values is List) {
                final result = List<String>.from(values);
                print('Level 4 - Returning Options: $result'); // 디버깅용
                return result;
              }
            } catch (e) {
              print('Index Level 4 - Error: $e');
            }
          }
          print('Level 4 - Returning Empty List'); // 디버깅용
          return [];

        case 5:
          // 레벨 4의 선택값에 따른 옵션들을 반환
          if (options is List && selectedCategory != null) {
            try {
              final categoryMap = (options as List).firstWhere(
                (item) => item is Map<String, dynamic> && item.containsKey(selectedCategory),
                orElse: () => {},
              ) as Map<String, dynamic>;
              
              final values = categoryMap[selectedCategory];
              if (values is List) {
                return List<String>.from(values);
              }
            } catch (e) {
              print('Index Level 5 - Error: $e');
            }
          }
          return [];

        default:
          return [];
      }
    }
  }

  // 가격 모드의 옵션 처리
  List<String> _getPriceOptions(String? selectedCategory, String? selectedSubtype) {
    if (options == null) return [];

    switch (level) {
      case 1:
      case 2:
      case 3:
      case 4:
        // 단순 문자열 리스트
        if (options is List) {
          return List<String>.from(options as List);
        }
        return [];

      case 5:
        if (selectedCategory == null) return [];
        if (options is List) {
          print('Price Level 5 - Selected Category: $selectedCategory');
          print('Price Level 5 - Options: $options');
          
          // selectedCategory를 그대로 키로 사용
          final categoryKey = selectedCategory;
          print('Price Level 5 - Category Key: $categoryKey');
          
          try {
            final targetMap = (options as List).firstWhere(
              (item) => item is Map<String, dynamic> && item.containsKey(categoryKey),
            ) as Map<String, dynamic>;
            
            final values = targetMap[categoryKey];
            if (values is List) {
              print('Price Level 5 - Found values: $values');
              return List<String>.from(values);
            }
          } catch (e) {
            print('Price Level 5 - Error: $e');
          }
        }
        return [];

      case 6:
        if (selectedSubtype == null || selectedCategory == null) return [];
        if (options is List) {
          print('Price Level 6 - Selected Subtype: $selectedSubtype');
          print('Price Level 6 - Selected Category: $selectedCategory');
          print('Price Level 6 - Options: $options');
          
          try {
            // options 리스트의 각 맵을 순회
            for (var categoryMap in options) {
              if (categoryMap is Map<String, dynamic> && categoryMap.containsKey(selectedSubtype)) {
                // selectedSubtype에 해당하는 리스트를 찾음
                final values = categoryMap[selectedSubtype];
                if (values is List) {
                  print('Price Level 6 - Found values for $selectedSubtype: $values');
                  return List<String>.from(values);
                }
              }
            }
          } catch (e) {
            print('Price Level 6 - Error: $e');
          }
        }
        return [];

      default:
        return [];
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionCategory &&
          runtimeType == other.runtimeType &&
          level == other.level &&
          mode == other.mode;

  @override
  int get hashCode => level.hashCode ^ mode.hashCode;
}

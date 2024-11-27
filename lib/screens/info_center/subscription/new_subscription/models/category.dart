library category;

export 'category.dart';

class SubscriptionCategory {
  final int level;
  final dynamic options;

  SubscriptionCategory({
    required this.level,
    required this.options,
  });

  factory SubscriptionCategory.fromJson(Map<String, dynamic> json) {
    return SubscriptionCategory(
      level: json['level'] as int,
      options: json['options'],
    );
  }

  List<String> getOptionsForLevel(String? category, String? subtype) {
    print('\ngetOptionsForLevel in SubscriptionCategory:');
    print('Level: $level');
    print('Category param: $category');
    print('Subtype param: $subtype');
    print('Options type: ${options.runtimeType}');
    
    if (options == null) return [];

    // Level 1-3: 단순 문자열 리스트
    if (options is List && options.every((e) => e is String)) {
      print('Returning simple string list: $options');
      return List<String>.from(options as List);
    }

    // Level 4: 단순 리스트 (농산물, 수산물, 축산물, 가공식품)
    if (level == 4 && options is List) {
      if (options.every((e) => e is String)) {
        print('Level 4 - Returning simple list: $options');
        return List<String>.from(options as List);
      }
      // 지수 모드를 위한 처리
      if (subtype != null) {
        for (var optionMap in options as List) {
          if (optionMap is Map && optionMap.containsKey(subtype)) {
            print('Level 4 - Returning mapped list for $subtype: ${optionMap[subtype]}');
            return List<String>.from(optionMap[subtype] as List);
          }
        }
      }
      return [];
    }

    // Level 5: 중첩된 Map 구조 (과일, 채소, 기타 등)
    if (level == 5 && options is List && category != null) {
      print('Level 5 - Processing with category: $category');
      for (var optionMap in options as List) {
        if (optionMap is Map<String, dynamic>) {
          // 명시적으로 String 타입의 키를 가진 Map임을 선언
          String matchingKey = '';
          List<dynamic>? matchingValue;
          
          for (var entry in optionMap.entries) {
            if (entry.key == category) {
              matchingKey = entry.key;
              matchingValue = entry.value as List<dynamic>;
              break;
            }
          }
          
          if (matchingKey.isNotEmpty && matchingValue != null) {
            print('Level 5 - Found options for $category: $matchingValue');
            return List<String>.from(matchingValue);
          }
        }
      }
      return [];
    }

    // Level 6: 더 깊은 중첩 구조 (과일과채류, 과실류 등)
    if (level == 6 && options is List && category != null && subtype != null) {
      print('Level 6 - Processing with category: $category, subtype: $subtype');
      for (var optionMap in options as List) {
        if (optionMap is Map<String, dynamic>) {
          final categoryMap = optionMap[subtype] as Map<String, dynamic>?;
          if (categoryMap != null && categoryMap.containsKey(category)) {
            final detailList = categoryMap[category] as List<dynamic>;
            print('Level 6 - Found options for $subtype/$category: $detailList');
            return List<String>.from(detailList);
          }
        }
      }
      return [];
    }

    print('No matching condition found, returning empty list');
    return [];
  }
}
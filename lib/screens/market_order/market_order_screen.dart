import 'package:flutter/material.dart';

// 가격예측 데이터 모델
class Product {
  final String name;
  final int price;
  final ProductFilters filters;

  Product({required this.name, required this.price, required this.filters});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      price: json['price'],
      filters: ProductFilters.fromJson(json['filters']),
    );
  }
}

class ProductFilters {
  final List<String> terms;
  final List<String> markets;
  final String category;
  final String subtype;
  final String detail;

  ProductFilters({
    required this.terms,
    required this.markets,
    required this.category,
    required this.subtype,
    required this.detail,
  });

  factory ProductFilters.fromJson(Map<String, dynamic> json) {
    return ProductFilters(
      terms: List<String>.from(json['terms']),
      markets: List<String>.from(json['markets']),
      category: json['category'],
      subtype: json['subtype'],
      detail: json['detail'],
    );
  }
}

// 지수 데이터 모델
class Index {
  final String name;
  final int price;
  final IndexFilters filters;

  Index({required this.name, required this.price, required this.filters});

  factory Index.fromJson(Map<String, dynamic> json) {
    return Index(
      name: json['name'],
      price: json['price'],
      filters: IndexFilters.fromJson(json['filters']),
    );
  }
}

class IndexFilters {
  final List<String> term;
  final String category;
  final String type;
  final String detail;

  IndexFilters({
    required this.term,
    required this.category,
    required this.type,
    required this.detail,
  });

  factory IndexFilters.fromJson(Map<String, dynamic> json) {
    return IndexFilters(
      term: List<String>.from(json['term']),
      category: json['category'],
      type: json['type'],
      detail: json['detail'],
    );
  }
}

// 카테고리 모델
class CategoryLevel {
  final int level;
  final List<String> options;

  CategoryLevel({required this.level, required this.options});

  factory CategoryLevel.fromJson(Map<String, dynamic> json) {
    return CategoryLevel(
      level: json['level'],
      options: List<String>.from(json['options']),
    );
  }
}

// API 데이터 모델
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

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  late MockApiData priceData;
  late MockApiData indexData;
  String selectedMode = '가격예측';

  // Selected values for price prediction
  String? selectedTerm;
  String? selectedMarket;
  String? selectedCategory;
  String? selectedSubtype;
  String? selectedDetail;

  // Selected values for index
  String? selectedIndexTerm;
  String? selectedType;
  String? selectedIndexCategory;
  String? selectedIndexDetail;

  @override
  void initState() {
    super.initState();
    // 가격예측 데이터 초기화
    priceData = MockApiData.fromJson(mockPriceData);
    // 지수 데이터 초기화
    loadIndexData();
  }

  Future<void> loadIndexData() async {
    // 실제 API 호출 시뮬레이션
    await Future.delayed(const Duration(milliseconds: 500));
    indexData = MockApiData.fromJson(mockIndexData);
    setState(() {});
  }

  void resetSelections() {
    if (selectedMode == '가격예측') {
      selectedTerm = null;
      selectedMarket = null;
      selectedCategory = null;
      selectedSubtype = null;
      selectedDetail = null;
    } else {
      selectedIndexTerm = null;
      selectedType = null;
      selectedIndexCategory = null;
      selectedIndexDetail = null;
    }
  }

  void onModeChanged(String mode) {
    setState(() {
      selectedMode = mode;
      resetSelections();
    });
  }

  bool get isAllLevelsSelected {
    if (selectedMode == '가격예측') {
      return selectedTerm != null &&
          selectedMarket != null &&
          selectedCategory != null &&
          selectedSubtype != null &&
          selectedDetail != null;
    } else {
      return selectedIndexTerm != null &&
          selectedType != null &&
          selectedIndexCategory != null &&
          selectedIndexDetail != null;
    }
  }

  List<String> getOptionsForLevel(int level) {
    final data = selectedMode == '가격예측' ? priceData : indexData;
    return data.categories
        .firstWhere((category) => category.level == level)
        .options;
  }

  // 가격예측 필터링
  List<Product> getFilteredProducts() {
    return priceData.products?.where((product) {
          if (selectedTerm != null &&
              !product.filters.terms.contains(selectedTerm)) {
            return false;
          }
          if (selectedMarket != null &&
              !product.filters.markets.contains(selectedMarket)) {
            return false;
          }
          if (selectedCategory != null &&
              product.filters.category != selectedCategory) {
            return false;
          }
          if (selectedSubtype != null &&
              product.filters.subtype != selectedSubtype) {
            return false;
          }
          if (selectedDetail != null &&
              product.filters.detail != selectedDetail) {
            return false;
          }
          return true;
        }).toList() ??
        [];
  }

  // 지수 필터링
  List<Index> getFilteredIndices() {
    return indexData.indices?.where((index) {
          if (selectedIndexTerm != null &&
              !index.filters.term.contains(selectedIndexTerm)) {
            return false;
          }
          if (selectedType != null && index.filters.type != selectedType) {
            return false;
          }
          if (selectedIndexCategory != null &&
              index.filters.category != selectedIndexCategory) {
            return false;
          }
          if (selectedIndexDetail != null &&
              index.filters.detail != selectedIndexDetail) {
            return false;
          }
          return true;
        }).toList() ??
        [];
  }

  Widget _buildOptionButton(
      String text, bool isSelected, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: SizedBox(
        height: 40,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isSelected ? const Color(0xFF11C278) : Colors.white,
            foregroundColor: isSelected ? Colors.white : Colors.black87,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: BorderSide(
                color: isSelected ? const Color(0xFF11C278) : Colors.grey[300]!,
                width: 1,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String hint, List<String> items, String? value,
      Function(String?)? onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: DropdownButtonHideUnderline(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: onChanged == null ? Colors.grey[300]! : Colors.grey[400]!,
            ),
            borderRadius: BorderRadius.circular(4),
            color: onChanged == null ? Colors.grey[100] : Colors.white,
          ),
          child: DropdownButton<String>(
            hint: Text(
              hint,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            value: value,
            isExpanded: true,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  Widget _buildGrid<T>({
    required List<T> items,
    required String Function(T) getName,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 화면 너비에 따른 레이아웃 조정
        int crossAxisCount;
        double childAspectRatio;
        double fontSize;
        double iconSize;

        if (constraints.maxWidth < 600) {
          // 모바일
          crossAxisCount = 4;
          childAspectRatio = 1;
          fontSize = 12;
          iconSize = 16;
        } else if (constraints.maxWidth < 1024) {
          // 태블릿
          crossAxisCount = 6;
          childAspectRatio = 1;
          fontSize = 13;
          iconSize = 18;
        } else {
          // 데스크톱
          crossAxisCount = 8;
          childAspectRatio = 1;
          fontSize = 14;
          iconSize = 20;
        }

        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: childAspectRatio,
              crossAxisSpacing: 8,
              mainAxisSpacing: 16,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                padding: const EdgeInsets.all(4),
                child: Column(
                  children: [
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: InkWell(
                          onTap: () {
                            print('Selected item: ${getName(item)}');
                          },
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Icons.image_outlined,
                              color: Colors.grey,
                              size: iconSize,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: 20,  // 텍스트 영역 높이 고정
                      child: Text(
                        getName(item),
                        style: TextStyle(
                          fontSize: fontSize,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mode Selection
            Row(
              children: [
                Expanded(
                  child: _buildOptionButton(
                    '가격예측',
                    selectedMode == '가격예측',
                    () => onModeChanged('가격예측'),
                  ),
                ),
                Expanded(
                  child: _buildOptionButton(
                    '지수',
                    selectedMode == '지수',
                    () => onModeChanged('지수'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (selectedMode == '가격예측') ...[
              // Price Prediction UI
              // Terms
              Row(
                children: [
                  for (final term in getOptionsForLevel(2))
                    Expanded(
                      child: _buildOptionButton(
                        term,
                        selectedTerm == term,
                        () => setState(() => selectedTerm = term),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Markets
              Row(
                children: [
                  for (final market in getOptionsForLevel(3))
                    Expanded(
                      child: _buildOptionButton(
                        market,
                        selectedMarket == market,
                        () => setState(() => selectedMarket = market),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Categories
              Row(
                children: [
                  for (final category in getOptionsForLevel(4))
                    Expanded(
                      child: _buildOptionButton(
                        category,
                        selectedCategory == category,
                        () => setState(() {
                          selectedCategory = category;
                          selectedSubtype = null;
                          selectedDetail = null;
                        }),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Dropdowns
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      '선택하세요',
                      getOptionsForLevel(5),
                      selectedSubtype,
                      selectedCategory == null
                          ? null
                          : (value) => setState(() {
                                selectedSubtype = value;
                                selectedDetail = null;
                              }),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildDropdown(
                      '선택하세요',
                      getOptionsForLevel(6),
                      selectedDetail,
                      selectedSubtype == null
                          ? null
// build 메서드 계속...
                          : (value) => setState(() => selectedDetail = value),
                    ),
                  ),
                ],
              ),

              if (isAllLevelsSelected)
                _buildGrid<Product>(
                  items: getFilteredProducts(),
                  getName: (product) => product.name,
                ),
            ] else ...[
              // Index UI
              // Terms
              Row(
                children: [
                  for (final term in getOptionsForLevel(2))
                    Expanded(
                      child: _buildOptionButton(
                        term,
                        selectedIndexTerm == term,
                        () => setState(() => selectedIndexTerm = term),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Type
              Row(
                children: [
                  for (final type in getOptionsForLevel(3))
                    Expanded(
                      child: _buildOptionButton(
                        type,
                        selectedType == type,
                        () => setState(() => selectedType = type),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Categories
              Row(
                children: [
                  for (final category in getOptionsForLevel(4))
                    Expanded(
                      child: _buildOptionButton(
                        category,
                        selectedIndexCategory == category,
                        () => setState(() {
                          selectedIndexCategory = category;
                          selectedIndexDetail = null;
                        }),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Detail dropdown
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      '선택하세요',
                      getOptionsForLevel(5),
                      selectedIndexDetail,
                      selectedIndexCategory == null
                          ? null
                          : (value) =>
                              setState(() => selectedIndexDetail = value),
                    ),
                  ),
                ],
              ),
              if (isAllLevelsSelected)
                _buildGrid<Index>(
                  items: getFilteredIndices(),
                  getName: (index) => index.name,
                ),
            ],
          ],
        ),
      ),
    );
  }
}

// 목업 데이터
final mockPriceData = {
  "categories": [
    {
      "level": 1,
      "options": ["가격예측"]
    },
    {
      "level": 2,
      "options": ["D+7", "D+15", "D+30"]
    },
    {
      "level": 3,
      "options": ["경매", "도매", "소매", "수입"]
    },
    {
      "level": 4,
      "options": ["농산물", "축산물", "수산물", "가공식품"]
    },
    {
      "level": 5,
      "options": ["과일", "채소", "기타"]
    },
    {
      "level": 6,
      "options": ["과실류", "잎채류", "뿌리채소"]
    }
  ],
  "products": [
    {
      "name": "딸기",
      "price": 500000,
      "filters": {
        "terms": ["D+7", "D+15", "D+30"],
        "markets": ["경매", "도매", "소매"],
        "category": "농산물",
        "subtype": "과일",
        "detail": "과실류"
      }
    },
    // ... 나머지 제품들
  ]
};

final mockIndexData = {
  "categories": [
    {
      "level": 1,
      "options": ["지수"]
    },
    {
      "level": 2,
      "options": ["D+7", "D+15", "D+30"]
    },
    {
      "level": 3,
      "options": ["묶음", "메뉴"]
    },
    {
      "level": 4,
      "options": ["차례상", "농산물", "수산물", "축산물"]
    },
    {
      "level": 5,
      "options": ["표준코드별", "통계별", "시장별"]
    }
  ],
  "indices": [
    {
      "name": "종합",
      "price": 500000,
      "filters": {
        "term": ["D+7", "D+15"],
        "category": "농산물",
        "type": "묶음",
        "detail": "표준코드별"
      }
    },
    {
      "name": "가락Top10",
      "price": 500000,
      "filters": {
        "term": ["D+15", "D+30"],
        "category": "농산물",
        "type": "묶음",
        "detail": "시장별"
      }
    }
  ]
};

// import 'package:flutter/material.dart';
//
// // Mock API 데이터를 담을 클래스
// class MockApiData {
//   final List<CategoryLevel> categories;
//   final List<Product> products;
//
//   MockApiData({required this.categories, required this.products});
//
//   factory MockApiData.fromJson(Map<String, dynamic> json) {
//     return MockApiData(
//       categories: (json['categories'] as List)
//           .map((e) => CategoryLevel.fromJson(e))
//           .toList(),
//       products:
//       (json['products'] as List).map((e) => Product.fromJson(e)).toList(),
//     );
//   }
// }
//
// class CategoryLevel {
//   final int level;
//   final List<String> options;
//
//   CategoryLevel({required this.level, required this.options});
//
//   factory CategoryLevel.fromJson(Map<String, dynamic> json) {
//     return CategoryLevel(
//       level: json['level'],
//       options: List<String>.from(json['options']),
//     );
//   }
// }
//
// class Product {
//   final String name;
//   final int price;
//   final ProductFilters filters;
//
//   Product({required this.name, required this.price, required this.filters});
//
//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       name: json['name'],
//       price: json['price'],
//       filters: ProductFilters.fromJson(json['filters']),
//     );
//   }
// }
//
// class ProductFilters {
//   final List<String> terms;
//   final List<String> markets;
//   final String category;
//   final String subtype;
//   final String detail;
//
//   ProductFilters({
//     required this.terms,
//     required this.markets,
//     required this.category,
//     required this.subtype,
//     required this.detail,
//   });
//
//   factory ProductFilters.fromJson(Map<String, dynamic> json) {
//     return ProductFilters(
//       terms: List<String>.from(json['terms']),
//       markets: List<String>.from(json['markets']),
//       category: json['category'],
//       subtype: json['subtype'],
//       detail: json['detail'],
//     );
//   }
// }
//
// class SubscriptionPage extends StatefulWidget {
//   const SubscriptionPage({Key? key}) : super(key: key);
//
//   @override
//   State<SubscriptionPage> createState() => _SubscriptionPageState();
// }
//
// class _SubscriptionPageState extends State<SubscriptionPage> {
//
//   late MockApiData mockData;
//   // Selected values
//   String? selectedTerm;
//   String? selectedMarket;
//   String? selectedCategory;
//   String? selectedSubtype;
//   String? selectedDetail;
//
//   // Dropdowns
//   String? selectedFruit;
//   String? selectedFruitType;
//
//   @override
//   void initState() {
//     super.initState();
//     // 여기서 실제로는 API 호출을 하겠지만, 지금은 목업 데이터를 사용
//     mockData = MockApiData.fromJson(mockApiData);
//   }
//
//   bool get isAllLevelsSelected {
//     return selectedTerm != null &&
//         selectedMarket != null &&
//         selectedCategory != null &&
//         selectedSubtype != null &&
//         selectedDetail != null;
//   }
//
//   // 상품 필터링 로직은 동일하게 유지
//   List<Product> getFilteredProducts() {
//     return mockData.products.where((product) {
//       if (selectedTerm != null && !product.filters.terms.contains(selectedTerm)) {
//         return false;
//       }
//       if (selectedMarket != null && !product.filters.markets.contains(selectedMarket)) {
//         return false;
//       }
//       if (selectedCategory != null && product.filters.category != selectedCategory) {
//         return false;
//       }
//       if (selectedSubtype != null && product.filters.subtype != selectedSubtype) {
//         return false;
//       }
//       if (selectedDetail != null && product.filters.detail != selectedDetail) {
//         return false;
//       }
//       return true;
//     }).toList();
//   }
//
//   List<String> getOptionsForLevel(int level) {
//     return mockData.categories
//         .firstWhere((category) => category.level == level)
//         .options;
//   }
//
//   // 드롭다운에 표시될 옵션들을 가져오는 메서드들
//   List<String> getSubtypeOptions() {
//     if (selectedCategory == null) return [];
//     return getOptionsForLevel(5);
//   }
//
//   List<String> getDetailOptions() {
//     if (selectedCategory == null || selectedSubtype == null) return [];
//     return getOptionsForLevel(6);
//   }
//
// // _buildOptionButton 메서드만 수정
//   Widget _buildOptionButton(
//       String text, bool isSelected, VoidCallback onPressed) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 4.0),
//       child: SizedBox(
//         height: 40, // 버튼 높이 고정
//         child: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor:
//                 isSelected ? const Color(0xFF11C278) : Colors.white,
//             foregroundColor: isSelected ? Colors.white : Colors.black87,
//             elevation: 0,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(4),
//               side: BorderSide(
//                 color: isSelected ? const Color(0xFF11C278) : Colors.grey[300]!,
//                 width: 1,
//               ),
//             ),
//             padding: const EdgeInsets.symmetric(horizontal: 24),
//           ),
//           onPressed: onPressed,
//           child: Text(
//             text,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDropdown(String hint, List<String> items, String? value,
//       Function(String?)? onChanged) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 4.0),
//       child: DropdownButtonHideUnderline(
//         child: Container(
//           decoration: BoxDecoration(
//             border: Border.all(
//               color: onChanged == null ? Colors.grey[300]! : Colors.grey[400]!,
//             ),
//             borderRadius: BorderRadius.circular(4),
//             color: onChanged == null ? Colors.grey[100] : Colors.white,
//           ),
//           child: DropdownButton<String>(
//             hint: Text(
//               hint,
//               style: TextStyle(
//                 color: Colors.grey[600],
//                 fontSize: 14,
//               ),
//             ),
//             value: value,
//             isExpanded: true,
//             padding: const EdgeInsets.symmetric(horizontal: 12),
//             items: items.map((String value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(value),
//               );
//             }).toList(),
//             onChanged: onChanged,
//             icon: Icon(
//               Icons.keyboard_arrow_down,
//               color: onChanged == null ? Colors.grey[400] : Colors.grey[700],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProductGrid(List<Product> filteredProducts) {
//     return LayoutBuilder(
//         builder: (context, constraints) {
//           final isMobile = constraints.maxWidth < 768;
//
//           return GridView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: isMobile ? 4 : 8,
//               childAspectRatio: 0.7,
//               crossAxisSpacing: 12,
//               mainAxisSpacing: 12,
//             ),
//             itemCount: filteredProducts.length,
//             itemBuilder: (context, index) {
//               final product = filteredProducts[index];
//               return LayoutBuilder(
//                 builder: (context, constraints) {
//                   final size = constraints.maxWidth;
//                   return Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       AspectRatio(
//                         aspectRatio: 1,
//                         child: InkWell(
//                           onTap: () {
//                             print('Selected product: ${product.name}');
//                           },
//                           borderRadius: BorderRadius.circular(4),
//                           child: Container(
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Colors.grey[300]!),
//                               borderRadius: BorderRadius.circular(4),
//                             ),
//                             child: Icon(
//                               Icons.image_outlined,
//                               color: Colors.grey,
//                               size: isMobile ? 16 : 20,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         product.name,  // Map에서 Product 객체로 변경
//                         style: TextStyle(
//                           fontSize: isMobile ? 12 : 14,
//                           height: 1.2,
//                         ),
//                         textAlign: TextAlign.center,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   );
//                 },
//               );
//             },
//           );
//         },
//       );
//   }
//
//   // List<String> getSubtypeOptions() {
//   //   if (selectedCategory == null) return [];
//   //
//   //   // 카테고리별 사용 가능한 subtype 목록
//   //   final Map<String, List<String>> subtypeMap = {
//   //     '농산물': ['과일', '채소', '기타'],
//   //     '축산물': ['기타'],
//   //     '수산물': ['기타'],
//   //     '가공식품': ['기타'],
//   //   };
//   //
//   //   return subtypeMap[selectedCategory] ?? [];
//   // }
//   //
//   // // 레벨 6 (detail) 옵션을 가져오는 메서드
//   // List<String> getDetailOptions() {
//   //   if (selectedCategory == null || selectedSubtype == null) return [];
//   //
//   //   // 카테고리와 subtype에 따른 detail 옵션
//   //   final Map<String, Map<String, List<String>>> detailMap = {
//   //     '농산물': {
//   //       '과일': ['과실류'],
//   //       '채소': ['잎채류', '뿌리채소'],
//   //       '기타': ['과실류'],
//   //     },
//   //     '축산물': {
//   //       '기타': ['과실류'],
//   //     },
//   //     '수산물': {
//   //       '기타': ['과실류'],
//   //     },
//   //     '가공식품': {
//   //       '기타': ['과실류'],
//   //     },
//   //   };
//   //
//   //   return detailMap[selectedCategory]?[selectedSubtype] ?? [];
//   // }
//
//   // 카테고리 선택 시 드롭다운 초기화
//   void onCategorySelected(String category) {
//     setState(() {
//       selectedCategory = category;
//       // 하위 선택 초기화
//       selectedSubtype = null;
//       selectedDetail = null;
//     });
//   }
//
//   // Subtype 선택 시 detail 초기화
//   void onSubtypeSelected(String? value) {
//     setState(() {
//       selectedSubtype = value;
//       selectedDetail = null;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Level 1: Service Type
//             Row(
//               children: [
//                 for (final option in getOptionsForLevel(1))
//                   Expanded(
//                     child: _buildOptionButton(
//                       option,
//                       true,
//                           () {},
//                     ),
//                   ),
//               ],
//             ),
//             const SizedBox(height: 16),
//
//             // Level 2: Terms
//             Row(
//               children: [
//                 for (final term in getOptionsForLevel(2))
//                   Expanded(
//                     child: _buildOptionButton(
//                       term,
//                       selectedTerm == term,
//                           () => setState(() => selectedTerm = term),
//                     ),
//                   ),
//               ],
//             ),
//             const SizedBox(height: 16),
//
//             // Level 3: Markets
//             Row(
//               children: [
//                 for (final market in getOptionsForLevel(3))
//                   Expanded(
//                     child: _buildOptionButton(
//                       market,
//                       selectedMarket == market,
//                           () => setState(() => selectedMarket = market),
//                     ),
//                   ),
//               ],
//             ),
//             const SizedBox(height: 16),
//
//             // Level 4: Categories
//             Row(
//               children: [
//                 for (final category in getOptionsForLevel(4))
//                   Expanded(
//                     child: _buildOptionButton(
//                       category,
//                       selectedCategory == category,
//                           () => onCategorySelected(category),
//                     ),
//                   ),
//               ],
//             ),
//             const SizedBox(height: 16),
//
//             // Level 5 & 6: Dropdowns
//             Row(
//               children: [
//                 Expanded(
//                   child: _buildDropdown(
//                     '선택하세요',
//                     getSubtypeOptions(),
//                     selectedSubtype,
//                     selectedCategory == null ? null : onSubtypeSelected,
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: _buildDropdown(
//                     '선택하세요',
//                     getDetailOptions(),
//                     selectedDetail,
//                     selectedSubtype == null
//                         ? null
//                         : (value) => setState(() => selectedDetail = value),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 24),
//
//             // Products Grid
//             if (isAllLevelsSelected)
//               _buildProductGrid(getFilteredProducts()),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// final mockApiData = {
//   "categories": [
//     {
//       "level": 1,
//       "options": ["가격예측"]
//     },
//     {
//       "level": 2,
//       "options": ["D+7", "D+15", "D+30"]
//     },
//     {
//       "level": 3,
//       "options": ["경매", "도매", "소매", "수입"]
//     },
//     {
//       "level": 4,
//       "options": ["농산물", "축산물", "수산물", "가공식품"]
//     },
//     {
//       "level": 5,
//       "options": ["과일", "채소", "기타"]
//     },
//     {
//       "level": 6,
//       "options": ["과실류", "잎채류", "뿌리채소"]
//     }
//   ],
//   "products": [
//     {
//       "name": "딸기",
//       "price": 500000,
//       "filters": {
//         "terms": ["D+7", "D+15", "D+30"],
//         "markets": ["경매", "도매", "소매"],
//         "category": "농산물",
//         "subtype": "과일",
//         "detail": "과실류"
//       }
//     },
//     {
//       "name": "사과",
//       "price": 500000,
//       "filters": {
//         "terms": ["D+7", "D+15"],
//         "markets": ["도매", "소매"],
//         "category": "농산물",
//         "subtype": "과일",
//         "detail": "과실류"
//       }
//     },
//     {
//       "name": "포도",
//       "price": 500000,
//       "filters": {
//         "terms": ["D+15", "D+30"],
//         "markets": ["도매", "수입"],
//         "category": "농산물",
//         "subtype": "과일",
//         "detail": "과실류"
//       }
//     },
//     {
//       "name": "배",
//       "price": 500000,
//       "filters": {
//         "terms": ["D+7", "D+30"],
//         "markets": ["경매", "도매"],
//         "category": "농산물",
//         "subtype": "과일",
//         "detail": "과실류"
//       }
//     },
//     {
//       "name": "감귤",
//       "price": 500000,
//       "filters": {
//         "terms": ["D+7", "D+15", "D+30"],
//         "markets": ["도매", "소매"],
//         "category": "농산물",
//         "subtype": "과일",
//         "detail": "과실류"
//       }
//     },
//     {
//       "name": "토마토",
//       "price": 500000,
//       "filters": {
//         "terms": ["D+7", "D+15"],
//         "markets": ["경매", "도매", "소매"],
//         "category": "농산물",
//         "subtype": "채소",
//         "detail": "과실류"
//       }
//     },
//     {
//       "name": "상추",
//       "price": 500000,
//       "filters": {
//         "terms": ["D+7", "D+15"],
//         "markets": ["경매"],
//         "category": "농산물",
//         "subtype": "채소",
//         "detail": "잎채류"
//       }
//     },
//     {
//       "name": "양상추",
//       "price": 500000,
//       "filters": {
//         "terms": ["D+7", "D+30"],
//         "markets": ["경매", "도매"],
//         "category": "농산물",
//         "subtype": "채소",
//         "detail": "잎채류"
//       }
//     },
//     {
//       "name": "배추",
//       "price": 500000,
//       "filters": {
//         "terms": ["D+15", "D+30"],
//         "markets": ["도매", "소매"],
//         "category": "농산물",
//         "subtype": "채소",
//         "detail": "잎채류"
//       }
//     },
//     {
//       "name": "양배추",
//       "price": 500000,
//       "filters": {
//         "terms": ["D+7", "D+15", "D+30"],
//         "markets": ["도매", "수입"],
//         "category": "농산물",
//         "subtype": "채소",
//         "detail": "잎채류"
//       }
//     },
//     {
//       "name": "감자",
//       "price": 500000,
//       "filters": {
//         "terms": ["D+15", "D+30"],
//         "markets": ["도매", "소매"],
//         "category": "농산물",
//         "subtype": "채소",
//         "detail": "뿌리채소"
//       }
//     },
//     {
//       "name": "고구마",
//       "price": 500000,
//       "filters": {
//         "terms": ["D+7", "D+30"],
//         "markets": ["경매", "도매"],
//         "category": "농산물",
//         "subtype": "채소",
//         "detail": "뿌리채소"
//       }
//     },
//     {
//       "name": "당근",
//       "price": 500000,
//       "filters": {
//         "terms": ["D+7", "D+15"],
//         "markets": ["경매", "도매", "소매"],
//         "category": "농산물",
//         "subtype": "채소",
//         "detail": "뿌리채소"
//       }
//     },
//     {
//       "name": "무",
//       "price": 500000,
//       "filters": {
//         "terms": ["D+7", "D+15", "D+30"],
//         "markets": ["도매", "소매"],
//         "category": "농산물",
//         "subtype": "채소",
//         "detail": "뿌리채소"
//       }
//     },
//     {
//       "name": "돼지고기",
//       "price": 500000,
//       "filters": {
//         "terms": ["D+7", "D+15"],
//         "markets": ["경매", "도매"],
//         "category": "축산물",
//         "subtype": "기타",
//         "detail": "과실류"
//       }
//     },
//     {
//       "name": "소고기",
//       "price": 500000,
//       "filters": {
//         "terms": ["D+15", "D+30"],
//         "markets": ["도매", "소매"],
//         "category": "축산물",
//         "subtype": "기타",
//         "detail": "과실류"
//       }
//     },
//     {
//       "name": "고등어",
//       "price": 500000,
//       "filters": {
//         "terms": ["D+7", "D+30"],
//         "markets": ["경매", "도매"],
//         "category": "수산물",
//         "subtype": "기타",
//         "detail": "과실류"
//       }
//     },
//     {
//       "name": "갈치",
//       "price": 500000,
//       "filters": {
//         "terms": ["D+7", "D+15"],
//         "markets": ["경매", "도매", "소매"],
//         "category": "수산물",
//         "subtype": "기타",
//         "detail": "과실류"
//       }
//     },
//     {
//       "name": "오징어",
//       "price": 500000,
//       "filters": {
//         "terms": ["D+15", "D+30"],
//         "markets": ["도매", "수입"],
//         "category": "수산물",
//         "subtype": "기타",
//         "detail": "과실류"
//       }
//     },
//     {
//       "name": "라면",
//       "price": 500000,
//       "filters": {
//         "terms": ["D+7", "D+15", "D+30"],
//         "markets": ["도매", "소매"],
//         "category": "가공식품",
//         "subtype": "기타",
//         "detail": "과실류"
//       }
//     }
//   ]
// };
//

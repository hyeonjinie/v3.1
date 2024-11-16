import 'package:flutter/material.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  // Selected values
  String? selectedTerm;
  String? selectedMarket;
  String? selectedCategory;
  String? selectedSubtype;
  String? selectedDetail;

  // Dropdowns
  String? selectedFruit;
  String? selectedFruitType;

  bool get isAllLevelsSelected {
    return selectedTerm != null &&
        selectedMarket != null &&
        selectedCategory != null &&
        selectedSubtype != null &&
        selectedDetail != null;
  }

  // 상품 필터링 로직은 동일하게 유지
  List<Map<String, dynamic>> getFilteredProducts() {
    return products.where((product) {
      if (selectedTerm != null &&
          !product['filters']['terms'].contains(selectedTerm)) {
        return false;
      }
      if (selectedMarket != null &&
          !product['filters']['markets'].contains(selectedMarket)) {
        return false;
      }
      if (selectedCategory != null &&
          product['filters']['category'] != selectedCategory) {
        return false;
      }
      if (selectedSubtype != null &&
          product['filters']['subtype'] != selectedSubtype) {
        return false;
      }
      if (selectedDetail != null &&
          product['filters']['detail'] != selectedDetail) {
        return false;
      }
      return true;
    }).toList();
  }

// _buildOptionButton 메서드만 수정
  Widget _buildOptionButton(
      String text, bool isSelected, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: SizedBox(
        height: 40, // 버튼 높이 고정
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isSelected ? const Color(0xFF4CAF50) : Colors.white,
            foregroundColor: isSelected ? Colors.white : Colors.black87,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: BorderSide(
                color: isSelected ? const Color(0xFF4CAF50) : Colors.grey[300]!,
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
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: onChanged == null ? Colors.grey[400] : Colors.grey[700],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductGrid(List<Map<String, dynamic>> filteredProducts) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          final product = filteredProducts[index];
          return Center(
            child: SizedBox(
              width: 80,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      print('Selected product: ${product['name']}');
                    },
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child:
                          const Icon(Icons.image_outlined, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product['name'],
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<String> getSubtypeOptions() {
    if (selectedCategory == null) return [];

    // 카테고리별 사용 가능한 subtype 목록
    final Map<String, List<String>> subtypeMap = {
      '농산물': ['과일', '채소', '기타'],
      '축산물': ['기타'],
      '수산물': ['기타'],
      '가공식품': ['기타'],
    };

    return subtypeMap[selectedCategory] ?? [];
  }

  // 레벨 6 (detail) 옵션을 가져오는 메서드
  List<String> getDetailOptions() {
    if (selectedCategory == null || selectedSubtype == null) return [];

    // 카테고리와 subtype에 따른 detail 옵션
    final Map<String, Map<String, List<String>>> detailMap = {
      '농산물': {
        '과일': ['과실류'],
        '채소': ['잎채류', '뿌리채소'],
        '기타': ['과실류'],
      },
      '축산물': {
        '기타': ['과실류'],
      },
      '수산물': {
        '기타': ['과실류'],
      },
      '가공식품': {
        '기타': ['과실류'],
      },
    };

    return detailMap[selectedCategory]?[selectedSubtype] ?? [];
  }

  // 카테고리 선택 시 드롭다운 초기화
  void onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
      // 하위 선택 초기화
      selectedSubtype = null;
      selectedDetail = null;
    });
  }

  // Subtype 선택 시 detail 초기화
  void onSubtypeSelected(String? value) {
    setState(() {
      selectedSubtype = value;
      selectedDetail = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Level 1: Service Type
            Row(
              children: [
                Expanded(
                  child: _buildOptionButton('가격예측', true, () {}),
                ),
                Expanded(
                  child: _buildOptionButton('지수', false, () {}),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Level 2: Terms
            Row(
              children: [
                for (final term in ['D+7', 'D+15', 'D+30'])
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

            // Level 3: Markets
            Row(
              children: [
                for (final market in ['경매', '도매', '소매', '수입'])
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

            // Level 4: Categories
            Row(
              children: [
                for (final category in ['농산물', '축산물', '수산물', '가공식품'])
                  Expanded(
                    child: _buildOptionButton(
                      category,
                      selectedCategory == category,
                      () => onCategorySelected(category),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Level 5 & 6: Dropdowns
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    '선택하세요',
                    getSubtypeOptions(), // 동적 옵션
                    selectedSubtype,
                    selectedCategory == null
                        ? null
                        : onSubtypeSelected, // 카테고리 선택 전에는 비활성화
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDropdown(
                    '선택하세요',
                    getDetailOptions(), // 동적 옵션
                    selectedDetail,
                    selectedSubtype == null
                        ? null
                        : (value) => setState(() =>
                            selectedDetail = value), // subtype 선택 전에는 비활성화
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Products Grid - 조건부 표시
            if (isAllLevelsSelected) _buildProductGrid(getFilteredProducts()),
          ],
        ),
      ),
    );
  }
}

// Sample data
final List<Map<String, dynamic>> products = [
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
  {
    "name": "사과",
    "price": 500000,
    "filters": {
      "terms": ["D+7", "D+15"],
      "markets": ["도매", "소매"],
      "category": "농산물",
      "subtype": "과일",
      "detail": "과실류"
    }
  },
  {
    "name": "포도",
    "price": 500000,
    "filters": {
      "terms": ["D+15", "D+30"],
      "markets": ["도매", "수입"],
      "category": "농산물",
      "subtype": "과일",
      "detail": "과실류"
    }
  },
  {
    "name": "배",
    "price": 500000,
    "filters": {
      "terms": ["D+7", "D+30"],
      "markets": ["경매", "도매"],
      "category": "농산물",
      "subtype": "과일",
      "detail": "과실류"
    }
  },
  {
    "name": "감귤",
    "price": 500000,
    "filters": {
      "terms": ["D+7", "D+15", "D+30"],
      "markets": ["도매", "소매"],
      "category": "농산물",
      "subtype": "과일",
      "detail": "과실류"
    }
  },
  {
    "name": "토마토",
    "price": 500000,
    "filters": {
      "terms": ["D+7", "D+15"],
      "markets": ["경매", "도매", "소매"],
      "category": "농산물",
      "subtype": "채소",
      "detail": "과실류"
    }
  },
  {
    "name": "상추",
    "price": 500000,
    "filters": {
      "terms": ["D+7", "D+15"],
      "markets": ["경매"],
      "category": "농산물",
      "subtype": "채소",
      "detail": "잎채류"
    }
  },
  {
    "name": "양상추",
    "price": 500000,
    "filters": {
      "terms": ["D+7", "D+30"],
      "markets": ["경매", "도매"],
      "category": "농산물",
      "subtype": "채소",
      "detail": "잎채류"
    }
  },
  {
    "name": "배추",
    "price": 500000,
    "filters": {
      "terms": ["D+15", "D+30"],
      "markets": ["도매", "소매"],
      "category": "농산물",
      "subtype": "채소",
      "detail": "잎채류"
    }
  },
  {
    "name": "양배추",
    "price": 500000,
    "filters": {
      "terms": ["D+7", "D+15", "D+30"],
      "markets": ["도매", "수입"],
      "category": "농산물",
      "subtype": "채소",
      "detail": "잎채류"
    }
  },
  {
    "name": "감자",
    "price": 500000,
    "filters": {
      "terms": ["D+15", "D+30"],
      "markets": ["도매", "소매"],
      "category": "농산물",
      "subtype": "채소",
      "detail": "뿌리채소"
    }
  },
  {
    "name": "고구마",
    "price": 500000,
    "filters": {
      "terms": ["D+7", "D+30"],
      "markets": ["경매", "도매"],
      "category": "농산물",
      "subtype": "채소",
      "detail": "뿌리채소"
    }
  },
  {
    "name": "당근",
    "price": 500000,
    "filters": {
      "terms": ["D+7", "D+15"],
      "markets": ["경매", "도매", "소매"],
      "category": "농산물",
      "subtype": "채소",
      "detail": "뿌리채소"
    }
  },
  {
    "name": "무",
    "price": 500000,
    "filters": {
      "terms": ["D+7", "D+15", "D+30"],
      "markets": ["도매", "소매"],
      "category": "농산물",
      "subtype": "채소",
      "detail": "뿌리채소"
    }
  },
  {
    "name": "돼지고기",
    "price": 500000,
    "filters": {
      "terms": ["D+7", "D+15"],
      "markets": ["경매", "도매"],
      "category": "축산물",
      "subtype": "기타",
      "detail": "과실류"
    }
  },
  {
    "name": "소고기",
    "price": 500000,
    "filters": {
      "terms": ["D+15", "D+30"],
      "markets": ["도매", "소매"],
      "category": "축산물",
      "subtype": "기타",
      "detail": "과실류"
    }
  },
  {
    "name": "고등어",
    "price": 500000,
    "filters": {
      "terms": ["D+7", "D+30"],
      "markets": ["경매", "도매"],
      "category": "수산물",
      "subtype": "기타",
      "detail": "과실류"
    }
  },
  {
    "name": "갈치",
    "price": 500000,
    "filters": {
      "terms": ["D+7", "D+15"],
      "markets": ["경매", "도매", "소매"],
      "category": "수산물",
      "subtype": "기타",
      "detail": "과실류"
    }
  },
  {
    "name": "오징어",
    "price": 500000,
    "filters": {
      "terms": ["D+15", "D+30"],
      "markets": ["도매", "수입"],
      "category": "수산물",
      "subtype": "기타",
      "detail": "과실류"
    }
  },
  {
    "name": "라면",
    "price": 500000,
    "filters": {
      "terms": ["D+7", "D+15", "D+30"],
      "markets": ["도매", "소매"],
      "category": "가공식품",
      "subtype": "기타",
      "detail": "과실류"
    }
  }
];

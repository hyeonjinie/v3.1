import 'package:flutter/material.dart';
import 'package:v3_mvp/screens/info_center/subscription/new_subscription/mock_data/mock_api_data.dart';
import 'package:v3_mvp/screens/info_center/subscription/new_subscription/mock_data/mock_data.dart';
import 'package:v3_mvp/screens/info_center/subscription/new_subscription/models/index.dart';
import 'package:v3_mvp/screens/info_center/subscription/new_subscription/models/product.dart';

class ProductSelection {
  final Product product;
  final String term;
  final String market;

  ProductSelection({
    required this.product,
    required this.term,
    required this.market,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductSelection &&
          runtimeType == other.runtimeType &&
          product == other.product &&
          term == other.term &&
          market == other.market;

  @override
  int get hashCode => product.hashCode ^ term.hashCode ^ market.hashCode;
}

class IndexSelection {
  final Index index;
  final String term;
  final String type;

  IndexSelection({
    required this.index,
    required this.term,
    required this.type,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IndexSelection &&
          runtimeType == other.runtimeType &&
          index == other.index &&
          term == other.term &&
          type == other.type;

  @override
  int get hashCode => index.hashCode ^ term.hashCode ^ type.hashCode;
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

  // 선택한 품목을 저장할 변수
  List<dynamic> selectedItems = [];

  // 약관 동의 상태
  bool allAgreed = false;
  bool agreeServiceTerms = false;
  bool agreeServiceAdditionalTerms = false;

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

  // 레벨 옵션 및 필터링 메서드들
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

  // 가격예측 모드의 레벨 선택 핸들러들
  void onTermSelected(String term) {
    setState(() {
      selectedTerm = term;
      // 하위 레벨 초기화
      selectedMarket = null;
      selectedCategory = null;
      selectedSubtype = null;
      selectedDetail = null;
    });
  }

  void onMarketSelected(String market) {
    setState(() {
      selectedMarket = market;
      // 하위 레벨 초기화
      selectedCategory = null;
      selectedSubtype = null;
      selectedDetail = null;
    });
  }

  void onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
      // 하위 레벨 초기화
      selectedSubtype = null;
      selectedDetail = null;
    });
  }

  void onSubtypeSelected(String? value) {
    setState(() {
      selectedSubtype = value;
      // 하위 레벨 초기화
      selectedDetail = null;
    });
  }

  // 지수 모드의 레벨 선택 핸들러들
  void onIndexTermSelected(String term) {
    setState(() {
      selectedIndexTerm = term;
      // 하위 레벨 초기화
      selectedType = null;
      selectedIndexCategory = null;
      selectedIndexDetail = null;
    });
  }

  void onTypeSelected(String type) {
    setState(() {
      selectedType = type;
      // 하위 레벨 초기화
      selectedIndexCategory = null;
      selectedIndexDetail = null;
    });
  }

  void onIndexCategorySelected(String category) {
    setState(() {
      selectedIndexCategory = category;
      // 하위 레벨 초기화
      selectedIndexDetail = null;
    });
  }

  double calculateTotalPrice() {
    double total = 0;
    for (var item in selectedItems) {
      if (item is ProductSelection) {
        total += item.product.price;
      } else if (item is IndexSelection) {
        total += item.index.price;
      }
    }
    return total;
  }

  // 약관 동의 상태 업데이트
  void updateAgreementStatus({bool? all, bool? service, bool? additional}) {
    setState(() {
      if (all != null) {
        allAgreed = all;
        agreeServiceTerms = all;
        agreeServiceAdditionalTerms = all;
      } else {
        if (service != null) {
          agreeServiceTerms = service;
        }
        if (additional != null) {
          agreeServiceAdditionalTerms = additional;
        }
        allAgreed = agreeServiceTerms && agreeServiceAdditionalTerms;
      }
    });
  }

  // UI 구성 요소 위젯들
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
        int crossAxisCount;
        double childAspectRatio;
        double fontSize;
        double iconSize;

        if (constraints.maxWidth < 600) {
          crossAxisCount = 4;
          childAspectRatio = 1;
          fontSize = 12;
          iconSize = 16;
        } else if (constraints.maxWidth < 1024) {
          crossAxisCount = 6;
          childAspectRatio = 1;
          fontSize = 13;
          iconSize = 18;
        } else {
          crossAxisCount = 8;
          childAspectRatio = 1;
          fontSize = 14;
          iconSize = 20;
        }

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFFD5D5D5),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.all(16),
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
                            setState(() {
                              if (item is Product &&
                                  selectedTerm != null &&
                                  selectedMarket != null) {
                                final newSelection = ProductSelection(
                                  product: item,
                                  term: selectedTerm!,
                                  market: selectedMarket!,
                                );
                                if (!selectedItems.contains(newSelection)) {
                                  selectedItems.add(newSelection);
                                }
                              } else if (item is Index &&
                                  selectedIndexTerm != null &&
                                  selectedType != null) {
                                final newSelection = IndexSelection(
                                  index: item,
                                  term: selectedIndexTerm!,
                                  type: selectedType!,
                                );
                                if (!selectedItems.contains(newSelection)) {
                                  selectedItems.add(newSelection);
                                }
                              }
                            });
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
                      height: 20,
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

  Widget _buildSelectedItemsTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            '선택 품목',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE0E0E0)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                children: const [
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('품목',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('구분',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('기간/타입',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('시장/세부',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(width: 40),
                    ),
                  ),
                ],
              ),
              ...selectedItems.map((item) {
                if (item is ProductSelection) {
                  return TableRow(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[200]!),
                      ),
                    ),
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(item.product.name),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(item.product.filters.category),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(item.term),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(item.market),
                        ),
                      ),
                      TableCell(
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              selectedItems.remove(item);
                            });
                          },
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.grey),
                        ),
                      ),
                    ],
                  );
                } else if (item is IndexSelection) {
                  return TableRow(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[200]!),
                      ),
                    ),
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(item.index.name),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(item.index.filters.category),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(item.term),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(item.type),
                        ),
                      ),
                      TableCell(
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              selectedItems.remove(item);
                            });
                          },
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.grey),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const TableRow(children: []);
                }
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1200),
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
                      // Terms
                      Row(
                        children: [
                          for (final term in getOptionsForLevel(2))
                            Expanded(
                              child: _buildOptionButton(
                                term,
                                selectedTerm == term,
                                () => onTermSelected(term),
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
                                () => onMarketSelected(market),
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
                                () => onCategorySelected(category),
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
                                  : onSubtypeSelected,
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
                                  : (value) =>
                                      setState(() => selectedDetail = value),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),

                      // 상품 목록 표시 (선택 가능한 데이터)
                      if (isAllLevelsSelected) ...[
                        Container(
                          constraints: const BoxConstraints(maxWidth: 1200),
                          alignment: Alignment.center,
                          child: _buildGrid<Product>(
                            items: getFilteredProducts(),
                            getName: (product) => product.name,
                          ),
                        ),
                      ],
                    ] else ...[
                      // Index Mode
                      Row(
                        children: [
                          for (final term in getOptionsForLevel(2))
                            Expanded(
                              child: _buildOptionButton(
                                term,
                                selectedIndexTerm == term,
                                () => onIndexTermSelected(term),
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
                                () => onTypeSelected(type),
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
                                () => onIndexCategorySelected(category),
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
                                  : (value) => setState(
                                      () => selectedIndexDetail = value),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),

                      // 지수 목록 표시 (선택 가능한 데이터)
                      if (isAllLevelsSelected) ...[
                        Container(
                          constraints: const BoxConstraints(maxWidth: 1200),
                          alignment: Alignment.center,
                          child: _buildGrid<Index>(
                            items: getFilteredIndices(),
                            getName: (index) => index.name,
                          ),
                        ),
                      ],
                    ],

                    const SizedBox(height: 40),
                    const Divider(height: 1, color: Color(0xFFE0E0E0)),

                    const SizedBox(height: 40),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      alignment: Alignment.center,
                      child: _buildSelectedItemsTable(),
                    ),

                    const SizedBox(height: 40),

                    // 총 가격 표시
                    Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${calculateTotalPrice().toStringAsFixed(0).toString().replaceAllMapped(
                                  RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
                                  (match) => '${match[1]},',
                                )}원',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '구독 시작일 : 결제일 기준',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                    // 약관 동의
                    Row(
                      children: [
                        Checkbox(
                          value: allAgreed,
                          onChanged: (bool? value) {
                            updateAgreementStatus(all: value);
                          },
                        ),
                        const Text('전체동의')
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: agreeServiceTerms,
                              onChanged: (bool? value) {
                                updateAgreementStatus(service: value);
                              },
                            ),
                            const Text('예측 데이터 구독 서비스 이용 약관 (필수)'),
                          ],
                        ),
                        const Text(
                          '보기',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: agreeServiceAdditionalTerms,
                              onChanged: (bool? value) {
                                updateAgreementStatus(additional: value);
                              },
                            ),
                            const Text('예측 데이터 구독 서비스 부가 약관 (필수)'),
                          ],
                        ),
                        const Text(
                          '보기',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // 구독하기 버튼
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                          ),
                          onPressed: () {},
                          child: const Text('구독하기'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

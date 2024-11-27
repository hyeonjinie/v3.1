import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted/models/category_model.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted/service/category_service.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted/sub_index_info.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted/sub_price_info.dart';

class SubscriptedPage extends StatefulWidget {
  const SubscriptedPage({Key? key}) : super(key: key);

  @override
  State<SubscriptedPage> createState() => _SubscriptedPageState();
}

class _SubscriptedPageState extends State<SubscriptedPage> {
  final CategoryService _service = CategoryService();

  late List<Category> categories = [];
  String selectedCategoryType = "가격";
  String? previousCategoryType;
  late Map<int, String> selectedOptions = {};
  bool isLoading = true;
  bool catIsEmpty = false;
  String selectedProdName = ""; // 가격 파라미터(name)
  int selectedProdDay = 1; // 가격 파라미터(filters: terms)
  String selectedIdxName = ""; // 지수 파라미터(name)
  String selectedProdCategory = ""; // 지수 파라미터(filters: category)
  String selectedProdType = ""; // 지수 파라미터(filters: type)
  String selectedDetail = ""; // 지수 파라미터(filters: detail)
  int selectedIdxDay = 1; // 지수 파라미터(filters: terms)
  String selectedInfomation = "";

  int? selectedItemIndex;

  @override
  void initState() {
    super.initState();
    _updateCategories();
  }

  Future<void> _updateCategories() async {
    isLoading = true;
    catIsEmpty = false;
    final fetchedCategories =
        await _service.fetchCategories(selectedCategoryType);
    setState(() {
      categories = fetchedCategories;
      if (categories[1].options.isNotEmpty) {
        if (selectedOptions.isEmpty ||
            previousCategoryType != selectedCategoryType) {
          selectedOptions = {
            2: categories.firstWhere((cat) => cat.level == 2).options.first,
            3: categories.firstWhere((cat) => cat.level == 3).options.first,
          };
          catIsEmpty = false;
        }
      } else {
        catIsEmpty = true;
      }
      selectedItemIndex = 0;
      // 현재 카테고리 타입을 이전 값으로 업데이트
      previousCategoryType = selectedCategoryType;
      selectedCategoryType == '가격' ? _filterProducts() : _filterIndices();
    });
  }

  // 필터링된 selectedProd 리스트
  List<dynamic> selectedProd = [];

  Future<void> _filterProducts() async {
    final selectedMarket = selectedOptions[2];
    final selectedCategory = selectedOptions[3];

    if (selectedMarket != null && selectedCategory != null) {
      final products = await _service.fetchProducts(selectedCategoryType);
      

      final filtered = products.where((product) {
        return product.filters['markets'] == selectedMarket &&
            product.filters['category'] == selectedCategory;
            // 일단 information 필터링은 제외
      }).toList();

      if (filtered.isNotEmpty) {
        setState(() {
          // 첫 번째 제품의 information 값으로 selectedInfomation 업데이트
          selectedInfomation = filtered[0].filters['information'] ?? '';
          updateCategory(filtered[0].name, filtered[0].filters);
          selectedProd = filtered;
        });
      }
    }
  }

  Future<void> _filterIndices() async {
    final selectedType = selectedOptions[2];
    final selectedCategory = selectedOptions[3];

    if (selectedType != null && selectedCategory != null) {
      final indices = await _service.fetchIndices(selectedCategoryType);

      final filtered = indices.where((indice) {
        return indice.filters['type'] == selectedType &&
            indice.filters['category'] == selectedCategory;
            // indice.filters['information'] == selectedInfomation;
      }).toList();

      if (filtered.isNotEmpty) {
        setState(() {
          updateCategory(filtered[0].name, filtered[0].filters);
          selectedProd = filtered;
        });
      }
    }
  }

  void updateCategory(String name, Map<String, String> filters) {
    setState(() {
      isLoading = true;
      final terms = filters['terms'];
      if (selectedCategoryType == '지수') {
        selectedIdxName = name;
        selectedProdCategory = filters['category']!;
        selectedProdType = filters['type']!;
        selectedDetail = filters['detail']!;
        selectedIdxDay = terms != null && terms.startsWith("D+")
            ? int.tryParse(terms.substring(2)) ?? 1
            : 1;
      } else {
        selectedProdName = name;
        selectedProdDay = terms != null && terms.startsWith("D+")
            ? int.tryParse(terms.substring(2)) ?? 1
            : 1;
      }
      isLoading = false;
    });
  }

  Widget _buildGrid<T>({
    required List<T> items,
    required String Function(T) getName,
    required Map<String, String> Function(T) getFilter,
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
            color: Colors.white,
            border: Border.all(
              color: Color(0xFFD5D5D5),
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
              final isSelected = index == selectedItemIndex;
              return Container(
                padding: const EdgeInsets.all(4),
                child: Column(
                  children: [
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: InkWell(
                          onTap: () {
                            selectedItemIndex = index;
                            updateCategory(
                                getName(items[index]), getFilter(items[index]));
                          },
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isSelected
                                    ? Color(0xFF469E79)
                                    : Colors.grey[300]!,
                              ),
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

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: [
              // 상단 버튼 영역
              Container(
                // color: const Color(0xFFF6F6F6),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // 첫 번째 행: 토글 버튼과 관리 버튼
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 토글 버튼
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  child: _buildToggleButton(
                                    '가격',
                                    selectedCategoryType == "가격",
                                    () {
                                      setState(() {
                                        selectedCategoryType = "가격";
                                        _updateCategories();
                                      });
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  child: _buildToggleButton(
                                    '지수',
                                    selectedCategoryType == "지수",
                                    () {
                                      setState(() {
                                        selectedCategoryType = "지수";
                                        _updateCategories();
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // 관리 버튼
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF575757),
                            side: const BorderSide(color: Color(0xFFD9D9D9)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                          ),
                          child: const Text('관리'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // 두 번째 행: Level2 버튼, Level3 버튼 및 그리드 요소를 catIsEmpty 상태에 따라 조건부로 보여줌
                    catIsEmpty
                        ? Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 32.0),
                              child: Text(
                                '구독 품목이 없습니다',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              Row(
                                children: _buildLevelButtons(2),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: _buildLevelButtons(3),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 1200),
                                alignment: Alignment.center,
                                child: _buildGrid<dynamic>(
                                  items: selectedProd,
                                  getName: (product) => product.name,
                                  getFilter: (product) => product.filters,
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
              Text(
                selectedIdxName,
              ),
              catIsEmpty
                  ? const Center(
                      child: Text(
                        '',
                      ),
                    )
                  : selectedCategoryType == "가격"
                      ? SubsInfoPage(
                          key: ValueKey('${selectedProdName}_${selectedProdDay}'),
                          selectedProdName: selectedProdName,
                          selectedProdDay: selectedProdDay,
                          selectedInfomation: selectedInfomation,  // selectedInfomation 값 전달
                        )
                      : SubIndexInfo(
                          key: ValueKey('${selectedIdxName}_${selectedIdxDay}_${selectedProdCategory}_${selectedProdType}_${selectedDetail}'),
                          selectedProdName: selectedIdxName,
                          selectedProdCategory: selectedProdCategory,
                          selectedProdType: selectedProdType,
                          selectedDetail: selectedDetail,
                          selectedProdDay: selectedIdxDay,
                        ),
              // 정보 영역 (스크롤 가능)
              // if (selectedCategoryType == "가격" &&
              //     !catIsEmpty &&
              //     selectedProdName != "")
              //   SubsInfoPage(
              //     selectedProdName: selectedProdName,
              //     selectedProdDay: selectedProdDay,
              //   ),
              // if (selectedCategoryType == "지수" &&
              //     !catIsEmpty &&
              //     selectedIdxName != "")
              //   SubIndexInfo(
              //     selectedProdName: selectedIdxName,
              //     selectedProdCategory: selectedProdCategory,
              //     selectedProdType: selectedProdType,
              //     selectedDetail: selectedDetail,
              //     selectedProdDay: selectedIdxDay,
              //   ),
            ],
          );
  }

  // 토글 버튼 생성 함수
  Widget _buildToggleButton(
      String title, bool isSelected, VoidCallback onPressed) {
    Color backgroundColor = Colors.white; // 기본 배경 색상
    if (isSelected) {
      if (title == '가격' || title == '지수') {
        backgroundColor = const Color(0xFF11C278);
      } else {
        backgroundColor = const Color(0xFF11C278); // 0xFF4D866E
      }
    }

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: isSelected ? Colors.white : const Color(0xFF575757),
        side: BorderSide(
            color: isSelected ? Colors.transparent : const Color(0xFFD9D9D9)),
        padding: EdgeInsets.zero,
        minimumSize: const Size(0, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
        ),
      ),
    );
  }

  // Level 버튼 생성
  List<Widget> _buildLevelButtons(int level) {
    final levelCategory = categories.firstWhere((cat) => cat.level == level);
    return List.generate(levelCategory.options.length, (index) {
      final option = levelCategory.options[index];
      final isSelected = selectedOptions[level] == option;
      return Expanded(
        child: Padding(
          padding: EdgeInsets.only(
            left: index == 0 ? 0 : 4,
            right: index == levelCategory.options.length - 1 ? 0 : 4,
          ),
          child: SizedBox(
            height: 40,
            child: _buildToggleButton(option, isSelected, () {
              setState(() {
                selectedOptions[level] = option;
                _updateCategories();
              });
            }),
          ),
        ),
      );
    });
  }
}

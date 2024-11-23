import 'package:flutter/material.dart';
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
  String selectedCategoryType = "지수";
  String? previousCategoryType;
  late Map<int, String> selectedOptions = {};
  bool isLoading = true;
  bool catIsEmpty = false;

  @override
  void initState() {
    super.initState();
    _updateCategories();
  }

  Future<void> _updateCategories() async {
    setState(() {
      isLoading = true;
    });

    final fetchedCategories =
        await _service.fetchCategories(selectedCategoryType);

    setState(() {
      categories = fetchedCategories;

      // `selectedOptions` 초기화 조건 확장
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
      print(catIsEmpty);

      // 현재 카테고리 타입을 이전 값으로 업데이트
      previousCategoryType = selectedCategoryType;
      isLoading = false;
    });

    // 필터링 호출
    selectedCategoryType == '가격' ? _filterProducts() : _filterIndices();
  }

  // 필터링된 selectedProd 리스트
  List<dynamic> selectedProd = [];

  // 가격 - markets와 category 파라미터를 기반으로 필터링
  Future<void> _filterProducts() async {
    final selectedMarket = selectedOptions[2];
    final selectedCategory = selectedOptions[3];

    if (selectedMarket != null && selectedCategory != null) {
      // CategoryService에서 fetchProducts() 호출하여 데이터를 필터링
      final products = await _service.fetchProducts(selectedCategoryType);

      setState(() {
        selectedProd = products.where((product) {
          return product.filters['markets'] == selectedMarket &&
              product.filters['category'] == selectedCategory;
        }).toList();
      });
    }
  }

  // 가격 - markets와 category 파라미터를 기반으로 필터링
  Future<void> _filterIndices() async {
    final selectedType = selectedOptions[2];
    final selectedCategory = selectedOptions[3];

    if (selectedType != null && selectedCategory != null) {
      // CategoryService에서 fetchProducts() 호출하여 데이터를 필터링
      final indices = await _service.fetchIndices(selectedCategoryType);

      setState(() {
        selectedProd = indices.where((indice) {
          return indice.filters['type'] == selectedType &&
              indice.filters['category'] == selectedCategory;
        }).toList();
      });
    }
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
              return Container(
                padding: const EdgeInsets.all(4),
                child: Column(
                  children: [
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: InkWell(
                          onTap: () {
                            setState(() {});
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
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
              // 정보 영역 (스크롤 가능)
              if (!catIsEmpty)
                selectedCategoryType == "가격" ? SubsInfoPage() : SubIndexInfo(),
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
              fontSize: 16,
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

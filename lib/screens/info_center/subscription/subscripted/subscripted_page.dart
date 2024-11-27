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
  late List<Category> categories;
  bool isPriceSelected = true;

  // 선택 상태를 관리하는 변수
  late Map<int, String> selectedOptions;

  @override
  void initState() {
    super.initState();
    _updateCategories();
  }

  // 카테고리 및 선택 옵션 초기화
  void _updateCategories() {
    categories = isPriceSelected ? _service.getPriceCategories() : _service.getIndexCategories();
    selectedOptions = {
      2: categories
          .firstWhere((cat) => cat.level == 2)
          .options
          .first, // Level 2의 첫 번째 옵션
      3: categories
          .firstWhere((cat) => cat.level == 3)
          .options
          .first, // Level 3의 첫 번째 옵션
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 상단 버튼 영역
        Container(
          color: const Color(0xFFF6F6F6),
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 토글 버튼
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: _buildToggleButton('가격', isPriceSelected, () {
                          setState(() {
                            isPriceSelected = true;
                            _updateCategories(); // '가격' 카테고리로 업데이트
                          });
                        }),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: _buildToggleButton('지수', !isPriceSelected, () {
                          setState(() {
                            isPriceSelected = false;
                            _updateCategories(); // '지수' 카테고리로 업데이트
                          });
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // 관리 버튼
              TextButton(
                onPressed: () {
                  // 관리 버튼 기능
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF575757),
                  side: const BorderSide(color: Color(0xFFD9D9D9)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text('관리'),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        // 2행: Level2 버튼
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: _buildLevelButtons(2),
          ),
        ),
        // 3행: Level3 버튼
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: _buildLevelButtons(3),
          ),
        ),
        // 정보 영역 (스크롤 가능)
        Expanded(
          child: isPriceSelected ? SubsInfoPage() : SubIndexInfo(),
        ),
      ],
    );
  }

  // 토글 버튼 생성 함수
  Widget _buildToggleButton(
      String title, bool isSelected, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: isSelected ? const Color(0xFF11C278) : Colors.white,
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
                selectedOptions[level] = option; // 선택된 옵션 업데이트
                print(selectedOptions);
              });
            }),
          ),
        ),
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:v3_mvp/screens/info_center/subscription/sub_index_info.dart';
import 'package:v3_mvp/screens/info_center/subscription/sub_price_info.dart';

class SubscriptedPage extends StatefulWidget {
  const SubscriptedPage({Key? key}) : super(key: key);

  @override
  State<SubscriptedPage> createState() => _SubscriptedPageState();
}

class _SubscriptedPageState extends State<SubscriptedPage> {
  bool isPriceSelected = true; // '가격' 버튼이 선택된 상태

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
                          });
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
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
        // 정보 영역 (스크롤 가능)
        Expanded(
          child: SingleChildScrollView(
            child: isPriceSelected ? SubsInfoPage() : SubIndexInfo(),
          ),
        ),
      ],
    );
  }

  // 가격 정보 표시 위젯
  Widget _buildPriceInfo() {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: const Text(
        '가격 정보 표시',
        style: TextStyle(fontSize: 18, color: Colors.black),
      ),
    );
  }

  // 지수 정보 표시 위젯
  Widget _buildIndexInfo() {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: const Text(
        '지수 정보 표시',
        style: TextStyle(fontSize: 18, color: Colors.black),
      ),
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
}

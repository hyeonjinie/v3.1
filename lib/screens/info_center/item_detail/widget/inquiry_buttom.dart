import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../Inquiry/inquiry_screen.dart';

class InquiryButton extends StatelessWidget {
  final Map<String, dynamic> item; // 문의하기 페이지로 전달할 아이템 정보
  final String currentGrade;

  InquiryButton({required this.item, required this.currentGrade});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        width: screenWidth > 1200 ? 1200 : screenWidth,
        child: Align(
          alignment: Alignment.bottomRight, // 하단 오른쪽에 위치
          child: Padding(
            padding: EdgeInsets.all(40), // 적당한 여백을 제공
            child: Card(
              color: Color(0xFF00AF66), // 카드의 배경색을 지정
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InquiryScreen(item: item, currentGrade: currentGrade),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  child: Text("문의하기", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)), // 글자색은 흰색으로 지정
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

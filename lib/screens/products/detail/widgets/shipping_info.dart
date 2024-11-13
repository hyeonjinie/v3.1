import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'info_row.dart';

class ShippingInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        width: kIsWeb && screenWidth > 1200 ? 1200 : screenWidth,
        decoration: const BoxDecoration(
          // border: Border.all(color: Colors.grey),
          // borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          children: [
            Divider(height: 1, color: Colors.grey),
            InfoRow(title: '배송', content: '택배(무료)'),
            // Divider(height: 1, color: Colors.grey),
            InfoRow(title: '배송기간 안내', content: '결제하신 다음 날로부터 주말/공휴일을 제외한 평일 기준 2~3일 이내로 발송됩니다.'),
            // Divider(height: 1, color: Colors.grey),
            InfoRow(title: '상품 안내', content: '8G 이상. 모양이 불규칙하거나 다소 덜 익은 딸기가 포함될 수 있습니다.'),
            Divider(height: 1, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

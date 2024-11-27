import 'package:flutter/material.dart';
import 'package:v3_mvp/screens/info_center/subscription/new_subscription/models/selection.dart';

import 'new_subscription.dart';

class SubscriptionSummaryPage extends StatelessWidget {
  final List<dynamic> selectedItems;
  final double totalPrice;

  const SubscriptionSummaryPage({
    Key? key,
    required this.selectedItems,
    required this.totalPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('구독 정보 확인'),
        backgroundColor: const Color(0xFF1E357D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '결제 금액',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${totalPrice.toStringAsFixed(0).replaceAllMapped(
                RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
                    (match) => '${match[1]},',
              )}원',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            const Text(
              '구독 품목',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: selectedItems.length,
                itemBuilder: (context, index) {
                  final item = selectedItems[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      title: Text(item is ProductSelection ? item.product.name : item.index.name),
                      subtitle: Text('구분: ${item is ProductSelection ? '가격' : '지수'}\n'
                          '기간: ${item.term}\n'
                          '시장: ${item is ProductSelection ? item.market : item.type}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

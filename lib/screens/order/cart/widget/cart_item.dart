import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CartItemWidget extends StatelessWidget {
  final Map<String, dynamic> item;
  final bool isSelected;
  final Function(bool?) onItemToggled;
  final Function(int) onQuantityUpdated;
  final Function() onDelete;

  const CartItemWidget({
    Key? key,
    required this.item,
    required this.isSelected,
    required this.onItemToggled,
    required this.onQuantityUpdated,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemQuantity = item['quantity'] ?? 1;
    final numberFormat = NumberFormat("#,###", "en_US");

    return Container(
      width: kIsWeb ? 1200 : MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              color: const Color(0xFFDEE6FF),
              padding: const EdgeInsets.all(1.0),
              child: Row(
                children: [
                  Checkbox(
                    value: isSelected,
                    onChanged: onItemToggled,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 8.0),
                      Image.network(
                        item['productImageUrl'] ?? '',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['productName'] ?? '',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4.0),
                            if (item['wholesalePrice'] != null)
                              Text(
                                '${numberFormat.format(item['wholesalePrice'])}원',
                                style: const TextStyle(
                                  fontSize: 16,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            const SizedBox(height: 4.0),
                            Text(
                              '${numberFormat.format(item['bgoodPrice'] ?? 0)}원',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    if (itemQuantity > 1) {
                                      onQuantityUpdated(itemQuantity - 1);
                                    }
                                  },
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  color: Colors.white,
                                  child: Text('$itemQuantity'),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    onQuantityUpdated(itemQuantity + 1);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              const Text('상품금액: '),
                              Text(
                                '${numberFormat.format((item['bgoodPrice'] ?? 0) * itemQuantity)}원',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          const Text('배송비: 무료'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final bool isWeb;

  const OrderCard({Key? key, required this.order, required this.isWeb}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat("#,###", "en_US");
    final item = order['items'][0];
    final status = order['status'] ?? 'Unknown Status';
    final paymentStatus = status == '입금전' ? '미입금' : '입금완료';
    final paymentStatusColor = status == '입금전' ? Colors.red : Colors.green;

    double screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        width: isWeb && screenWidth > 1200 ? 1200 : screenWidth,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(color: Color(0xFFDEE6FF)),
            ),
            elevation: 4,
            child: Column(
              children: [
                Container(
                  color: Color(0xFFF5F8FF),
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Text(
                        status == '입금전' ? '결제 필요' : status,
                        style: TextStyle(
                          fontSize: isWeb ? 18 : 14,
                          color: status == '입금전' ? Colors.red : Color(0xFF4470F6),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Text(
                        DateFormat('yyyy.MM.dd').format(order['orderDate'].toDate()),
                        style: TextStyle(fontSize: isWeb ? 18 : 14),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFDEE6FF)),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['productName'] ?? 'Unknown Product',
                        style: TextStyle(
                          fontSize: isWeb ? 22 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                Row(
                                  children: [
                                    Text(
                                      '${numberFormat.format(item['bgoodPrice'] ?? 0)}원',
                                      style: TextStyle(
                                        fontSize: isWeb ? 22 : 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    const SizedBox(width: 16.0),
                                    if ((item['wholesalePrice'] ?? 0) != 0)
                                      Text(
                                        '${numberFormat.format(item['wholesalePrice'] ?? 0)}원',
                                        style: TextStyle(
                                          fontSize: isWeb ? 18 : 14,
                                          decoration: TextDecoration.lineThrough,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4.0),
                                Row(
                                  children: [
                                    Text(
                                      '수량',
                                      style: TextStyle(fontSize: isWeb ? 20 : 16),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    Spacer(),
                                    Text(
                                      '${item['quantity']}개',
                                      style: TextStyle(fontSize: isWeb ? 20 : 16),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '배송비',
                                      style: TextStyle(fontSize: isWeb ? 20 : 16),
                                    ),
                                    Text(
                                      '무료',
                                      style: TextStyle(
                                        fontSize: isWeb ? 20 : 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Divider(),
                      SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '총 결제금액',
                            style: TextStyle(fontSize: isWeb ? 20 : 16),
                          ),
                          Text(
                            '${numberFormat.format((item['bgoodPrice'] ?? 0) * item['quantity'])}원',
                            style: TextStyle(
                              fontSize: isWeb ? 22 : 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildRow('주문자', order['userName'], isWeb: isWeb),
                            SizedBox(height: 4.0),
                            _buildRow('배송지', order['userAddress'], isWeb: isWeb),
                            SizedBox(height: 4.0),
                            _buildRow('결제방법', '무통장 입금', isWeb: isWeb),
                            SizedBox(height: 4.0),
                            _buildRow('입금 계좌 정보', '우리은행 0000-000-000000', isWeb: isWeb),
                            SizedBox(height: 4.0),
                            _buildRow('예금주명', '에스앤이컴퍼니', isWeb: isWeb),
                            SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '입금상태',
                                  style: TextStyle(fontSize: isWeb ? 16 : 12),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                Text(
                                  paymentStatus,
                                  style: TextStyle(
                                    fontSize: isWeb ? 16 : 12,
                                    color: paymentStatusColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {required bool isWeb}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: isWeb ? 16 : 12),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        SizedBox(width: 8.0),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: isWeb ? 16 : 12),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

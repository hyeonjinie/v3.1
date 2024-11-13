import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../domain/models/custom_user.dart';
import '../../../../widgets/address_search/address_search.dart';
import '../../order_history/order_history_screen.dart';
import '../cart_notifier.dart';

class OrderSummary extends StatelessWidget {
  final CustomUser customUser;
  final CartNotifier cartNotifier;
  final NumberFormat numberFormat;

  OrderSummary({
    required this.customUser,
    required this.cartNotifier,
    required this.numberFormat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${customUser.companyName}\n${customUser.businessAddress}',
                  style: const TextStyle(fontSize: 16),
                  overflow: TextOverflow.visible,
                ),
              ),
              TextButton(
                onPressed: () {
                  _showAddressDialog(context, customUser);
                },
                style: TextButton.styleFrom(
                  side: BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  '변경',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('총 주문 금액', style: TextStyle(fontSize: 18)),
              Text('${numberFormat.format(cartNotifier.calculateTotalOriginalAmount())}원',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('총 배송비', style: TextStyle(fontSize: 16)),
              Text('0원', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('총 할인', style: TextStyle(fontSize: 16)),
              Text(
                '-${numberFormat.format(cartNotifier.calculateTotalDiscount())}원',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
              ),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('총 결제금액', style: TextStyle(fontSize: 18)),
              Text('${numberFormat.format(cartNotifier.calculateTotalAmount())}원',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final selectedItems = cartNotifier.selectedItems.entries
                  .where((entry) => entry.value)
                  .map((entry) => entry.key)
                  .toList();

              if (selectedItems.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('선택된 항목이 없습니다.')),
                );
                return;
              }

              final orderItems = cartNotifier.cartItems
                  .where((item) => selectedItems.contains(item['id']))
                  .toList();

              // 주문 데이터 저장
              await FirebaseFirestore.instance
                  .collection('orderhistory')
                  .add({
                'userId': customUser.uid,
                'orderDate': Timestamp.now(),
                'status': '입금전',
                'items': orderItems,
                'userName': customUser.companyName,
                'userAddress': customUser.businessAddress,
              });

              await FirebaseFirestore.instance
                  .collection('client')
                  .doc(customUser.uid)
                  .collection('orderhistory')
                  .add({
                'orderDate': Timestamp.now(),
                'status': '입금전',
                'items': orderItems,
                'userName': customUser.companyName,
                'userAddress': customUser.businessAddress,
              });

              // 장바구니에서 선택된 아이템 삭제
              final batch = FirebaseFirestore.instance.batch();
              for (var itemId in selectedItems) {
                final cartItemRef = FirebaseFirestore.instance
                    .collection('client')
                    .doc(customUser.uid)
                    .collection('cart')
                    .doc(itemId);
                batch.delete(cartItemRef);
              }
              await batch.commit();

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrderHistoryScreen()),
              );
            },
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text('바로 구매',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF00AF66),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddressDialog(BuildContext context, CustomUser customUser) {
    final TextEditingController addressController = TextEditingController();
    final TextEditingController detailAddressController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          title: Text(
            '주소 변경',
            style: TextStyle(color: Colors.black),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  hintText: '새로운 주소를 입력하세요',
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  if (!kIsWeb) {
                    String? address = await AddressSearch.searchAddress(context);
                    if (address != null) {
                      addressController.text = address;
                    }
                  }
                },
              ),
              SizedBox(height: 10),
              TextField(
                controller: detailAddressController,
                decoration: InputDecoration(
                  hintText: '나머지 주소를 입력하세요',
                  border: OutlineInputBorder(),
                ),
              ),
              if (!kIsWeb)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      String? address = await AddressSearch.searchAddress(context);
                      if (address != null) {
                        addressController.text = address;
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      '검색',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                '취소',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                customUser.businessAddress =
                '${addressController.text} ${detailAddressController.text}';
                Navigator.of(context).pop();

                // Firestore에 저장하는 로직 추가
                FirebaseFirestore.instance
                    .collection('client')
                    .doc(customUser.uid)
                    .update({
                  'businessAddress':
                  '${addressController.text} ${detailAddressController.text}',
                });
              },
              child: Text(
                '확인',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}
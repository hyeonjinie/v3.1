import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:v3_mvp/domain/models/custom_user.dart';
import 'package:v3_mvp/screens/order/cart/cart_notifier.dart';
import 'package:v3_mvp/screens/order/order_history/order_history_screen.dart';

class CartPurchaseHelper {
  static Future<void> purchaseItems({
    required BuildContext context,
    required CustomUser customUser,
    required CartNotifier cartNotifier,
  }) async {
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
    await FirebaseFirestore.instance.collection('orderhistory').add({
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
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/sd_order.dart';

class OrderProvider with ChangeNotifier {
  List<SdOrder> _orders = [];

  List<SdOrder> get orders => _orders;

  Future<void> fetchOrders(String userId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('client')
          .doc(userId)
          .collection('sundohistory')
          .get();

      _orders = snapshot.docs.map((doc) {
        print('Document ID: ${doc.id}'); // 문서 ID 출력
        return SdOrder.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      notifyListeners();
    } catch (error) {
      print('Error fetching orders: $error');
    }
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'order_card.dart';

class OrderHistoryBody extends StatelessWidget {
  final String uid;
  final bool isInProgress;

  const OrderHistoryBody({Key? key, required this.uid, required this.isInProgress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isWeb = screenWidth > 600;

    return Container(
      constraints: isWeb ? BoxConstraints(maxWidth: 800) : null,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('client')
            .doc(uid)
            .collection('orderhistory')
            .where('status', whereIn: isInProgress
            ? ['입금전', '상품준비중', '배송준비중', '배송중']
            : ['배송완료'])
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index].data() as Map<String, dynamic>;
              return OrderCard(order: order, isWeb: isWeb);
            },
          );
        },
      ),
    );
  }
}

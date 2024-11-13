import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:v3_mvp/screens/order/order_history/widget/order_history_body.dart';

import '../../../../widgets/font_size_helper/font_size_helper.dart';

class OrderHistoryTabs extends StatelessWidget {
  final String uid;

  const OrderHistoryTabs({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: DefaultTabController(
        length: 2,
        child: Container(
          width: screenWidth > 1200 ? 1200 : screenWidth,
          child: Column(
            children: [
              PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
                child: Container(
                  color: Colors.white,
                  child: TabBar(
                    indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(width: 4.0, color: Colors.green),
                      insets: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    labelStyle: TextStyle(
                        fontSize: getFontSize(context, FontSizeType.medium),
                        fontWeight: FontWeight.bold),
                    tabs: [
                      Tab(text: '진행 중'),
                      Tab(text: '완료'),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    OrderHistoryBody(uid: uid, isInProgress: true),
                    OrderHistoryBody(uid: uid, isInProgress: false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
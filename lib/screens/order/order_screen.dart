/*
주문 페이지 : 메인 주문 및 서브 주문서 확인 
- '주문'탭에 대한 페이지만 생성, '완료'탭은 주문 완전히 종료 시 카드 이동으로 구현 필요
- 관련 파일
  - model/order_content.dart 
  - order_provider.dart : MockData 생성
  - screen/order_progress : 주문 진행 페이지로 이동 
*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:v3_mvp/domain/models/sd_order.dart';
import 'package:v3_mvp/screens/auth/login/login_screen.dart';

import '../../domain/models/sd_sub_order.dart';
import '../../services/auth_provider.dart';
import '../../services/provider/order_provider.dart';
import '../Inquiry/order_progress.dart';
import '../auth/user_profile/mypage.dart';

class OrderListPage extends StatefulWidget {
  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProviderService>(context).user;
    if (user == null) return LoginScreen();

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Scaffold(
          appBar: AppBar(
            title: Text(''),
            bottom: TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[700],
              labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              unselectedLabelStyle: TextStyle(fontSize: 16),
              indicatorColor: Color(0xFF00AF66),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
              tabs: [
                Tab(text: '주문'),
                Tab(text: '완료'),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 5, right: 16),
                child: IconButton(
                  icon: Icon(Icons.person_outline, color: Color(0xFF00AF66)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyPage()),
                    );
                  },
                ),
              ),
            ],
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              OrderListWidget(),
              Center(child: Text('내용없음')),
            ],
          ),
        ),
      ),
    );
  }
}

// 주문 리스트 생성 
class OrderListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        return ListView.builder(
          itemCount: orderProvider.orders.length,
          itemBuilder: (context, index) {
            return OrderCard(order: orderProvider.orders[index]);
          },
        );
      },
    );
  }
}

// 주문 건 생성(메인 + 서브)
class OrderCard extends StatefulWidget {
  final SdOrder order;

  OrderCard({required this.order});

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');
    return Card(
      color: Color(0xFFF6F6F6),
      child: Column(
        children: [
          // 메인 주문
          ListTile(
            title: Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 10.0),
              child: Row(
                children: [
                  Image.asset(
                    'assets/document.png',
                    height: 25,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Text(
                      widget.order.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more),
                    onPressed: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                  ),
                ],
              ),
            ),
            subtitle: Padding(
              padding:
              const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.order.itemName} | ${widget.order.variety}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      children: [
                        const Text(
                          '누적 주문 횟수\n누적 거래량',
                          style: TextStyle(
                            color: Color(0xFF4F4F4F),
                            fontSize: 14,
                            height: 1.6,
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: RichText(
                              textAlign: TextAlign.right,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${widget.order.orderCount}',
                                    style: const TextStyle(
                                      color: Color(0xFF4470F6),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' / ${widget.order.totalCount} 회 \n',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      height: 1.6,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '${formatter.format(widget.order.volume)}',
                                    style: const TextStyle(
                                      color: Color(0xFF4470F6),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' / ${formatter.format(widget.order.totalVolume)} kg',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.go('/order_progress', extra: {'order': widget.order, 'documentId': widget.order.documentId});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF00AF66),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      minimumSize: Size(double.infinity, 40),
                    ),
                    child: const Text(
                      '주문하기',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                ],
              ),
            ),
            // trailing:
          ),
          // 서브 주문
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 20.0),
                  child: Column(
                    children:
                    widget.order.subOrders.asMap().entries.map((entry) {
                      int index = entry.key + 1;
                      SubOrder subOrder = entry.value;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${index}회차 주문',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                width: 77,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    width: 1,
                                    color: _getStatusColor(subOrder.status),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '${subOrder.status}',
                                    style: TextStyle(
                                      color: _getStatusColor(subOrder.status),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '주문량\n거래금액\n희망배송일\n배송완료일\n배송지',
                                style: TextStyle(
                                  color: Color(0xFF8B8B8B),
                                  fontSize: 14,
                                  height: 1.8,
                                ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              Expanded(
                                child: Text(
                                  '${formatter.format(subOrder.quantity)}kg\n${formatter.format(subOrder.amount)}원\n${subOrder.deliveryDate}\n${subOrder.completedDate}\n${subOrder.address}',
                                  style: const TextStyle(
                                    color: Color(0xFF4F4F4F),
                                    fontSize: 14,
                                    height: 1.8,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.0),
                            child: Divider(),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // 주문 상태에 따라 색상 다르게 설정
  Color _getStatusColor(String status) {
    switch (status) {
      case '배송완료':
        return Color(0xFF00AF66);
      case '배송예정':
        return Color(0xFF4470F6);
      default:
        return Color(0xFF8B8B8B);
    }
  }
}

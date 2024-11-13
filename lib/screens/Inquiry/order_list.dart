import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:v3_mvp/widgets/font_size_helper/font_size_helper.dart';
import '../../../services/auth_provider.dart';
import '../../../widgets/custom_appbar/custom_appbar.dart';
import '../../domain/models/sd_sub_order.dart';
import '../../widgets/navigation_helper.dart';
import '../../domain/models/sd_order.dart';
import '../../services/provider/order_provider.dart';
import 'order_progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import this for Timestamp

class OrderListScreen extends StatefulWidget {
  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 3;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    final user = Provider.of<AuthProviderService>(context, listen: false).user;
    if (user != null) {
      Provider.of<OrderProvider>(context, listen: false).fetchOrders(user.uid);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _updateIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (kIsWeb) {
          if (constraints.maxWidth > 660) {
            return Scaffold(
              key: _scaffoldKey,
              appBar: CustomAppBar(
                scaffoldKey: _scaffoldKey,
                selectedIndex: _selectedIndex,
                onItemTapped: (index) =>
                    NavigationHelper.onItemTapped(context, index, _updateIndex),
              ),
              body: _buildBody(),
            );
          } else {
            return Scaffold(
              key: _scaffoldKey,
              appBar: CustomAppBar(
                // Ensure CustomAppBar is shown for 660 or less
                scaffoldKey: _scaffoldKey,
                selectedIndex: _selectedIndex,
                onItemTapped: (index) =>
                    NavigationHelper.onItemTapped(context, index, _updateIndex),
              ),
              body: _buildBody(),
              bottomNavigationBar: _buildBottomNavigationBar(),
            );
          }
        } else {
          return Scaffold(
            key: _scaffoldKey,
            appBar: CustomAppBar(
              scaffoldKey: _scaffoldKey,
              selectedIndex: _selectedIndex,
              onItemTapped: (index) =>
                  NavigationHelper.onItemTapped(context, index, _updateIndex),
            ),
            body: _buildBody(),
            bottomNavigationBar: _buildBottomNavigationBar(),
          );
        }
      },
    );
  }

  Widget _buildBody() {
    final user = Provider.of<AuthProviderService>(context).user;
    double screenWidth = MediaQuery.of(context).size.width;
    double horizontalInset = screenWidth * 0.1;
    if (horizontalInset < 20) horizontalInset = 20;
    if (horizontalInset > 300) horizontalInset = 300;

    return DefaultTabController(
      length: 2,
      child: Center(
        child: SizedBox(
          width: screenWidth > 1200 ? 1200 : screenWidth,
          child: Column(
            children: <Widget>[
              TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey[700],
                labelStyle: TextStyle(
                    fontSize: getFontSize(context, FontSizeType.medium),
                    fontWeight: FontWeight.bold),
                unselectedLabelStyle: TextStyle(
                    fontSize: getFontSize(context, FontSizeType.medium)),
                indicatorColor: Color(0xFF00AF66),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
                tabs: [
                  Tab(text: '주문'),
                  Tab(text: '완료'),
                ],
              ),
              if (user != null)
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildOrderList(context),
                      Center(child: Text('주문 내역이 없습니다.')),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: _icon(0, 'assets/bg_svg/icon-home.svg'),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: _icon(1, 'assets/bg_svg/information_center.svg'),
          label: '정보센터',
        ),
        BottomNavigationBarItem(
          icon: _icon(2, 'assets/bg_svg/question.svg'),
          label: '문의관리',
        ),
        BottomNavigationBarItem(
          icon: _icon(3, 'assets/bg_svg/icon-order_manage.svg'),
          label: '주문관리',
        ),
        BottomNavigationBarItem(
          icon: _icon(4, 'assets/bg_svg/mdi_cart.svg'),
          label: '비굿마켓',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      onTap: (index) =>
          NavigationHelper.onItemTapped(context, index, _updateIndex),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    );
  }

  Widget _icon(int index, String assetName) {
    return SvgPicture.asset(
      assetName,
      width: 24,
      color: _selectedIndex == index ? Colors.green : Colors.grey,
    );
  }

  Widget _buildOrderList(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        final orders = orderProvider.orders;
        if (orders.isEmpty) {
          return Center(child: Text('주문 내역이 없습니다.'));
        }
        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            return OrderCard(order: orders[index]);
          },
        );
      },
    );
  }
}

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
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Card(
        color: Color(0xFFF6F6F6),
        child: Column(
          children: [
            ListTile(
              title: Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/png/document.png',
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
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, bottom: 10.0),
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
                            '주문 횟수',
                            style: TextStyle(
                              color: Color(0xFF4F4F4F),
                              fontSize: 14,
                              height: 1.6,
                            ),
                          ),
                          Spacer(),
                          Text(
                            '${widget.order.orderCount} 회',
                            style: const TextStyle(
                              color: Color(0xFF4470F6),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          children: [
                            const Text(
                              '누적거래량',
                              style: TextStyle(
                                color: Color(0xFF4F4F4F),
                                fontSize: 14,
                                height: 1.6,
                              ),
                            ),
                            Spacer(),
                            Text(
                              '${widget.order.volume} kg',
                              style: const TextStyle(
                                color: Color(0xFF4470F),
                              ),
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 10.0,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        print('Order: ${widget.order}'); // Order 데이터 출력
                        print('Document ID: ${widget.order.documentId}'); // Document ID 출력
                        context.go('/order_progress', extra: {
                          'order': widget.order,
                          'documentId': widget.order.documentId,
                        });
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
            ),
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20.0),
                    child: widget.order.subOrders.isEmpty
                        ? Center(child: Text('주문 내역이 없습니다.'))
                        : Column(
                      children: widget.order.subOrders
                          .asMap()
                          .entries
                          .map((entry) {
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
                                    borderRadius:
                                    BorderRadius.circular(50),
                                    border: Border.all(
                                      width: 1,
                                      color: _getStatusColor(
                                          subOrder.status),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${subOrder.status}',
                                      style: TextStyle(
                                        color: _getStatusColor(
                                            subOrder.status),
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
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
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
                                    '${formatter.format(subOrder.quantity)}kg\n${formatter.format(subOrder.amount)}원\n${_formatDate(subOrder.deliveryDate)}\n${_formatDate(subOrder.completedDate)}\n${subOrder.address}',
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
                              padding:
                              EdgeInsets.symmetric(vertical: 5.0),
                              child: Divider(),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            SizedBox(height: 16,),
          ],
        ),
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date is Timestamp) {
      final DateTime dateTime = date.toDate();
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      return formatter.format(dateTime);
    } else if (date is String) {
      return date;
    } else {
      return '-';
    }
  }

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

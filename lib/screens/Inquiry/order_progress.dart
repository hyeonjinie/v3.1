import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../services/auth_provider.dart';
import '../../../widgets/custom_appbar/custom_appbar.dart';
import '../../../widgets/navigation_helper.dart';
import '../../domain/models/sd_order.dart';
import '../../domain/models/sd_sub_order.dart';

class OrderProgressPage extends StatefulWidget {
  final SdOrder order;
  final String documentId;

  const OrderProgressPage({Key? key, required this.order, required this.documentId}) : super(key: key);

  @override
  State<OrderProgressPage> createState() => _OrderProgressPageState();
}

class _OrderProgressPageState extends State<OrderProgressPage> with SingleTickerProviderStateMixin {
  late TextEditingController amountController;
  late TextEditingController deliveryDateController;
  late TextEditingController deliveryMsgController;
  late DateTime selectedDate;
  late SdOrder _order;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 3;

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController();
    deliveryDateController = TextEditingController();
    deliveryMsgController = TextEditingController();
    selectedDate = DateTime.now();
    _order = widget.order;

    // Print documentId to verify it
    print('Document ID in OrderProgressPage: ${widget.documentId}');
  }

  @override
  void dispose() {
    amountController.dispose();
    deliveryDateController.dispose();
    deliveryMsgController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        deliveryDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
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
                onItemTapped: (index) => NavigationHelper.onItemTapped(context, index, _updateIndex),
              ),
              body: _buildBody(),
            );
          } else {
            return Scaffold(
              key: _scaffoldKey,
              appBar: CustomAppBar(
                scaffoldKey: _scaffoldKey,
                selectedIndex: _selectedIndex,
                onItemTapped: (index) => NavigationHelper.onItemTapped(context, index, _updateIndex),
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
              onItemTapped: (index) => NavigationHelper.onItemTapped(context, index, _updateIndex),
            ),
            body: _buildBody(),
            bottomNavigationBar: _buildBottomNavigationBar(),
          );
        }
      },
    );
  }

  Widget _buildBody() {
    final formatter = NumberFormat('#,###');
    final user = Provider.of<AuthProviderService>(context).user;

    if (user == null) {
      return Center(child: Text('사용자 정보를 불러올 수 없습니다.'));
    }

    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 50,
                color: const Color(0xFFF5F8FF),
                child: Center(
                  child: Text(
                    '${_order.orderCount + 1}회차 주문',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _order.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      '${_order.itemName} | ${_order.variety}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF004629),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          '총 거래수량\n거래기간\n원산지',
                          style: TextStyle(
                            color: Color(0xFF8B8B8B),
                            fontSize: 14,
                            height: 1.8,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${formatter.format(_order.totalVolume)}kg\n${_order.startDate} - ${_order.endDate}\n${_order.origin}',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Color(0xFF4F4F4F),
                              fontSize: 14,
                              height: 1.8,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '주문 가능 수량',
                          style: TextStyle(
                            color: Color(0xFF4F4F4F),
                            fontSize: 16,
                            height: 3.0,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${formatter.format(_order.totalVolume - _order.volume)}kg',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Color(0xFF4470F6),
                              fontSize: 16,
                              height: 3.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    Text('희망 물량(kg)', style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),),
                    SizedBox(height: 5,),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFD5D5D5).withOpacity(0.30),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: amountController,
                        decoration: const InputDecoration(
                          hintText: '희망 물량을 kg 단위로 입력해 주세요',
                          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(height: 20,),
                    Text('희망 배송일', style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),),
                    SizedBox(height: 5,),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFD5D5D5).withOpacity(0.30),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: deliveryDateController,
                        decoration: InputDecoration(
                          hintText: '희망 배송일을 선택해 주세요',
                          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () {
                              _selectDate(context);
                            },
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        onTap: () {
                          _selectDate(context);
                        },
                        readOnly: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0, bottom: 10.0),
                      child: Row(
                        children: [
                          const Text(
                            '배송지',
                            style: TextStyle(
                              color: Color(0xFF323232),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacer(),
                          // OutlinedButton(
                          //   onPressed: () {},
                          //   style: OutlinedButton.styleFrom(
                          //     side: BorderSide(color: Color(0xFF8B8B8B)),
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(5),
                          //     ),
                          //     minimumSize: Size(40, 30),
                          //   ),
                          //   child: const Text(
                          //     '등록/변경',
                          //     style: TextStyle(color: Color(0xFF323232)),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 100,
                          child: Text(
                            '주문자\n연락처\n주소',
                            style: TextStyle(
                              color: Color(0xFF8B8B8B),
                              fontSize: 14,
                              height: 1.8,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${user.companyName}\n${user.contactPersonPhoneNumber}\n${user.deliveryAddress}',
                            style: TextStyle(
                              color: Color(0xFF323232),
                              fontSize: 14,
                              height: 1.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 100,
                          height: 80,
                          child: Text(
                            '배송메시지',
                            style: TextStyle(
                              color: Color(0xFF8B8B8B),
                              fontSize: 14,
                              height: 1.8,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: Color(0xFFD5D5D5).withOpacity(0.30),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              controller: deliveryMsgController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    ElevatedButton(
                      onPressed: () {
                        if (widget.documentId.isNotEmpty) {
                          _createSubOrder(widget.documentId);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('문서 ID가 유효하지 않습니다.')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF00AF66),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        minimumSize: Size(double.infinity, 50),
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
                    SizedBox(height: 40,),
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
      onTap: (index) => NavigationHelper.onItemTapped(context, index, _updateIndex),
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

  void _createSubOrder(String documentId) async {
    final user = Provider.of<AuthProviderService>(context, listen: false).user;

    if (user == null) {
      return;
    }

    final int quantity = int.parse(amountController.text);
    final int amount = quantity * _order.price;

    final newSubOrder = SubOrder(
      quantity: quantity,
      amount: amount,
      deliveryDate: deliveryDateController.text,
      completedDate: '',
      address: user.deliveryAddress ?? '',
      status: '주문확인중',
      assignedAdmin: '',
    );

    try {
      // Order의 실제 문서 ID를 사용하여 문서 참조를 생성합니다.
      final orderDocRef = FirebaseFirestore.instance
          .collection('client')
          .doc(user.uid)
          .collection('sundohistory')
          .doc(documentId); // 실제 문서 ID 사용

      final orderDocSnapshot = await orderDocRef.get();

      if (orderDocSnapshot.exists) {
        print('문서가 존재합니다: ${orderDocSnapshot.id}');

        // 문서를 업데이트합니다.
        await orderDocRef.update({
          'subOrders': FieldValue.arrayUnion([newSubOrder.toMap()]),
          'orderCount': FieldValue.increment(1),
          'volume': FieldValue.increment(newSubOrder.quantity),
        });

        setState(() {
          _order.subOrders.add(newSubOrder);
          _order.orderCount++;
          _order.volume += newSubOrder.quantity;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('주문이 성공적으로 추가되었습니다.')),
        );
      } else {
        print('Error: Document does not exist');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('문서를 찾을 수 없습니다.')),
        );
      }
    } catch (e) {
      print('Error adding sub order: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('주문 추가 중 오류가 발생했습니다.')),
      );
    }
  }
}

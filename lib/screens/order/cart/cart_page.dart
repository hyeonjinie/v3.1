import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:v3_mvp/screens/order/cart/widget/cart_item.dart';
import 'package:v3_mvp/screens/order/cart/widget/cart_purchase_helper.dart';
import '../../../domain/models/custom_user.dart';
import '../../../services/auth_provider.dart';
import '../../../services/firestore_service.dart';
import '../../../widgets/address_search/address_search.dart';
import 'cart_notifier.dart';
import '../../../widgets/custom_appbar/custom_appbar.dart';
import '../../../widgets/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import '../../../widgets/navigation_helper.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 4;

  void _updateIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProviderService>(context);
    final customUser = authProvider.user;

    double screenWidth = MediaQuery.of(context).size.width;
    bool isWeb = screenWidth > 600;
    final numberFormat = NumberFormat("#,###", "en_US");

    if (customUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('장바구니'),
        ),
        body: Center(
          child: Text('로그인이 필요합니다.'),
        ),
      );
    }

    return ChangeNotifierProvider(
      create: (_) => CartNotifier(
        firestoreService: FirestoreService(),
        userId: customUser.uid,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Scaffold(
            key: _scaffoldKey,
            appBar: CustomAppBar(
              scaffoldKey: _scaffoldKey,
              selectedIndex: _selectedIndex,
              onItemTapped: (index) =>
                  NavigationHelper.onItemTapped(context, index, _updateIndex),
            ),
            body: _buildBody(customUser, numberFormat, isWeb),
            bottomNavigationBar: constraints.maxWidth <= 660
                ? CustomBottomNavigationBar(
              selectedIndex: _selectedIndex,
              onItemTapped: (index) =>
                  NavigationHelper.onItemTapped(context, index, _updateIndex),
            )
                : null,
          );
        },
      ),
    );
  }

  Widget _buildBody(CustomUser customUser, NumberFormat numberFormat, bool isWeb) {
    return Consumer<CartNotifier>(
      builder: (context, cartNotifier, _) {
        if (cartNotifier.cartItems.isEmpty) {
          return Center(child: Text('장바구니가 비어 있습니다.'));
        }

        return Center(
          child: Container(
            width: isWeb ? 1200 : MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (var item in cartNotifier.cartItems)
                    CartItemWidget(
                      item: item,
                      isSelected: cartNotifier.selectedItems[item['id']] ?? false,
                      onItemToggled: (isSelected) {
                        cartNotifier.toggleSelection(item['id'], isSelected ?? false);
                      },
                      onQuantityUpdated: (quantity) {
                        cartNotifier.updateQuantity(item['id'], quantity);
                      },
                      onDelete: () {
                        cartNotifier.deleteItem(item['id']);
                      },
                    ),
                  Container(
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
                                style: TextStyle(fontSize: 16),
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
                            await CartPurchaseHelper.purchaseItems(
                              context: context,
                              customUser: customUser,
                              cartNotifier: cartNotifier,
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
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
                customUser.businessAddress = '${addressController.text} ${detailAddressController.text}';
                Navigator.of(context).pop();

                // Firestore에 저장하는 로직 추가
                FirebaseFirestore.instance.collection('client').doc(customUser.uid).update({
                  'businessAddress': '${addressController.text} ${detailAddressController.text}',
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../domain/models/custom_user.dart';
import '../../../../domain/models/product.dart';
import '../../../../widgets/address_search/address_search.dart';
import '../../../../widgets/font_size_helper/font_size_helper.dart';

class PurchaseModal extends StatefulWidget {
  final Product product;
  final int quantity;
  final CustomUser? customUser;
  final ValueChanged<int>? onAddToCart;
  final Function(int, String)? onPurchase;
  final bool showAllFields;
  final bool isWeb;

  const PurchaseModal({
    Key? key,
    required this.product,
    required this.quantity,
    required this.customUser,
    this.onAddToCart,
    this.onPurchase,
    this.showAllFields = true,
    required this.isWeb,
  }) : super(key: key);

  @override
  _PurchaseModalState createState() => _PurchaseModalState();
}

class _PurchaseModalState extends State<PurchaseModal> {
  late int quantity;
  late TextEditingController quantityController;
  TextEditingController requestController = TextEditingController();

  @override
  void initState() {
    super.initState();
    quantity = widget.quantity;
    quantityController = TextEditingController(text: quantity.toString());

    quantityController.addListener(() {
      setState(() {
        int newQuantity = int.tryParse(quantityController.text) ?? 1;
        quantity = newQuantity < 1 ? 1 : newQuantity;
      });
    });
  }

  @override
  void dispose() {
    quantityController.dispose();
    requestController.dispose();
    super.dispose();
  }

  void _handlePurchase(BuildContext context) async {
    final customUser = widget.customUser;

    if (customUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인이 필요합니다.')),
      );
      return;
    }

    final orderData = {
      'productId': widget.product.id,
      'userId': customUser.uid,
      'orderDate': Timestamp.now(),
      'status': '입금전',
      'items': [
        {
          'productName': widget.product.productName,
          'productImageUrl': widget.product.productImageUrl,
          'bgoodPrice': widget.product.bgoodPrice,
          'quantity': quantity,
          'wholesalePrice': widget.product.wholesalePrice ?? 0,
          'discountRate': widget.product.discountRate ?? 0,
        },
      ],
      'userName': customUser.companyName,
      'userAddress': customUser.businessAddress,
      'request': requestController.text,
    };

    await FirebaseFirestore.instance.collection('orderhistory').add(orderData);

    await FirebaseFirestore.instance
        .collection('client')
        .doc(customUser.uid)
        .collection('orderhistory')
        .add(orderData);
    context.go("/product_order_list_screen");
  }

  void _handleAddToCart(BuildContext context) async {
    final customUser = widget.customUser;

    if (customUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인이 필요합니다.')),
      );
      return;
    }

    final cartData = {
      'productId': widget.product.id,
      'productName': widget.product.productName,
      'productImageUrl': widget.product.productImageUrl,
      'bgoodPrice': widget.product.bgoodPrice,
      'quantity': quantity,
      'wholesalePrice': widget.product.wholesalePrice ?? 0,
      'discountRate': widget.product.discountRate ?? 0,
    };

    await FirebaseFirestore.instance.collection('cart').add(cartData);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('장바구니 추가'),
        content: const Text('상품이 장바구니에 추가되었습니다. 장바구니로 이동하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('아니오'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/cart_screen');
            },
            child: const Text('예'),
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
          title: const Text(
            '주소 변경',
            style: TextStyle(color: Colors.black),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  hintText: '새로운 주소를 입력하세요',
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  if (!widget.isWeb || (widget.isWeb && MediaQuery.of(context).size.width <= 660)) {
                    String? address = await AddressSearch.searchAddress(context);
                    if (address != null) {
                      addressController.text = address;
                    }
                  }
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: detailAddressController,
                decoration: const InputDecoration(
                  hintText: '나머지 주소를 입력하세요',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                '취소',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                customUser.businessAddress = '${addressController.text} ${detailAddressController.text}';
                Navigator.of(context).pop();

                FirebaseFirestore.instance
                    .collection('client')
                    .doc(customUser.uid)
                    .update({
                  'businessAddress': '${addressController.text} ${detailAddressController.text}',
                });
              },
              child: const Text(
                '확인',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final customUser = widget.customUser;

    if (customUser == null) {
      return const Center(
        child: Text('사용자 정보가 필요합니다.'),
      );
    }
    final formatter = NumberFormat('#,###');

    double screenWidth = MediaQuery.of(context).size.width;
    double modalWidth = screenWidth > 1200 ? 1200 : screenWidth * 0.9;
    var wholesalePrice = (widget.product.wholesalePrice ?? 0);
    var bgoodPrice = widget.product.bgoodPrice;
    var quantity = this.quantity;
    var discountPrice = ((bgoodPrice - wholesalePrice) * quantity).round();

    return Container(
      width: modalWidth,
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Container(
            width: modalWidth,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '주소',
                style: TextStyle(
                  fontSize: getFontSize(context, FontSizeType.large),
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: modalWidth,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${customUser.companyName} ${customUser.businessAddress}',
                          style: TextStyle(
                            fontSize: getFontSize(context, FontSizeType.medium),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _showAddressDialog(context, customUser);
                  },
                  child: const Text(
                    '변경',
                    style: TextStyle(
                      color: Colors.grey,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Container(
            width: modalWidth,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '상품 정보',
                style: TextStyle(
                  fontSize: getFontSize(context, FontSizeType.large),
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: modalWidth,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.productName,
                  style: TextStyle(
                    fontSize: getFontSize(context, FontSizeType.large),
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${formatter.format(widget.product.bgoodPrice)}원',
                  style: TextStyle(
                    fontSize: getFontSize(context, FontSizeType.large),
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '할인 금액: ${formatter.format(discountPrice)}원',
                  style: TextStyle(
                    fontSize: getFontSize(context, FontSizeType.medium),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '무료 배송',
                  style: TextStyle(
                    fontSize: getFontSize(context, FontSizeType.medium),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Column(
            children: [
              Container(
                width: modalWidth,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '총 금액',
                    style: TextStyle(
                      fontSize: getFontSize(context, FontSizeType.large),
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              Container(
                width: modalWidth,
                child: Row(
                  children: [
                    Text(
                      '${formatter.format(widget.product.bgoodPrice * quantity)}원',
                      style: TextStyle(
                        fontSize: getFontSize(context, FontSizeType.large),
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if (quantity > 1) {
                                quantity--;
                                quantityController.text = quantity.toString();
                              }
                            });
                          },
                        ),
                        SizedBox(
                          width: 50,
                          child: TextField(
                            controller: quantityController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 10),
                            ),
                            onChanged: (value) {
                              setState(() {
                                int newQuantity = int.tryParse(value) ?? 1;
                                quantity = newQuantity < 1 ? 1 : newQuantity;
                              });
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              quantity++;
                              quantityController.text = quantity.toString();
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
              width:modalWidth,
              child: Divider(thickness: 2,)),
          const SizedBox(height: 8),
          if (widget.onPurchase != null)
            Container(
              width: modalWidth,
              margin: const EdgeInsets.only(bottom: 24),
              child: ElevatedButton(
                onPressed: () {
                  widget.onPurchase!(quantity, requestController.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00AF66),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  '구매하기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:v3_mvp/screens/products/detail/widgets/purchase_modal.dart';
import 'package:v3_mvp/screens/products/detail/widgets/shipping_info.dart';
import 'package:v3_mvp/screens/products/detail/widgets/action_buttons.dart';
import 'package:v3_mvp/widgets/font_size_helper/font_size_helper.dart';
import '../../../../domain/models/custom_user.dart';
import '../../../../domain/models/product.dart';
import '../../../../services/firestore_service.dart';
import '../../../order/cart/cart_notifier.dart';
import '../../../order/order_history/order_history_screen.dart';
import 'details_disclosure_and_image.dart';

class ProductInfo extends StatefulWidget {
  final Product product;
  final CustomUser? customUser;
  final bool isWeb;

  const ProductInfo({
    Key? key,
    required this.product,
    required this.customUser,
    required this.isWeb,
  }) : super(key: key);

  @override
  State<ProductInfo> createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  bool showProductInfo = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenWidth > 1200 ? 1200 : screenWidth,
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: screenWidth > 800
                  ? _buildWebLayout(context, screenWidth)
                  : _buildMobileLayout(context, screenWidth),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWebLayout(BuildContext context, double screenWidth) {
    final numberFormat = NumberFormat("#,###", "en_US");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: Image.network(
                widget.product.productImageUrl,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16), // 이미지와 텍스트 사이 간격 추가
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.productName,
                    style: TextStyle(
                      fontSize: getFontSize(context, FontSizeType.extraLarge),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      if (widget.product.wholesalePrice != null)
                        Text(
                          '${numberFormat.format(widget.product.wholesalePrice)}원',
                          style: TextStyle(
                            fontSize: getFontSize(context, FontSizeType.medium),
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      const SizedBox(width: 8.0),
                      if (widget.product.discountRate != null)
                        Text(
                          '${widget.product.discountRate}%',
                          style: TextStyle(
                            fontSize: getFontSize(context, FontSizeType.large),
                            color: Colors.green,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    '${numberFormat.format(widget.product.bgoodPrice)}원',
                    style: TextStyle(
                      fontSize: getFontSize(context, FontSizeType.extraLarge),
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ShippingInfo(),
                  const SizedBox(height: 16.0),
                  ActionButtons(
                    isWeb: widget.isWeb,
                    onPurchasePressed: () => _showPurchaseModal(context),
                    product: widget.product,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        ProductDetailsDisclosure(
          product: widget.product,
          showProductInfo: showProductInfo,
          toggleProductInfo: () {
            setState(() {
              showProductInfo = !showProductInfo;
            });
          },
        ),
        const SizedBox(height: 50.0),
        Center(
          child: Container(
            width: screenWidth > 1200 ? 1200 : screenWidth,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            child: Image.network(
              widget.product.productDetailUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, double screenWidth) {
    final numberFormat = NumberFormat("#,###", "en_US");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1.0,
          child: Container(
            width: screenWidth, // 이미지가 항상 정사각형을 유지
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            child: Image.network(
              widget.product.productImageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          widget.product.productName,
          style: TextStyle(
            fontSize: getFontSize(context, FontSizeType.extraLarge),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            if (widget.product.wholesalePrice != null)
              Text(
                '${numberFormat.format(widget.product.wholesalePrice)}원',
                style: TextStyle(
                  fontSize: getFontSize(context, FontSizeType.medium),
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            const SizedBox(width: 8.0),
            if (widget.product.discountRate != null)
              Text(
                '${widget.product.discountRate}%',
                style: TextStyle(
                  fontSize: getFontSize(context, FontSizeType.large),
                  color: Colors.green,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8.0),
        Text(
          '${numberFormat.format(widget.product.bgoodPrice)}원',
          style: TextStyle(
            fontSize: getFontSize(context, FontSizeType.extraLarge),
            color: Colors.red,
          ),
        ),
        const SizedBox(height: 16.0),
        ShippingInfo(),
        const SizedBox(height: 16.0),
        ActionButtons(
          isWeb: widget.isWeb,
          onPurchasePressed: () => _showPurchaseModal(context),
          product: widget.product,
        ),
        const SizedBox(height: 16.0),
        ProductDetailsDisclosure(
          product: widget.product,
          showProductInfo: showProductInfo,
          toggleProductInfo: () {
            setState(() {
              showProductInfo = !showProductInfo;
            });
          },
        ),
        const SizedBox(height: 50.0),
        Center(
          child: Container(
            width: screenWidth * 0.9, // 이미지에 약간의 여백 추가
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            child: Image.network(
              widget.product.productDetailUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  void _showPurchaseModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ChangeNotifierProvider(
        create: (_) => CartNotifier(
          firestoreService: FirestoreService(),
          userId: widget.customUser?.uid ?? '',
        ),
        child: PurchaseModal(
          customUser: widget.customUser,
          product: widget.product,
          quantity: 1,
          onAddToCart: (quantity) => _addToCart(context, quantity),
          onPurchase: (quantity, request) => _purchase(context, quantity, request),
          showAllFields: !widget.isWeb,
          isWeb: widget.isWeb,
        ),
      ),
    );
  }

  void _addToCart(BuildContext context, int quantity) {
    if (widget.customUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인이 필요합니다.')),
      );
      return;
    }

    final firestoreService = FirestoreService();
    firestoreService.addToCart(widget.customUser!.uid, {
      'productId': widget.product.id,
      'productName': widget.product.productName,
      'productImageUrl': widget.product.productImageUrl,
      'bgoodPrice': widget.product.bgoodPrice,
      'wholesalePrice': widget.product.wholesalePrice ?? 0,
      'quantity': quantity,
      'discountRate': widget.product.discountRate ?? 0,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('장바구니에 추가되었습니다.')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('장바구니 추가 실패: $error')),
      );
    });
  }

  void _purchase(BuildContext context, int quantity, String request) {
    if (widget.customUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인이 필요합니다.')),
      );
      return;
    }

    final firestoreService = FirestoreService();
    firestoreService.createOrder(widget.customUser!.uid, {
      'productId': widget.product.id,
      'userId': widget.customUser!.uid,
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
      'userName': widget.customUser!.companyName,
      'userAddress': widget.customUser!.businessAddress,
      'request': request,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('구매가 완료되었습니다.')),
      );
      context.go('/product_order_list_screen');
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('구매 실패: $error')),
      );
    });
  }
}

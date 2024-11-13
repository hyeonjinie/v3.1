import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../domain/models/product.dart';
import '../../../../services/auth_provider.dart';
import 'package:v3_mvp/services/firestore_service.dart';
import 'package:go_router/go_router.dart';

class ActionButtons extends StatelessWidget {
  final bool isWeb;
  final Product product;
  final VoidCallback onPurchasePressed;

  const ActionButtons({
    Key? key,
    required this.isWeb,
    required this.onPurchasePressed,
    required this.product,
  }) : super(key: key);

  void _addToCart(BuildContext context, int quantity) async {
    final authProvider = Provider.of<AuthProviderService>(context, listen: false);
    final user = authProvider.user;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인이 필요합니다.')),
      );
      return;
    }

    final firestoreService = FirestoreService();
    await firestoreService.addToCart(user.uid, {
      'productId': product.id,
      'productName': product.productName,
      'productImageUrl': product.productImageUrl,
      'bgoodPrice': product.bgoodPrice,
      'wholesalePrice': product.wholesalePrice ?? 0,
      'quantity': quantity,
      'discountRate': product.discountRate ?? 0,
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        width: isWeb && screenWidth > 1200 ? 1200 : screenWidth,
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isWeb) ...[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _addToCart(context, 1), // 기본 수량 1로 장바구니에 추가
                      child: const Text('장바구니', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00AF66),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: ElevatedButton(
                    onPressed: onPurchasePressed,
                    child: const Text('구매하기', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00AF66),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
            if (isWeb) const SizedBox(height: 16),
            // if (isWeb)
            //   SizedBox(
            //     width: double.infinity,
            //     child: ElevatedButton(
            //       onPressed: () {
            //         // 선도거래 문의하기 기능 구현
            //       },
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: const Color(0xFF00AF66),
            //         padding: const EdgeInsets.symmetric(vertical: 16),
            //       ),
            //       child: const Text('선도거래 문의하기', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }

}

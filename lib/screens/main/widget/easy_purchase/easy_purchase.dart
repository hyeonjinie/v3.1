import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../domain/models/product.dart';
import '../../../../domain/models/product/simple_product_model.dart';
import '../../../../services/auth_provider.dart';
import '../../../../services/firestore_service.dart';
import '../../../../widgets/font_size_helper/font_size_helper.dart';
import '../../../products/detail/detail_page.dart';
import '../../../utils/carousel/easy_purchase_carousel_slider_widget.dart';
import '../../../utils/screen_width/responsive_builder.dart';

class EasyPurchaseCarousel extends StatefulWidget {
  const EasyPurchaseCarousel({Key? key}) : super(key: key);

  @override
  _EasyPurchaseCarouselState createState() => _EasyPurchaseCarouselState();
}

class _EasyPurchaseCarouselState extends State<EasyPurchaseCarousel> {
  int _current = 0; // 현재 슬라이드 인덱스를 추적하는 변수
  Future<List<SimpleProductModel>>? _futureProducts;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProviderService>(context);
    final user = authProvider.user;

    if (user != null && _futureProducts == null) {
      _futureProducts = FirestoreService().getRecentPurchases(user.uid);
    }

    return ResponsiveBuilder(
        builder: (context, carouselWidth) {
          // 화면 크기와 비율에 따라 aspectRatio를 조정합니다.
          double aspectRatio = carouselWidth > 1200
              ? 16 / 4
              : (carouselWidth > 800 ? 16 / 6 : 16 / 9);

          return Container(
            width: carouselWidth,
            color: const Color(0xFFF6F6F6),
            child: Column(
              children: [
                SizedBox(height: 50),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text('간편구매',
                        style: TextStyle(
                            fontSize: getFontSize(context, FontSizeType.extraLarge),
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(height: 8),
                user != null ? buildCarousel(user.uid, aspectRatio) : emptyView(),
                SizedBox(height: 50),
              ],
            ),
          );
        }
    );
  }

  Widget buildCarousel(String uid, double aspectRatio) {
    return FutureBuilder<List<SimpleProductModel>>(
      future: _futureProducts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading data: ${snapshot.error}'));
        }

        final products = snapshot.data!;
        products.forEach((product) => print('Product ID: ${product.productId}')); // Product ID logging
        if (products.isEmpty) {
          return emptyView();
        }

        return EasyPurchaseCarouselSliderWidget(
          interval: const Duration(seconds: 3),
          onItemTap: (index) {
            navigateToDetailPage(context, products[index].productId);
          },
          items: products.map((product) => product.toMap()).toList(),
          aspectRatio: aspectRatio,
          currentIndex: _current,
          onPageChanged: (index, reason) {
            setState(() {
              _current = index;
            });
          },
        );
      },
    );
  }

  void navigateToDetailPage(BuildContext context, String productId) async {
    try {
      final productDoc = await FirestoreService().getProduct(productId);
      print('ProductDoc: ${productDoc.data()}'); // Product data logging

      if (productDoc.exists) {
        final product = Product.fromDocument(productDoc);
        print('Product: ${product.toJson()}'); // Product object logging
        if (Theme.of(context).platform == TargetPlatform.android ||
            Theme.of(context).platform == TargetPlatform.iOS) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPage(productId: product.id),
            ),
          );
        } else {
          final productJson = jsonEncode(product.toJson());
          if (mounted) {
            context.go('/detail', extra: productJson);
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('상품 정보를 불러오는데 실패했습니다.')),
          );
        }
      }
    } catch (e) {
      print('Error navigating to detail page: $e'); // Error logging
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('상품 정보를 불러오는데 실패했습니다.')),
        );
      }
    }
  }

  Widget emptyView() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 2.0,
            spreadRadius: 1,
            offset: Offset(2, 2),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '자주 구매하는 상품은 보다 더 간편하게 구매할 수 있어요.',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Icon(Icons.add_circle_outline, size: 60, color: Colors.grey),
          SizedBox(height: 10),
          Text(
            '※ 상품을 구매하면 자동으로 등록됩니다.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

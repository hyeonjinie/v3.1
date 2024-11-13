import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:v3_mvp/screens/main/widget/market/product_carousel.dart';
import 'package:v3_mvp/widgets/font_size_helper/font_size_helper.dart';
import '../../../../services/auth_provider.dart';
import '../../../../services/provider/product_provider.dart';
import '../../../../domain/models/product.dart';

class BgoodMarket extends StatefulWidget {
  // final Function(int) onMorePressed;

  const BgoodMarket({Key? key,
    // required this.onMorePressed
  }) : super(key: key);

  @override
  _BgoodMarketState createState() => _BgoodMarketState();
}

class _BgoodMarketState extends State<BgoodMarket> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProviderService>(context);
    final user = authProvider.user;

    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        if (productProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (productProvider.products.isEmpty) {
          return const Center(child: Text('상품이 없습니다.'));
        } else {
          final products = productProvider.products;
          double screenWidth = MediaQuery.of(context).size.width;

          // 대분류 카테고리별로 상품 그룹화
          Map<String, List<Product>> groupedProducts = {};
          for (var product in products) {
            String category = product.mainCategory;
            if (!groupedProducts.containsKey(category)) {
              groupedProducts[category] = [];
            }
            groupedProducts[category]?.add(product);
          }

          // 카테고리 순서 지정
          List<String> categoryOrder = ['농산물', '수산물', '축산물', '가공식품', '반찬가게'];

          return SizedBox(
            width: screenWidth > 1200 ? 1200 : screenWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('비굿마켓',
                            style: TextStyle(
                                fontSize: getFontSize(context, FontSizeType.extraLarge), fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              if (user == null) {
                                context.go('/login_screen');
                              } else {
                                if (kIsWeb) {
                                  context.go('/product_list');
                                } else {
                                  // widget.onMorePressed(4);
                                }
                              }
                            },
                            child: const Text('더보기',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black54)),
                          ),
                          const Icon(Icons.arrow_forward_ios,
                              color: Colors.black54, size: 16),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                ...categoryOrder
                    .where((category) => groupedProducts.containsKey(category))
                    .map((category) => ProductCarousel(
                  products: groupedProducts[category]!,
                  title: category,
                ))
                    .toList(),
                const SizedBox(height: 25),
              ],
            ),
          );
        }
      },
    );
  }
}

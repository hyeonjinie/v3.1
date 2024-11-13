import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:v3_mvp/screens/products/detail/detail_page.dart';
import '../../../../domain/models/product.dart';
import '../../../../services/auth_provider.dart';

class ProductCarousel extends StatelessWidget {
  final List<Product> products;
  final String title;

  const ProductCarousel({Key? key, required this.products, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProviderService>(context);
    final user = authProvider.user;

    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = screenWidth > 1200
        ? 1200 / 3
        : screenWidth * (screenWidth > 600 ? 0.33 : 0.5);
    double itemHeight = itemWidth + 120; // Adjust for text area

    final numberFormat = NumberFormat("#,###", "en_US");

    return Column(
      children: [
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(title,
                style:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
        ),
        CarouselSlider.builder(
          itemCount: products.length,
          itemBuilder: (context, index, realIndex) {
            var product = products[index];
            bool displayDiscount = product.discountRate != null;
            bool displayWholeSalePrice = product.wholesalePrice != null;

            return InkWell(
              onTap: () {
                if (user != null) {
                  final productIdJson = jsonEncode({'id': product.id});
                  if (Theme.of(context).platform == TargetPlatform.android ||
                      Theme.of(context).platform == TargetPlatform.iOS) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(productId: product.id),
                      ),
                    );
                  } else {
                    context.go('/detail', extra: productIdJson);
                  }
                }
              },
              child: Container(
                width: itemWidth,
                height: itemHeight,
                margin:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: itemWidth,
                      height: itemWidth,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(product.productImageUrl),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(product.productName,
                            style: const TextStyle(
                                fontSize: 22, letterSpacing: -0.5),
                            overflow: TextOverflow.ellipsis)),
                    const SizedBox(height: 5),
                    user != null
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Row(
                            children: [
                              if (displayDiscount) ...[
                                Text('${product.discountRate}%',
                                    style: const TextStyle(
                                        color: Colors.green,
                                        fontSize: 16)),
                                const SizedBox(width: 5),
                              ],
                              if (displayWholeSalePrice) ...[
                                Text(
                                    '${numberFormat.format(product.wholesalePrice)}원',
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        decoration:
                                        TextDecoration.lineThrough),
                                    overflow: TextOverflow.ellipsis),
                              ],
                            ],
                          ),
                        ),
                      ],
                    )
                        : const SizedBox(height: 0),
                    user != null
                        ? Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          '${numberFormat.format(product.bgoodPrice)}원',
                          style: const TextStyle(fontSize: 22),
                          overflow: TextOverflow.ellipsis),
                    )
                        : const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('로그인 후 확인 가능',
                          style: TextStyle(fontSize: 18),
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ),
            );
          },
          options: CarouselOptions(
            autoPlay: false,
            enlargeCenterPage: false,
            aspectRatio: screenWidth > 1200 ? 2.5 : 1.8,
            viewportFraction: screenWidth > 600 ? 1 / 3 : 0.5,
            enableInfiniteScroll: false,
            padEnds: false,
            height: itemHeight,
          ),
        ),
      ],
    );
  }
}

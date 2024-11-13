import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:v3_mvp/screens/products/detail/detail_page.dart';
import '../../../../domain/models/product.dart';
import 'package:intl/intl.dart';
import 'package:v3_mvp/services/auth_provider.dart';
import '../../../widgets/font_size_helper/font_size_helper.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  void _navigateToDetail(BuildContext context) {
    const routeName = '/detail';
    final productIdJson =
        jsonEncode({'id': widget.product.id}); // product.id를 JSON 형식으로 인코딩

    if (Theme.of(context).platform == TargetPlatform.android ||
        Theme.of(context).platform == TargetPlatform.iOS) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailPage(productId: widget.product.id),
        ),
      );
    } else {
      context.go(routeName,
          extra: productIdJson); // JSON 형식으로 인코딩된 product.id 전달
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin을 적용하려면 호출 필요
    final numberFormat = NumberFormat("#,###", "en_US");
    final authProvider = Provider.of<AuthProviderService>(context);
    final user = authProvider.user;

    return GestureDetector(
      onTap: () => _navigateToDetail(context),
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1, // 정사각형 비율
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4.0)),
                child: Image.network(
                  widget.product.productImageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.productName,
                    style: TextStyle(
                      fontSize: getFontSize(context, FontSizeType.medium),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (user != null)
                    Row(
                      children: [
                        Text(
                          '${numberFormat.format(widget.product.discountRate)}%',
                          style: TextStyle(
                            fontSize: getFontSize(context, FontSizeType.small),
                            color: Colors.green,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8), // 할인율과 원래 가격 사이에 간격 추가
                        Text(
                          '${numberFormat.format(widget.product.originalPrice)}원',
                          style: TextStyle(
                            fontSize: getFontSize(context, FontSizeType.small),
                            decoration: TextDecoration.lineThrough,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  Text(
                    '${numberFormat.format(widget.product.bgoodPrice)}원',
                    style: TextStyle(
                      fontSize: getFontSize(context, FontSizeType.medium),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (user == null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '로그인 후 확인 가능',
                        style: TextStyle(
                            fontSize:
                                getFontSize(context, FontSizeType.medium)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

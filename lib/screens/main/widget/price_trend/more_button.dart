import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:v3_mvp/widgets/font_size_helper/font_size_helper.dart';
import '../../../../domain/models/item.dart';
import '../../../../services/auth_provider.dart';
import '../../../../services/market_data_service.dart';
import '../../../info_center/item_detail/sd_price_detail_screen.dart';

class MoreButton extends StatelessWidget {
  final Item selectedVariety;
  final MarketDataService marketDataService;

  const MoreButton({
    required this.selectedVariety,
    required this.marketDataService,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProviderService>(context);
    final user = authProvider.user;
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        width: screenWidth > 1200 ? 1200 : screenWidth,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ElevatedButton(
          onPressed: user != null
              ? () {
            final itemData = marketDataService.marketData.firstWhere(
                  (data) => data['name'] == selectedVariety.name,
              orElse: () => {},
            );
            if (itemData.isNotEmpty) {
              _navigateToDetailPage(context, itemData);
            } else {
              print('Item data not found for ${selectedVariety.name}');
            }
          }
              : null, // 로그인 상태가 null이면 onPressed를 비활성화
          style: ElevatedButton.styleFrom(
            fixedSize: getButtonSize(context, ButtonSizeType.medium),
            backgroundColor: Color(0xFF11C278),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            elevation: 0,
          ),
          child: Text(
              user != null ? '더보기' : '로그인 후, 이용 가능합니다.',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)
          ),
        ),
      ),
    );
  }

  void _navigateToDetailPage(BuildContext context, Map<String, dynamic> itemData) {
    const routeName = '/price_detail';

    final item = Item.fromJson(itemData);
    final itemJson = jsonEncode(item.toJson());
    final errorValue = itemData['prediction']?['error']?.values?.first;

    if (Theme.of(context).platform == TargetPlatform.android ||
        Theme.of(context).platform == TargetPlatform.iOS) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SdPriceDetailScreen(item: item, errorValue: errorValue),
        ),
      );
    } else {
      context.go(routeName, extra: {'itemJson': itemJson, 'errorValue': errorValue});
    }
  }
}

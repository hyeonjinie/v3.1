import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:v3_mvp/screens/info_center/widget/sd_favorite_items_list.dart';
import 'package:v3_mvp/widgets/font_size_helper/font_size_helper.dart';
import '../../../domain/models/item.dart';
import '../../utils/triangle_painter.dart';
import '../item_detail/sd_price_detail_screen.dart';
import 'package:v3_mvp/services/market_data_service.dart'; // Import the service

class MarketInfoList extends StatefulWidget {
  const MarketInfoList();

  @override
  _MarketInfoListState createState() => _MarketInfoListState();
}

class _MarketInfoListState extends State<MarketInfoList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MarketDataService>(
      builder: (context, marketDataService, child) {
        if (marketDataService.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return buildFavoritesList(marketDataService);
      },
    );
  }

  Widget buildFavoritesList(MarketDataService marketDataService) {
    final numberFormat = NumberFormat('#,##0');

    return LayoutBuilder(
      builder: (context, constraints) {
        if (kIsWeb && constraints.maxWidth > 800) {
          return Container(
            color: Colors.grey[200],
            child: Column(
              children: [
                FavoredItemsCarousel(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(height: 25),
                          Padding(
                            padding: const EdgeInsets.only(top: 25, right: 10, left: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.white, width: 2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: buildPredictedList(numberFormat, marketDataService),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(height: 25),
                          Padding(
                            padding: const EdgeInsets.only(top: 25, left: 10, right: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.white, width: 2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: buildMarketList(numberFormat, marketDataService),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FavoredItemsCarousel(),
              buildPredictedList(numberFormat, marketDataService),
              Container(
                width: double.infinity,
                height: 50,
                color: Colors.grey[200],
              ),
              buildMarketList(numberFormat, marketDataService),
            ],
          );
        }
      },
    );
  }

  Widget buildPredictedList(NumberFormat numberFormat, MarketDataService marketDataService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 25),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            children: [
              Text('예측품목',
                  style: TextStyle(fontSize: getFontSize(context, FontSizeType.large), fontWeight: FontWeight.bold)),
              Spacer(),
              Text('※ 1주 후 상승/하락 예측', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
        Divider(color: Colors.grey[200], thickness: 2),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: marketDataService.predictedMarketData.length,
          itemBuilder: (context, index) {
            var item = marketDataService.predictedMarketData[index];
            double price = double.tryParse(
                item['price'].replaceAll(RegExp(r'[^0-9.]'), '')) ??
                0.0;
            double change = double.tryParse(
                item['change'].replaceAll(RegExp(r'[^0-9.-]'), '')) ??
                0.0;

            String formattedPrice = numberFormat.format(price.round());
            String formattedChange = numberFormat.format(change.round());

            double? errorValue = item['prediction']['error']?.values?.first;
            bool isIncrease = errorValue != null && errorValue >= 0;

            return InkWell(
              onTap: () => _navigateToDetailPage(context, item),
              child: Column(
                children: [
                  Card(
                    color: Colors.white,
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => marketDataService.toggleFavorite(index, true), // 수정된 부분
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Icon(
                                  marketDataService.predictedFavorites[index] // 수정된 부분
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: marketDataService.predictedFavorites[index] // 수정된 부분
                                      ? Color(0xFFFF7070)
                                      : Color(0xFF7982BD),
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(item['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                                    SizedBox(width: 8),
                                    CustomPaint(
                                      painter: TrianglePainter(
                                        color: isIncrease ? Color(0xFFFF7070) : Color(0xFF7982BD),
                                        isUp: isIncrease,
                                      ),
                                      size: Size(15, 15),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '$formattedPrice원',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                '$formattedChange (${item['changePercent']})',
                                style: TextStyle(
                                    color: change >= 0
                                        ? Color(0xFFFF7070)
                                        : Color(0xFF7982BD)),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () =>
                                _navigateToDetailPage(context, item),
                            icon: Icon(Icons.chevron_right,
                                color: Color(0xFF7982BD)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(color: Colors.grey[200], thickness: 1),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget buildMarketList(NumberFormat numberFormat, MarketDataService marketDataService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 25),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Text('전체품목',
              style: TextStyle(fontSize: getFontSize(context, FontSizeType.large), fontWeight: FontWeight.bold)),
        ),
        Divider(color: Colors.grey[200], thickness: 2),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: marketDataService.marketData.length,
          itemBuilder: (context, index) {
            var item = marketDataService.marketData[index];
            double price = double.tryParse(
                item['price'].replaceAll(RegExp(r'[^0-9.]'), '')) ??
                0.0;
            double change = double.tryParse(
                item['change'].replaceAll(RegExp(r'[^0-9.-]'), '')) ??
                0.0;

            String formattedPrice = numberFormat.format(price.round());
            String formattedChange = numberFormat.format(change.round());

            return InkWell(
              onTap: () => _navigateToDetailPage(context, item),
              child: Column(
                children: [
                  Card(
                    color: Colors.white,
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => marketDataService.toggleFavorite(index, false), // 수정된 부분
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Icon(
                                  marketDataService.marketFavorites[index] // 수정된 부분
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: marketDataService.marketFavorites[index] // 수정된 부분
                                      ? Color(0xFFFF7070)
                                      : Color(0xFF7982BD),
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['name'],
                                    style:
                                    TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '$formattedPrice원',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                '$formattedChange (${item['changePercent']})',
                                style: TextStyle(
                                    color: change >= 0
                                        ? Color(0xFFFF7070)
                                        : Color(0xFF7982BD)),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () =>
                                _navigateToDetailPage(context, item),
                            icon: Icon(Icons.chevron_right,
                                color: Color(0xFF7982BD)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(color: Colors.grey[200], thickness: 1),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  void _navigateToDetailPage(BuildContext context, Map<String, dynamic> itemData) {
    const routeName = '/price_detail';

    final item = Item.fromJson(itemData);
    final itemJson = jsonEncode(item.toJson());
    final  errorValue;
    if (itemData['prediction']['error'] != null) {
      errorValue = itemData['prediction']['error'].values.first;
    } else {
      errorValue = null;
    }

    if (Theme.of(context).platform == TargetPlatform.android || Theme.of(context).platform == TargetPlatform.iOS) {
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

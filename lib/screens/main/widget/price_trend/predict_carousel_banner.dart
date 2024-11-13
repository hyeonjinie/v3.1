import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:v3_mvp/services/market_data_service.dart';
import 'package:v3_mvp/widgets/font_size_helper/font_size_helper.dart';
import '../../../utils/triangle_painter.dart';

class PredictCarousel extends StatefulWidget {
  // final Function(int) onMorePressed;

  const PredictCarousel({Key? key,
    // required this.onMorePressed
  }) : super(key: key);

  @override
  _PredictCarouselState createState() => _PredictCarouselState();
}

class _PredictCarouselState extends State<PredictCarousel> {
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    const scrollDuration = Duration(seconds: 1);
    const scrollAmount = 40.0;

    _timer = Timer.periodic(scrollDuration, (timer) {
      if (_scrollController.hasClients) {
        if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent) {
          _scrollController.jumpTo(_scrollController.position.minScrollExtent);
        }
        _scrollController.animateTo(
          _scrollController.position.pixels + scrollAmount,
          duration: scrollDuration,
          curve: Curves.linear,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final marketDataService = Provider.of<MarketDataService>(context);

    return SizedBox(
      width: screenWidth > 1200 ? 1200 : screenWidth,
      child: Column(
        children: [
          SizedBox(
            width: screenWidth > 1200 ? 1200 : screenWidth,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('가격동향',
                        style: TextStyle(
                            fontSize: getFontSize(context, FontSizeType.extraLarge),
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          SizedBox(height: 15),
          buildCarousel(context, marketDataService),
        ],
      ),
    );
  }

  Widget buildCarousel(BuildContext context, MarketDataService marketDataService) {
    double screenHeight = MediaQuery.of(context).size.height;
    double carouselHeight = (screenHeight * 0.1).clamp(50.0, 100.0);

    if (marketDataService.predictedMarketData.isEmpty) {
      return Center(child: Text('No data available'));
    }

    return Container(
      color: Color(0xFFF5F8FF),
      height: carouselHeight,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          var item = marketDataService.predictedMarketData[index % marketDataService.predictedMarketData.length];
          bool isRising = item['predictedPriceIncrease'];

          return Container(
            width: 150,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 100,
                      child: Text(item['name'],
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: getFontSize(context, FontSizeType.medium),
                              fontWeight: FontWeight.bold)),
                    ),
                    Row(
                      children: [
                        CustomPaint(
                          painter: TrianglePainter(
                            color: isRising ? Color(0xFFFF7070) : Color(0xFF7982BD),
                            isUp: isRising,
                          ),
                          size: Size(15, 15),
                        ),
                        SizedBox(width: 10),
                        Text(isRising ? "상승예상" : "하락예상",
                            style: TextStyle(
                                fontSize: getFontSize(context, FontSizeType.medium),
                                color: isRising ? Color(0xFFFF7070) : Color(0xFF7982BD))),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

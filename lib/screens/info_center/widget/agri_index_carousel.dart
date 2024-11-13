import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class StockIndexCarousel extends StatelessWidget {
  final List<Map<String, dynamic>> stockIndexes;

  const StockIndexCarousel({
    Key? key,
    required this.stockIndexes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Text(
            'BPI',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        CarouselSlider.builder(
          itemCount: stockIndexes.length,
          itemBuilder: (context, index, realIndex) {
            var stock = stockIndexes[index];
            return _buildStockCard(stock);
          },
          options: CarouselOptions(
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 5),
            enlargeCenterPage: false,
            height: 150,
            viewportFraction: getViewportFraction(context),
            initialPage: 0,
            pageSnapping: false,
          ),
        ),
      ],
    );
  }

  double getViewportFraction(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 700) {
      return 0.2;
    }
    return 0.35;
  }

  Widget _buildStockCard(Map<String, dynamic> stock) {
    double changeValue = double.tryParse(stock['change']) ?? 0; // 변동 값을 숫자로 변환
    Color textColor = changeValue < 0 ? Colors.blue : Colors.red; // 음수면 파란색, 양수면 빨간색

    return SizedBox(
      width: 150,
      height: 150,
      child: Card(
        color: Color(0xFFE4F5EE),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(stock['name'], style: TextStyle(fontSize: 18)),
              Text("${stock['currentValue']}", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              Text("${stock['change']}", style: TextStyle(fontSize: 16, color: textColor)),
              Text("${stock['changePercent']}", style: TextStyle(fontSize: 16, color: textColor))
            ],
          ),
        ),
      ),
    );
  }
}

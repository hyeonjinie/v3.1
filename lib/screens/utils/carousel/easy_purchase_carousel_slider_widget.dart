import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:v3_mvp/widgets/font_size_helper/font_size_helper.dart';

class EasyPurchaseCarouselSliderWidget extends StatelessWidget {
  final Duration interval;
  final Function(int) onItemTap;
  final List<Map<String, dynamic>> items;
  final double aspectRatio;
  final int currentIndex;
  final Function(int, CarouselPageChangedReason) onPageChanged;

  const EasyPurchaseCarouselSliderWidget({
    Key? key,
    required this.interval,
    required this.onItemTap,
    required this.items,
    required this.aspectRatio,
    required this.currentIndex,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return buildSlider(context, screenWidth);
  }

  Widget buildSlider(BuildContext context, double screenWidth) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: items.length,
          options: CarouselOptions(
            padEnds: false,
            autoPlay: false,
            enlargeCenterPage: false,
            aspectRatio: aspectRatio,
            viewportFraction: screenWidth > 800 ? 0.6 : 0.9, // 여러 카드를 보이도록 설정
            initialPage: 0,
            onPageChanged: onPageChanged,
            enableInfiniteScroll: false,
          ),
          itemBuilder: (context, index, realIndex) {
            return GestureDetector(
              onTap: () => onItemTap(index),
              child: buildCard(context, index, screenWidth),
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items.asMap().entries.map((entry) {
            return Container(
              width: 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 3.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentIndex == entry.key ? Color(0xFF11C278) : Colors.grey,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget buildCard(BuildContext context, int index, double screenWidth) {
    double cardWidth = screenWidth > 800 ? screenWidth * 0.5 : screenWidth * 0.8;
    double buttonHeight = screenWidth > 800 ? 50.0 : 35.0;
    double fontSize = screenWidth > 800 ? 18.0 : 14.0;

    return Container(
      width: cardWidth,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
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
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0)),
              child: Image.network(
                items[index]['image']!,
                fit: BoxFit.cover,
                height: double.infinity,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15.0),
                    bottomRight: Radius.circular(15.0)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10), // 상단 여백 추가 (이미지와 텍스트 사이 여백
                  Text(
                    items[index]['name']!,
                    style: TextStyle(
                      fontSize: getFontSize(context, FontSizeType.extraLarge),
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (items[index]['wholesalePrice'] != null)
                        Row(
                          children: [
                            Text(
                              items[index]['discountRate']!,
                              style: TextStyle(
                                fontSize: getFontSize(context, FontSizeType.medium),
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(width: 10),
                            Text(
                              items[index]['wholesalePrice']!,
                              style: TextStyle(
                                fontSize: getFontSize(context, FontSizeType.medium),
                                color: Colors.black,
                                decoration: TextDecoration.lineThrough,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      Text(
                        items[index]['bgoodPrice']!,
                        style: TextStyle(
                          fontSize: getFontSize(context, FontSizeType.extraLarge),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: buttonHeight,
                    child: ElevatedButton(
                      onPressed: () => onItemTap(index),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF11C278),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: Text(
                        '구매하기',
                        style: TextStyle(
                            fontSize: fontSize,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
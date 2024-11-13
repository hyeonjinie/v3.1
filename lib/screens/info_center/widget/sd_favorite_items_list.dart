import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:v3_mvp/widgets/font_size_helper/font_size_helper.dart';

import '../../../domain/models/item.dart';
import '../../../services/auth_provider.dart';
import '../item_detail/sd_price_detail_screen.dart';
import 'package:intl/intl.dart';


class FavoredItemsCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var authProvider = Provider.of<AuthProviderService>(context);
    var user = authProvider.user;

    if (user == null) {
      return const Center(child: Text("로그인이 필요합니다."));
    }

    return Container(
      color: Color(0xFFF5F8FF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Text(
              '관심 품목',
              style: TextStyle(fontSize: getFontSize(context, FontSizeType.large), fontWeight: FontWeight.bold),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('client')
                .doc(user.uid)
                .collection('favorites')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              }
              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                var items = snapshot.data!.docs.map((doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  return buildCarouselItem(context, data, user.uid, doc.id);
                }).toList();

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CarouselSlider(
                    items: items,
                    options: CarouselOptions(
                      padEnds: false,
                      disableCenter: true,
                      autoPlay: false,
                      enableInfiniteScroll: false,
                      enlargeCenterPage: false,
                      height: 150,
                      viewportFraction: getViewportFraction(context),
                      initialPage: 0,
                      pageSnapping: false,
                      autoPlayCurve: Curves.linear,
                      autoPlayAnimationDuration: Duration(milliseconds: 500),
                    ),
                  ),
                );
              }
              return Center(
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        color: Colors.red,
                        size: 48.0,
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        "관심 품목이 없습니다.",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        "관심 있는 품목을 추가해 주세요.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black38,
                        ),
                      ),
                      SizedBox(height: 16.0),
                    ],
                  ),
                ),
              );

            },
          ),
        ],
      ),
    );
  }

  double getViewportFraction(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (!kIsWeb) {
      return 0.35;
    }
    if (screenWidth > 900) {
      return 0.15;
    }
    if (screenWidth > 660) {
      return 0.20;
    }
    return 0.3;
  }

  Widget buildCarouselItem(BuildContext context, Map<String, dynamic> item, String userId, String docId) {
    // NumberFormat 객체 생성
    final NumberFormat numberFormat = NumberFormat('#,##0');

    // 변동 값을 숫자로 변환 후 반올림 및 형식화
    double changeValue = double.tryParse(item['change'].toString().replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
    String formattedChange = numberFormat.format(changeValue.round()) + '원';
    Color textColor = changeValue < 0 ? Colors.blue : Colors.red; // 음수면 파란색, 양수면 빨간색

    // 가격을 숫자로 변환 후 반올림 및 형식화
    double priceValue = double.tryParse(item['price'].toString().replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
    String formattedPrice = numberFormat.format(priceValue.round()) + '원';

    // 변동 퍼센트를 숫자로 변환 후 형식화
    double changePercentValue = double.tryParse(item['changePercent'].toString().replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
    String formattedChangePercent = changePercentValue.toStringAsFixed(2) + '%';

    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: () => _navigateToDetailPage(context, item),
        child: Container(
          width: 150,
          height: 150,
          color: Color(0xFFF5F8FF), // Container 배경색 설정
          child: Card(
            color: Colors.white, // 카드의 배경색을 흰색으로 설정
            shape: RoundedRectangleBorder(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item['name'],
                      style: TextStyle(
                        fontSize: getFontSize(context, FontSizeType.medium),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      formattedPrice,
                      style: TextStyle(
                        fontSize: getFontSize(context, FontSizeType.medium),
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          formattedChange,
                          style: TextStyle(
                            fontSize: getFontSize(context, FontSizeType.small),
                            color: textColor,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          formattedChangePercent,
                          style: TextStyle(
                            fontSize: getFontSize(context, FontSizeType.small),
                            color: textColor,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // 그래프는 이후에 추가 가능
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  void _removeFromFavorites(String userId, String docId) async {
    await FirebaseFirestore.instance
        .collection('client')
        .doc(userId)
        .collection('favorites')
        .doc(docId)
        .delete();
  }

  // void _navigateToDetailPage(
  //     BuildContext context, Map<String, dynamic> itemData) {
  //   const routeName = '/price_detail';
  //
  //   final item = Item.fromJson(itemData);
  //   final itemJson = jsonEncode(item.toJson()); // Item 객체를 JSON 문자열로 변환
  //
  //   if (Theme.of(context).platform == TargetPlatform.android ||
  //       Theme.of(context).platform == TargetPlatform.iOS) {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => SdPriceDetailScreen(item: item),
  //       ),
  //     );
  //   } else {
  //     context.go(routeName, extra: itemJson); // URL에 JSON 문자열을 포함
  //   }
  // }


  void _navigateToDetailPage(BuildContext context, Map<String, dynamic> itemData) {
    const routeName = '/price_detail';

    final item = Item.fromJson(itemData);
    final itemJson = jsonEncode(item.toJson());  // Item 객체를 JSON 문자열로 변환

    if (Theme.of(context).platform == TargetPlatform.android || Theme.of(context).platform == TargetPlatform.iOS) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SdPriceDetailScreen(item: item),
        ),
      );
    } else {
      context.go(routeName, extra: {'itemJson': itemJson});  // URL에 JSON 문자열을 포함
    }
  }
}

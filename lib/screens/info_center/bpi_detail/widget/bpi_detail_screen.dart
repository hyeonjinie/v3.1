import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../domain/models/bpi/bpi_data.dart';
import '../../../../domain/models/bpi/bpi_index.dart';
import 'package:intl/intl.dart';

import '../../../../domain/models/item.dart';
import '../../../../widgets/custom_appbar/custom_appbar.dart';
import '../../../../widgets/font_size_helper/font_size_helper.dart';
import '../../../../widgets/navigation_helper.dart';
import '../../../../services/api_service.dart';
import '../../item_detail/sd_price_detail_screen.dart';

class BpiDetailScreen extends StatefulWidget {
  final BpiIndex bpiIndex;
  final String title;

  const BpiDetailScreen({required this.bpiIndex, required this.title});

  @override
  State<BpiDetailScreen> createState() => _BpiDetailScreenState();
}

class _BpiDetailScreenState extends State<BpiDetailScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 1;
  int currentDuration = 365; // 기본 설정을 365일로 변경
  List<BpiData>? filteredData;
  List<Map<String, dynamic>>? apiData;
  List<bool> favorites = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final apiService = ApiService();
    final response = await apiService.getBpiItemPrice();

    // "상" 등급 데이터만 필터링
    final List<Map<String, dynamic>> upperGradeData = [];
    for (var data in response) {
      if (data.containsKey('상')) {
        upperGradeData.addAll(List<Map<String, dynamic>>.from(data['상']));
      }
    }

    var transApiData = List<Map<String, dynamic>>.from(upperGradeData.map((item) {
      return {
        "name": item['pum_nm'] ?? 'Unknown',
        "price": item['today_p'] != null ? "${item['today_p'].toString()}원" : 'N/A',
        "change": item['fluc'] != null ? "${item['fluc'].toString()}원" : 'N/A',
        "changePercent": item['fluc_r'] != null ? "${item['fluc_r'].toString()}%" : 'N/A',
        "isPredict": item.containsKey('isPredict') ? item['isPredict'] : 0.0,
        "item": item['item_nm'] ?? 'Unknown',
      };
    }).toList());

    apiData = transApiData;
    filteredData = _filterDataByDuration(widget.bpiIndex.data, currentDuration);

    setState(() {
      favorites = List.filled(apiData?.length ?? 0, false);
      isLoading = false;
    });
  }

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

  void _updateIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<BpiData> _filterDataByDuration(List<BpiData> data, int days) {
    DateTime endDate = DateTime.now();
    DateTime startDate = endDate.subtract(Duration(days: days));
    return data.where((entry) => entry.date.isAfter(startDate)).toList();
  }

  void onDurationSelected(int days) {
    setState(() {
      currentDuration = days;
      filteredData =
          _filterDataByDuration(widget.bpiIndex.data, currentDuration);
    });
  }

  Widget _buildDurationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [7, 30, 90, 180, 365].map((days) {
        String dayLabel;
        switch (days) {
          case 7:
            dayLabel = '일주일';
            break;
          case 30:
            dayLabel = '1개월';
            break;
          case 90:
            dayLabel = '3개월';
            break;
          case 180:
            dayLabel = '6개월';
            break;
          case 365:
            dayLabel = '1년';
            break;
          default:
            dayLabel = '$days 일';
        }
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: TextButton(
              onPressed: () => onDurationSelected(days),
              style: TextButton.styleFrom(
                backgroundColor: currentDuration == days
                    ? const Color(0xFF56CF9D)
                    : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(
                    color: currentDuration == days
                        ? Colors.transparent
                        : Colors.grey,
                  ),
                ),
                padding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              ),
              child: Text(
                dayLabel,
                style: TextStyle(
                  color: currentDuration == days ? Colors.white : Colors.black,
                  fontWeight: currentDuration == days
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  List<Map<String, dynamic>> _getDataForTitle(String title) {
    final mappingDict = {
      "농산물": [
        "가지",
        "딸기 설향",
        "쥬키니호박",
        "청상추",
        "느타리버섯",
        "당근",
        "시금치",
        "양송이",
        "백다다기오이",
        "사과 부사",
        "대파(일반)",
        "참외(일반)",
        "풋고추(일반)",
        "배추",
        "배 신고",
        "찰옥수수",
        "양파",
        "감귤 하우스",
        "홍고추",
        "감자 수미",
        "새송이버섯",
        "무",
        "포도 샤인머스캣",
        "고구마",
        "토마토",
        "대추방울토마토",
        "양배추",
        "노랑 파프리카",
        "그린키위 국산",
        "수박(일반)",
        "브로콜리 국산",
        "꽈리고추",
        "배추얼갈이",
        "양상추(일반)",
        "열무"
      ],
      "식량작물": ["감자 수미", "고구마", "찰옥수수"],
      "서류": ['감자 수미', '고구마'],
      "채소류": [
        "가지",
        "딸기 설향",
        "쥬키니호박",
        "청상추",
        "당근",
        "시금치",
        "백다다기오이",
        "대파(일반)",
        "참외(일반)",
        "풋고추(일반)",
        "배추",
        "양파",
        "홍고추",
        "무",
        "토마토",
        "대추방울토마토",
        "양배추",
        "노랑 파프리카",
        "수박(일반)",
        "브로콜리 국산",
        "꽈리고추",
        "배추얼갈이",
        "양상추(일반)",
        "열무"
      ],
      "엽채류": ['배추', '양배추', '시금치', '배추얼갈이', '청상추', '양상추(일반)'],
      "과채류": [
        '수박(일반)',
        '백다다기오이',
        '쥬키니호박',
        '가지',
        '딸기 설향',
        '노랑 파프리카',
        '토마토',
        '대추방울토마토',
        '풋고추(일반)',
        '홍고추',
        '참외(일반)',
        '꽈리고추'
      ],
      "근채류": ['무', '당근', '열무'],
      "조미채소류": ['홍고추', '대파(일반)', '양파'],
      "과실류": ["사과 부사", "배 신고", "포도 샤인머스캣", "감귤 하우스", "그린키위 국산"],
      "인과류": ['배 신고', '사과 부사'],
      "장과류": ['포도 샤인머스캣', '그린키위 국산'],
      "버섯류": ['새송이버섯', '양송이', '느타리버섯']
    };

    List<String> items = mappingDict[widget.title] ?? [];
    print(apiData?.where((item) => items.contains(item['name'])).toList() ?? []);

    return apiData?.where((item) => items.contains(item['name'])).toList() ?? [];
  }

  Widget _buildRecipeCard(String menu, List<String> recipe) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                menu,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              for (var item in recipe)
                Text(
                  item,
                  style: TextStyle(fontSize: 16),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (kIsWeb) {
          if (constraints.maxWidth > 660) {
            return Scaffold(
              key: _scaffoldKey,
              appBar: CustomAppBar(
                scaffoldKey: _scaffoldKey,
                selectedIndex: _selectedIndex,
                onItemTapped: (index) =>
                    NavigationHelper.onItemTapped(context, index, _updateIndex),
              ),
              body: _buildBody(),
            );
          } else {
            return Scaffold(
              key: _scaffoldKey,
              appBar: CustomAppBar(
                scaffoldKey: _scaffoldKey,
                selectedIndex: _selectedIndex,
                onItemTapped: (index) =>
                    NavigationHelper.onItemTapped(context, index, _updateIndex),
              ),
              body: _buildBody(),
              bottomNavigationBar: _buildBottomNavigationBar(),
            );
          }
        } else {
          return Scaffold(
            key: _scaffoldKey,
            appBar: CustomAppBar(
              scaffoldKey: _scaffoldKey,
              selectedIndex: _selectedIndex,
              onItemTapped: (index) =>
                  NavigationHelper.onItemTapped(context, index, _updateIndex),
            ),
            body: _buildBody(),
            bottomNavigationBar: _buildBottomNavigationBar(),
          );
        }
      },
    );
  }

  Widget _buildBody() {
    final Map<String, List<String>> _MenuRecipes = {
      "김치": [
        "배추 20포기(60kg)",
        "무 10개",
        "고춧가루 2Kg",
        "깐마늘 1.2kg",
        "대파 2Kg",
        "쪽파 2.4kg",
        "흙생강 120g",
        "미나리 2Kg",
        "굴 2Kg",
        "멸치액젓 1.2Kg",
        "새우젓 1Kg",
        "굵은 소금 8kg"
      ],
      "감자볶음": [
        "감자 6개",
        "당근 1개",
        "양파 2개",
        "소금 10g",
      ],
      "과일샐러드": [
        "사과 1개",
        "배 1/2개",
        "감 1개",
        "딸기 3개",
        "귤 2개",
        "소금 50g"
      ],
      "오이소박이": [
        "오이 4개",
        "양파 1개",
        "당근 1/3개",
        "부추 100g",
        "마늘 50g",
        "고춧가루 100g"
      ],
      "비빔밥": [
        "양파 2개",
        "느타리버섯 300g",
        "애호박 2개",
        "당근 300g",
        "청상추 100g"
      ],
      "짜장면": [
        "양파 2개",
        "양배추 반개",
        "오이 1개",
        "대파 200g",
        "주키니호박 1개"
      ],
      "김치찌개": [
        "대파 100g",
        "새우젓 40g",
        "김치 1포기",
        "고춧가루 50g",
        "마늘 5개",
        "청양고추 1개"
      ],
    };
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth > 1200 ? 1200 : screenWidth;

    double firstValue = filteredData!.first.value;
    double secondValue =
    filteredData!.length > 1 ? filteredData![1].value : firstValue;
    double difference = firstValue - secondValue;
    double percentage = ((difference / firstValue) * 100).abs();

    Color valueColor = difference > 0 ? Color(0xFFFF7070) : Color(0xFF7982BD);

    List<Map<String, dynamic>> dataForTitle = _getDataForTitle(widget.title);

    return SingleChildScrollView(
      child: Center(
        child: Container(
          width: containerWidth,
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '$firstValue',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    '${difference.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      color: valueColor,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '${percentage.toStringAsFixed(2)}%',
                    style: TextStyle(
                      fontSize: 18,
                      color: valueColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 400,
                child: SfCartesianChart(
                  primaryXAxis: DateTimeAxis(
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    dateFormat: DateFormat.Md(),
                    intervalType: DateTimeIntervalType.days,
                    majorGridLines: const MajorGridLines(width: 0),
                    labelStyle:
                    const TextStyle(color: Colors.black, fontSize: 15),
                    axisLine: const AxisLine(width: 0),
                  ),
                  primaryYAxis: NumericAxis(
                    axisLine: const AxisLine(width: 0),
                    majorTickLines: const MajorTickLines(size: 0),
                  ),
                  plotAreaBorderWidth: 0,
                  series: <CartesianSeries>[
                    LineSeries<BpiData, DateTime>(
                      dataSource: filteredData!,
                      xValueMapper: (BpiData data, _) => data.date,
                      yValueMapper: (BpiData data, _) => data.value,
                      color: Color(0xFF64BD6D),
                      width: 2,
                      animationDuration: 0,
                    ),
                  ],
                ),
              ),
              _buildDurationButtons(),
              SizedBox(height: 50),
              if (dataForTitle.isNotEmpty) ...[
                Container(
                  color: Colors.grey[200],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          '구성품목',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, bottom: 20.0, top: 10),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: dataForTitle.length,
                          itemBuilder: (context, index) {
                            var data = dataForTitle[index];
                            final numberFormat = NumberFormat('#,##0');
                            double todayPrice = double.tryParse(
                                data['price']
                                    ?.replaceAll(RegExp(r'[^0-9.]'), '') ??
                                    '0.0') ??
                                0.0;
                            String price = numberFormat.format(todayPrice.round());

                            double fluc = double.tryParse(
                                data['change']
                                    ?.replaceAll(RegExp(r'[^0-9.]'), '') ??
                                    '0.0') ??
                                0.0;
                            String fluctuation =
                            numberFormat.format(fluc.round());

                            double flucRate = double.tryParse(
                                data['changePercent']
                                    ?.replaceAll(RegExp(r'[^0-9.]'), '') ??
                                    '0.0') ??
                                0.0;
                            String fluctuationRate =
                            numberFormat.format(flucRate.round());

                            return InkWell(
                              onTap: () =>
                                  _navigateToDetailPage(context, data),
                              child: Container(
                                color: Colors.grey[200],
                                child: Container(
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      Card(
                                        color: Colors.white,
                                        elevation: 0,
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Row(
                                            children: [
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(data['name'],
                                                        style: TextStyle(
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontSize:
                                                            getFontSize(
                                                                context,
                                                                FontSizeType
                                                                    .medium))),
                                                    SizedBox(height: 4),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "가격: $price원 ｜ ",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                            "변동: $fluctuation원 (${fluctuationRate}%)",
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: fluc >= 0
                                                                    ? Color(
                                                                    0xFF7982BD)
                                                                    : Color(
                                                                    0xFFFF7070))),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {}, // 여기에 상세 페이지 이동 함수 추가 가능
                                                icon: Icon(Icons.chevron_right,
                                                    color: Color(0xFF7982BD)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Divider(
                                          color: Colors.grey[200], thickness: 1),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              // if (_MenuRecipes.containsKey(widget.title)) ...[
              //   SizedBox(height: 20),
              //   _buildRecipeCard(widget.title, _MenuRecipes[widget.title]!),
              // ],
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: _icon(0, 'assets/bg_svg/icon-home.svg'),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: _icon(1, 'assets/bg_svg/information_center.svg'),
          label: '정보센터',
        ),
        BottomNavigationBarItem(
          icon: _icon(2, 'assets/bg_svg/question.svg'),
          label: '문의관리',
        ),
        BottomNavigationBarItem(
          icon: _icon(3, 'assets/bg_svg/icon-order_manage.svg'),
          label: '주문관리',
        ),
        BottomNavigationBarItem(
          icon: _icon(4, 'assets/bg_svg/mdi_cart.svg'),
          label: '비굿마켓',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      onTap: (index) =>
          NavigationHelper.onItemTapped(context, index, _updateIndex),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    );
  }

  Widget _icon(int index, String assetName) {
    return SvgPicture.asset(
      assetName,
      width: 24,
      color: _selectedIndex == index ? Colors.green : Colors.grey,
    );
  }
}

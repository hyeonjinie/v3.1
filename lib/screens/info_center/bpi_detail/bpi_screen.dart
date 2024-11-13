import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:go_router/go_router.dart';
import 'package:v3_mvp/screens/info_center/bpi_detail/widget/bpi_detail_screen.dart';
import 'package:v3_mvp/services/api_service.dart';
import 'package:v3_mvp/widgets/font_size_helper/font_size_helper.dart';

import '../../../domain/models/bpi/bpi_data.dart';
import '../../../domain/models/bpi/bpi_index.dart';

class BpiScreen extends StatefulWidget {
  @override
  _BpiScreenState createState() => _BpiScreenState();
}

class _BpiScreenState extends State<BpiScreen> {
  bool isBundleSelected = true;
  bool isLoading = true;
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? _bpiData;
  final Map<String, String> _AllindexTitles = {
    "agri_index": "농산물",
    "foodcrops_index": "식량작물",
    "potato_index": "서류",
    "vegetable_index": "채소류",
    "greenvegetable_index": "엽채류",
    "fruitvegetable_index": "과채류",
    "rootvegetable_index": "근채류",
    "jomivegetable_index": "조미채소류",
    "fruit_index": "과실류",
    "kernelfruit_index": "인과류",
    "berries_index": "장과류",
    "mushroom_index": "버섯류"
  };

  final Map<String, String> _MenuindexTitles = {
    "kimchi": "김치",
    "potato": "감자볶음",
    "fruit": "과일샐러드",
    "oek": "오이소박이",
    "bibim": "비빔밥",
    "jjajang": "짜장면",
    "kimchijg": "김치찌개",
  };

  final Map<String, String> _MenuRecipes = {
    "kimchi": "배추김치: 배추 20포기(60kg), 무 10개, 고춧가루 2Kg, 깐마늘 1.2kg, 대파 2Kg, 쪽파 2.4kg, 흙생강 120g, 미나리 2Kg, 굴 2Kg, 멸치액젓 1.2Kg, 새우젓 1Kg, 굵은 소금 8kg",
    "potato": "감자볶음: 감자6개, 당근1개, 양파2개, 소금 10g",
    "fruit": "과일샐러드: 사과 1개, 배 1/2개, 감 1개, 딸기 3개, 귤 2개, 소금 50g",
    "oek": "오이소박이: 오이4개, 양파1개, 당근 1/3개, 부추 100g, 마늘 50g, 고춧가루 100g",
    "bibim": "야채비빔밥: 양파2개, 느타리버섯 300g, 애호박 2개, 당근 300g, 청상추 100g",
    "jjajang": "짜장면: 양파2개, 양배추 반개, 오이 1개, 대파 200g, 주키니호박 1개",
    "kimchijg": "김치찌개: 대파 100g, 새우젓 40g, 김치 1포기, 고춧가루 50g, 마늘 5개, 청양고추 1개"
  };

  @override
  void initState() {
    super.initState();
    _fetchBpiData();
  }

  void _toggleSelection() {
    setState(() {
      isBundleSelected = !isBundleSelected;
      if (isBundleSelected) {
        _fetchBpiData();
      } else {
        _fetchMenuData();
      }
    });
  }

  Future<void> _fetchBpiData() async {
    setState(() {
      isLoading = true;
    });

    final data = await _apiService.getBpi();
    setState(() {
      _bpiData = data;
      isLoading = false;
    });
  }

  Future<void> _fetchMenuData() async {
    setState(() {
      isLoading = true;
    });

    final data = await _apiService.getMenu();
    setState(() {
      _bpiData = data;
      isLoading = false;
    });
  }

  List<BpiData> _createChartData(Map<String, dynamic> data) {
    List<BpiData> chartData = data.entries.map((entry) {
      DateTime date = DateTime.parse(entry.key);
      double value = entry.value.toDouble();
      return BpiData(date, value);
    }).toList();

    while (chartData.isNotEmpty && chartData.first.value == 0) {
      chartData.removeAt(0);
    }
    while (chartData.isNotEmpty && chartData.last.value == 0) {
      chartData.removeLast();
    }

    return chartData;
  }

  double _getMaxYValue(List<BpiData> data) {
    return data.map((e) => e.value).reduce((a, b) => a > b ? a : b) + 30;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerSize = screenWidth > 1200 ? (1200 / 2) - 30 : (screenWidth / 2) - 30;

    return SingleChildScrollView(
      child: Container(
        width: screenWidth > 1200 ? 1200 : screenWidth,
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              color: Color(0xFFF6F6F6),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(height: 8.0),
                    Text(
                      'BPI(B・good Price Index): 농산물을 구입할 때 지불하는 가격의 평균변동을 측정한 수치입니다. (기준: 2020년 평균가격)\n\n'
                          '메뉴지수: 음식에 사용되는 농산물의 가격의 평균변동을 측정한 수치로 소매가격을 기준으로 구성되어 있습니다.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: getFontSize(context, FontSizeType.small), color: Colors.black),
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildButton('묶음지수', isBundleSelected, _toggleSelection),
                        SizedBox(width: 8.0),
                        _buildButton('메뉴지수', !isBundleSelected, _toggleSelection),
                        SizedBox(width: 8.0),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            isLoading
                ? SizedBox(
                height: 300,
                child: Center(child: CircularProgressIndicator()))
                : (isBundleSelected && _bpiData != null)
                ? _buildChartGrid(containerSize)
                : (!isBundleSelected && _bpiData != null)
                ? _buildMenuChartGrid(containerSize)
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _buildChartGrid(double containerSize) {
    List<Widget> rows = [];
    List<Widget> currentRow = [];

    _AllindexTitles.forEach((index, title) {
      if (_bpiData![index] != null) {
        List<BpiData> chartData = _createChartData(_bpiData![index]);
        currentRow.add(_buildAllIndexContainer(containerSize, chartData, title, index));

        if (currentRow.length == 2) {
          rows.add(Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: currentRow,
          ));
          currentRow = [];
        }
      }
    });

    if (currentRow.isNotEmpty) {
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: currentRow,
      ));
    }

    return Column(
      children: rows,
    );
  }

  Widget _buildMenuChartGrid(double containerSize) {
    List<Widget> rows = [];
    List<Widget> currentRow = [];

    _MenuindexTitles.forEach((index, title) {
      if (_bpiData![index] != null) {
        List<BpiData> chartData = _createChartData(_bpiData![index]);
        currentRow.add(_buildMenuIndexContainer(containerSize, chartData, title, index));

        if (currentRow.length == 2) {
          rows.add(Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: currentRow,
          ));
          currentRow = [];
        }
      }
    });

    if (currentRow.isNotEmpty) {
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: currentRow,
      ));
    }

    return Column(
      children: rows,
    );
  }

  Widget _buildAllIndexContainer(double containerSize, List<BpiData> chartData, String title, String index) {
    return GestureDetector(
      onTap: () {
        final bpiIndex = BpiIndex.fromJson({
          'indexName': _AllindexTitles[index]!,
          'data': _bpiData![index] as Map<String, dynamic>
        });
        final bpiJson = jsonEncode(bpiIndex.toJson());

        if (Theme.of(context).platform == TargetPlatform.iOS || Theme.of(context).platform == TargetPlatform.android) {
          // Mobile navigation using Navigator
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BpiDetailScreen(bpiIndex: bpiIndex, title: _AllindexTitles[index]!),
            ),
          );
        } else {
          // Web navigation using GoRouter
          context.go('/bpi_detail', extra: bpiJson);
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = MediaQuery.of(context).size.width;
          double fontSize = constraints.maxWidth / 12;
          if (660 > screenWidth) fontSize = 14;
          if (screenWidth > 660) fontSize = 20;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: containerSize,
              height: containerSize + 30,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: Color(0xFF11C278),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          ..._buildValues(chartData, fontSize),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      top: containerSize / 2,
                      child: SfCartesianChart(
                        primaryXAxis: DateTimeAxis(
                          isVisible: false,
                        ),
                        primaryYAxis: NumericAxis(
                          isVisible: false,
                          maximum: _getMaxYValue(chartData),
                        ),
                        plotAreaBorderWidth: 0,
                        margin: EdgeInsets.zero,
                        borderWidth: 0,
                        series: <CartesianSeries>[
                          SplineAreaSeries<BpiData, DateTime>(
                            dataSource: chartData,
                            xValueMapper: (BpiData data, _) => data.date,
                            yValueMapper: (BpiData data, _) => data.value,
                            color: Color(0xFF64BD6D).withOpacity(0.5),
                            borderColor: Color(0xFF64BD6D),
                            borderWidth: 0,
                            animationDuration: 0,
                          )
                        ],
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  Widget _buildMenuIndexContainer(double containerSize, List<BpiData> chartData, String title, String index) {
    return GestureDetector(
      onTap: () {
        final bpiIndex = BpiIndex.fromJson({
          'indexName': _MenuindexTitles[index]!,
          'data': _bpiData![index] as Map<String, dynamic>
        });
        final bpiJson = jsonEncode(bpiIndex.toJson());

        if (Theme.of(context).platform == TargetPlatform.iOS || Theme.of(context).platform == TargetPlatform.android) {
          // Mobile navigation using Navigator
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BpiDetailScreen(bpiIndex: bpiIndex, title: _MenuindexTitles[index]!),
            ),
          );
        } else {
          // Web navigation using GoRouter
          context.go('/bpi_detail', extra: bpiJson);
        }
      },

      child: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: containerSize,
              height: containerSize + 30,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: Color(0xFF11C278),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: getFontSize(context, FontSizeType.medium),
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          ..._buildValues(chartData, getFontSize(context, FontSizeType.medium)),
                          Text(
                            _MenuRecipes[index] ?? '',
                            style: TextStyle(
                              fontSize: getFontSize(context, FontSizeType.small),
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      top: containerSize / 2,
                      child: SfCartesianChart(
                        primaryXAxis: DateTimeAxis(
                          isVisible: false,
                        ),
                        primaryYAxis: NumericAxis(
                          isVisible: false,
                          maximum: _getMaxYValue(chartData),
                        ),
                        plotAreaBorderWidth: 0,
                        margin: EdgeInsets.zero,
                        borderWidth: 0,
                        series: <CartesianSeries>[
                          SplineAreaSeries<BpiData, DateTime>(
                            dataSource: chartData,
                            xValueMapper: (BpiData data, _) => data.date,
                            yValueMapper: (BpiData data, _) => data.value,
                            color: Color(0xFF64BD6D).withOpacity(0.5),
                            borderColor: Color(0xFF64BD6D),
                            borderWidth: 0,
                            animationDuration: 0,
                          )
                        ],
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildValues(List<BpiData> chartData, double fontSize) {
    double firstValue = chartData.first.value;
    double secondValue = chartData.length > 1 ? chartData[1].value : firstValue;
    double difference = firstValue - secondValue;
    double percentage = ((difference / firstValue) * 100).abs();

    Color valueColor = difference > 0 ? Color(0xFFFF7070) : Color(0xFF7982BD);

    return [
      SizedBox(height: 2),
      Text(
        '$firstValue',
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      SizedBox(height: 2),
      Row(
        children: [
          Text(
            '${difference.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: getFontSize(context, FontSizeType.small),
              color: valueColor,
            ),
          ),
          SizedBox(width: 8),
          Text(
            '(${percentage.toStringAsFixed(2)}%)',
            style: TextStyle(
              fontSize: getFontSize(context, FontSizeType.small),
              color: valueColor,
            ),
          ),
        ],
      ),
    ];
  }

  Widget _buildButton(String text, bool isSelected, VoidCallback onPressed) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFF11C278) : Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: isSelected ? Color(0xFF11C278) : Color(0xFFE6E6E6),
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 16.0,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }



  void _showBpiInfoDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('BPI(B・good Price Index)'),
          content: Text(
            'BPI(B・good Price Index)는 농산물을 구입할 때 지불하는 가격의 평균변동을 측정한 수치입니다. (기준: 2020년 평균가격)\n\n'
                '35개 품목의 가격 움직임을 전체적으로 종합하여 나타냅니다.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }
}

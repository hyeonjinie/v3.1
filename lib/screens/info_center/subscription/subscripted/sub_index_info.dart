import 'package:flutter/material.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted/models/index_model.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted/service/prod_info_service.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted/widget/index_curr_chart.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted/widget/index_pred.chart.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted/widget/pred_curr_chart.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted/widget/price_table.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted/widget/year_btn.dart';
import 'package:v3_mvp/screens/utils/positive_negative_formatter.dart';

class SubIndexInfo extends StatefulWidget {
  final String selectedProdName;
  final String selectedProdCategory;
  final String selectedProdType;
  final String selectedDetail;
  final int selectedProdDay;

  const SubIndexInfo({
    Key? key,
    required this.selectedProdName,
    required this.selectedProdCategory,
    required this.selectedProdType,
    required this.selectedDetail,
    required this.selectedProdDay,
  }) : super(key: key);


  @override
  State<SubIndexInfo> createState() => _SubIndexInfoState();
}

class _SubIndexInfoState extends State<SubIndexInfo> {
  //공통
  final IndexService _indexService = IndexService();
  late ProdData? indexInfo;
  late String selectedProduct;
  late String selectedProdCategory;
  late String selectedProdType;
  late String selectedDetail;
  late int selectedProductDay;
  bool isLoading = true;

  // 분석
  IndexActAnalysis? actAnalysis;
  List<String> availableYears = [];
  List<String> selectedYears = [];
  List<String> selectedMa = [];
  Map<String, dynamic> currentProductionData = {}; //선택한 년도에 대한 분석데이터
  Map<String, dynamic> commProductionData = {}; //선택한 년도에 대한 평년데이터
  Map<String, Color> yearColorMap = {}; //생성된 년도에 따른 컬러 매핑
  Map<String, Color> maColorMap = {
    'MA30': Color(0xFFD58585),
    'MA60': Color(0xFF469E79)
  };

  // 예측
  PredAnalysis? predAnalysis;
  List<String> availablePredYears = [];
  List<String> selectedPredYears = [];
  Map<String, dynamic> predProductionData = {};

  @override
  void initState() {
    super.initState();
    selectedProduct = widget.selectedProdName;
    selectedProdCategory = widget.selectedProdCategory;
    selectedProdType = widget.selectedProdType;
    selectedDetail = widget.selectedDetail;
    selectedProductDay = widget.selectedProdDay;
    fetchAndPrintPriceInfo();
  }

  void fetchAndPrintPriceInfo() async {
    try {
      indexInfo = await _indexService.getIndexData(
          selectedProdType,
          selectedProdCategory,
          selectedDetail,
          selectedProduct,
          selectedProductDay);
    } catch (e) {
      print('Error fetching index data: $e');
    } finally {
      setState(() {
        availableYears = indexInfo!.actual.years.keys.toList();
        actAnalysis = indexInfo!.actual.actAnalysis!;
        availablePredYears = indexInfo!.predict.years.keys.toList();
        predAnalysis = indexInfo!.predict.predAnalysis!;
        _updateYearColorMap();
        _updateChartData();
        isLoading = false;
      });
    }
  }

  // chart data 추출
  void _updateChartData() {
    // 선택된 작물 및 옵션의 실제가격 데이터 가져오기
    currentProductionData.clear();
    commProductionData.clear();
    predProductionData.clear();
    final sortedYears = [...selectedYears]..sort();
    final sortedPredYears = [...selectedPredYears]..sort();
    predProductionData = {
      "act_index": <double?>[],
      "pred_index": <double?>[],
      "date": <String?>[],
    };

    for (var year in sortedYears) {
      var yearData;
      // '평년' 처리
      if (selectedYears.contains('평년')) {
        yearData = indexInfo?.actual.commYears['평년']?.commyears[year];
        if (yearData != null) {
          if (!commProductionData.containsKey('index')) {
            commProductionData.putIfAbsent('index', () => []);
          }
          commProductionData["index"]!.addAll(yearData?.index);
          if (selectedMa.isNotEmpty) {
            for (var ma in selectedMa) {
              if (!commProductionData.containsKey(ma)) {
                commProductionData.putIfAbsent(ma, () => []);
              }
              commProductionData[ma]!
                  .addAll(ma == 'MA30' ? yearData?.ma30 : yearData?.ma60);
            }
          }
          if (!commProductionData.containsKey('date')) {
            commProductionData.putIfAbsent('date', () => []);
          }
          final updatedDates = (yearData?.date as List<dynamic>?)
              ?.map((date) => '$year-$date')
              .cast<String>()
              .toList();
          commProductionData["date"]!.addAll(updatedDates ?? []);
        }
      }
      yearData = indexInfo?.actual.years[year];
      if (yearData != null) {
        if (!currentProductionData.containsKey('index')) {
          currentProductionData.putIfAbsent('index', () => []);
        }
        currentProductionData["index"]!.addAll(yearData?.index);
        if (selectedMa.isNotEmpty) {
          for (var ma in selectedMa) {
            if (!currentProductionData.containsKey(ma)) {
              currentProductionData.putIfAbsent(ma, () => []);
            }
            currentProductionData[ma]!
                .addAll(ma == 'MA30' ? yearData?.ma30 : yearData?.ma60);
          }
        }
        if (!currentProductionData.containsKey('date')) {
          currentProductionData.putIfAbsent('date', () => []);
        }
        final updatedDates = (yearData?.date as List<dynamic>?)
            ?.map((date) => '$year-$date')
            .cast<String>()
            .toList();
        currentProductionData["date"]!.addAll(updatedDates ?? []);
      }

      for (var year in sortedPredYears) {
        final actData = indexInfo?.actual.years[year];
        final yearData = indexInfo?.predict.years[year];
        if (actData != null) {
          predProductionData["act_index"]!.addAll(actData.index);
        }
        if (yearData != null) {
          predProductionData["pred_index"]!.addAll(yearData.index);
          final updatedDates = (yearData.date as List<dynamic>?)
              ?.map((date) => '$year-$date')
              .cast<String>()
              .toList();
          predProductionData["date"]!.addAll(updatedDates ?? []);
        }
      }
    }
    setState(() {});
  }

  // 연도 버튼 컬러 매핑
  void _updateYearColorMap() {
    yearColorMap.clear(); // 기존 맵 초기화
    availableYears.sort((a, b) => int.parse(b).compareTo(int.parse(a)));
    availableYears.add('평년');
    selectedYears = [availableYears[0]];

    for (int i = 0; i < availableYears.length; i++) {
      String year = availableYears[i];
      if (year == '평년') {
        yearColorMap[year] = Color(0xFF78B060);
      } else {
        yearColorMap[year] = Color(0xFF0084FF);
      }
    }

    availablePredYears.sort((a, b) => int.parse(b).compareTo(int.parse(a)));
    selectedPredYears = [availablePredYears[0]];
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      // 로딩 화면
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                '분석',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              color: Colors.white,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PriceTableWidget(
                    dataRows: actAnalysis != null
                        ? [
                            [
                              '현재(${actAnalysis?.date})',
                              '${actAnalysis?.thisValue}',
                              ' ',
                              '직전대비',
                              formatPositiveValue(
                                  actAnalysis?.rateComparedLastValue)
                            ],
                            [
                              '전년',
                              '${actAnalysis?.valueComparedLastYear}',
                              '${formatArrowIndicator(actAnalysis?.diffComparedLastValueYear)}(${formatPositiveValue(actAnalysis?.rateComparedLastYear)})'
                            ],
                            [
                              '평년',
                              '${actAnalysis?.valueComparedCommon3Years}',
                              '${formatArrowIndicator(actAnalysis?.diffValueComparedCommon3Years)}(${formatPositiveValue(actAnalysis?.rateComparedCommon3Years)})'
                            ],
                            ['1년 평균가', '${actAnalysis?.yearAverageValue}'],
                            ['안정성 비율', '${actAnalysis?.rateStability}%'],
                            ['상관계수', '${actAnalysis?.correlationCoefficient}'],
                            ['민감도', '${actAnalysis?.sensitivity}'],
                          ]
                        : [
                            ['현재()', '', '', '직전대비', ''],
                            ['전년', '', ''],
                            ['평년', '', ''],
                            ['1년 평균가', ''],
                            ['안정성 비율', ''],
                            ['상관계수', ''],
                            ['민감도', ''],
                          ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: YearButtonWidget(
                      availableYears: availableYears,
                      selectedYears: selectedYears,
                      onYearsChanged: (updatedSelectedYears) {
                        setState(() {
                          selectedYears = updatedSelectedYears;
                          _updateChartData();
                        });
                      },
                      yearColorMap: yearColorMap,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: YearButtonWidget(
                      availableYears: ['MA30', 'MA60'],
                      selectedYears: selectedMa,
                      onYearsChanged: (updatedSelectedYears) {
                        setState(() {
                          selectedMa = updatedSelectedYears;
                          _updateChartData();
                        });
                      },
                      yearColorMap: maColorMap,
                    ),
                  ),
                  const SizedBox(height: 16),
                  IndexCurrentChart(
                    currentProductionData: currentProductionData,
                    commProductionData: commProductionData,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            Divider(),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                '예측',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              color: Colors.white,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PriceTableWidget(
                    dataRows: predAnalysis != null
                        ? [
                            [
                              '예측가(${predAnalysis?.date})',
                              '${predAnalysis?.predictedIndex}',
                              ' ',
                              '직전대비',
                              formatPositiveValue(
                                  predAnalysis?.rateComparedLastValue)
                            ],
                            [
                              '범위',
                              '${predAnalysis?.range[0]} ~ ${predAnalysis?.range[1]}'
                            ],
                            [
                              '범위 이탈 확률',
                              '${predAnalysis?.outOfRangeProbability}%'
                            ],
                            [
                              '안정 구간 확률',
                              '${predAnalysis?.stabilitySectionProbability}%'
                            ],
                            ['일관성 지수', '${predAnalysis?.consistencyIndex}'],
                            ['계절 보정가', '${predAnalysis?.resilienceIndex}'],
                            ['신호 지수', '${predAnalysis?.signalIndex}'],
                          ]
                        : [
                            ['예측가()', '', '', '직전대비', ''],
                            ['범위', ''],
                            ['범위 이탈 확률', ''],
                            ['안정 구간 확률', ''],
                            ['일관성 지수', ''],
                            ['계절 보정가', ''],
                            ['신호 지수', ''],
                          ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 0),
                    child: YearButtonWidget(
                      availableYears: availablePredYears,
                      selectedYears: selectedPredYears,
                      onYearsChanged: (updatedSelectedYears) {
                        setState(() {
                          selectedPredYears = updatedSelectedYears;
                          _updateChartData();
                        });
                      },
                      yearColorMap: yearColorMap,
                    ),
                  ),
                  IndexPredChart(
                    predProductionData: predProductionData,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
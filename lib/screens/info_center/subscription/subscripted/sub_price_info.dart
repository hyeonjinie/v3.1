import 'package:flutter/material.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted/models/price_model.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted/service/prod_info_service.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted/widget/current_chart.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted/widget/grade_btn.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted/widget/pred_curr_chart.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted/widget/pred_table.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted/widget/price_table.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted/widget/seasonal_bar.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted/widget/year_btn.dart';
import 'package:v3_mvp/screens/utils/number_formatter.dart';
import 'package:v3_mvp/screens/utils/positive_negative_formatter.dart';

class SubsInfoPage extends StatefulWidget {
  final String selectedProdName;
  final int selectedProdDay;

  const SubsInfoPage(
      {Key? key, required this.selectedProdName, required this.selectedProdDay})
      : super(key: key);

  @override
  State<SubsInfoPage> createState() => _SubsInfoPageState();
}

class _SubsInfoPageState extends State<SubsInfoPage> {
  //공통
  final PriceService _priceService = PriceService();
  late CropData? priceInfo;
  late String selectedProduct;
  late int selectedProductDay;
  bool isLoading = true;

  // 분석
  ActAnalysis? actAnalysis;
  List<String> availableYears = [];
  List<String> selectedYears = [];
  List<String> availableGrades = [];
  List<String> selectedGrades = [];
  Map<String, dynamic> currentProductionData = {}; //선택한 년도에 대한 분석데이터
  Map<String, dynamic> commProductionData = {}; //선택한 년도에 대한 평년데이터
  List<double> seasonalIndex = []; //선택한 년도에 대한 계절데이터
  List<String?> seasonalIndexDate = [];
  Map<String, Color> yearColorMap = {};
  Map<String, Color> gradeColorMap = {};

  // 예측
  PredAnalysis? predAnalysis;
  List<String> availablePredYears = [];
  List<String> selectedPredYears = [];
  List<String> availablePredGrades = [];
  String selectedPredGrades = '';
  Map<String, dynamic> predProductionData = {}; //선택한 년도에 대한 예측데이터
  List<double> seasonalPredIndex = []; //선택한 년도에 대한 계절 예측데이터
  List<String?> predSeasonalIndexDate = [];
  Map<String, Color> yearPredColorMap = {};
  Map<String, dynamic> predTableData = {};

  @override
  void initState() {
    super.initState();
    selectedProduct = widget.selectedProdName;
    selectedProductDay = widget.selectedProdDay;
    fetchAndPrintPriceInfo();
  }

  void fetchAndPrintPriceInfo() async {
    try {
      priceInfo =
          await _priceService.getPriceData(selectedProduct, selectedProductDay);
    } catch (e) {
      print('Error fetching price data: $e');
    } finally {
      setState(() {
        // 분석
        availableYears = priceInfo!.actual.years.keys.toList();
        availableGrades =
            priceInfo!.actual.years[availableYears[0]]!.grades.keys.toList();
        selectedGrades = [availableGrades[0]];
        actAnalysis = priceInfo!.actual.actAnalysis!;
        // // 예측
        availablePredYears = priceInfo!.predict.years.keys.toList();
        availablePredGrades = priceInfo!
            .predict.years[availablePredYears[0]]!.grades.keys
            .toList();
        selectedPredGrades = availablePredGrades[0];
        predAnalysis = priceInfo!.predict.predAnalysis!;

        _updateYearColorMap();
        _updateGradeColorMap();
        _updateChartData();
        _predPriceData();
        isLoading = false;
      });
    }
  }

  // 예측 테이블 처리
  void _predPriceData() {
  for (var grade in availableGrades) {
    // 각 등급에 대해 초기화
    predTableData[grade] = {
      "pred_price": <double?>[],
      "pred_h_price": <double?>[],
      "pred_l_price": <double?>[],
    };

    // 해당 연도 데이터 가져오기
    final yearData = priceInfo?.predict.years[availablePredYears[0]];
    if (yearData != null && yearData.grades.containsKey(grade)) {
      final gradeData = yearData.grades[grade];
      if (gradeData != null) {
        final predPriceList = gradeData.predPrice ?? [];
        final last15PredPrice = predPriceList.length > selectedProductDay
            ? predPriceList.sublist(predPriceList.length - selectedProductDay)
            : predPriceList;

        predTableData[grade]!["pred_price"]!.addAll(last15PredPrice);

        final predHPriceList = gradeData.predHPrice ?? [];
        final last15PredHPrice = predHPriceList.length > selectedProductDay
            ? predHPriceList.sublist(predHPriceList.length - selectedProductDay)
            : predHPriceList;

        predTableData[grade]!["pred_h_price"]!.addAll(last15PredHPrice);

        final predLPriceList = gradeData.predLPrice ?? [];
        final last15PredLPrice = predLPriceList.length > selectedProductDay
            ? predLPriceList.sublist(predLPriceList.length - selectedProductDay)
            : predLPriceList;

        predTableData[grade]!["pred_l_price"]!.addAll(last15PredLPrice);
      }
    }
  }
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
        yearColorMap[year] = const Color(0xFF78B060);
      } else {
        yearColorMap[year] = const Color(0xFF0084FF);
      }
    }

    availablePredYears.sort((a, b) => int.parse(b).compareTo(int.parse(a)));
    selectedPredYears = [availablePredYears[0]];

    for (int i = 0; i < availablePredYears.length; i++) {
      String year = availablePredYears[i];
      yearPredColorMap[year] = const Color(0xFF0084FF);
    }
  }

  // 등급 버튼 컬러 매핑
  void _updateGradeColorMap() {
    gradeColorMap.clear(); // 기존 맵 초기화
    for (String grade in availableGrades) {
      switch (grade) {
        case '특':
          gradeColorMap[grade] = const Color(0xFF0084FF); // 특
          break;
        case '상':
          gradeColorMap[grade] = const Color(0xFFFF9500); // 상
          break;
        case '보통':
          gradeColorMap[grade] = const Color(0xFF78B060); // 중
          break;
        case '하':
          gradeColorMap[grade] = const Color(0xFF9568EE); // 하
          break;
        case '등급외':
          gradeColorMap[grade] = const Color(0xFFEB5C5C); // 등급외
          break;
        case '해당없음':
          gradeColorMap[grade] = const Color(0xFFEE68C4); // 해당없음
          break;
        default:
          gradeColorMap[grade] = Colors.grey; // 지정되지 않은 경우 기본 색상
      }
    }
  }

  // chart data 추출
  void _updateChartData() {
    currentProductionData.clear();
    commProductionData.clear();
    predProductionData.clear();
    seasonalIndex.clear();
    seasonalIndexDate.clear();
    seasonalPredIndex.clear();
    predSeasonalIndexDate.clear();
    final sortedYears = [...selectedYears]..sort();

    for (var grade in selectedGrades) {
      // 선택된 등급별로 초기화
      currentProductionData[grade] = {
        "price": <double?>[],
        "date": <String?>[],
      };
      commProductionData[grade] = {
        "price": <double?>[],
        "date": <String?>[],
      };

      for (var year in sortedYears) {
        var yearData;
        // '평년' 처리
        if (selectedYears.contains('평년')) {
          yearData = priceInfo?.actual.commYears['평년']?.commyears[year];
          if (yearData != null && yearData.grades.containsKey(grade)) {
            final gradeData = yearData.grades[grade];

            // '평년' 데이터 처리
            commProductionData[grade]["price"]!.addAll(gradeData?.price);

            final updatedDates = gradeData?.date
                .map((date) => '$year-$date')
                .cast<String>()
                .toList();
            commProductionData[grade]["date"]!.addAll(updatedDates ?? []);
          } else {
            // yearData가 null인 경우, 실제 데이터에서 date를 가져옴
            final actualYearData = priceInfo?.actual.years[year];
            if (actualYearData != null &&
                actualYearData.grades.containsKey(grade)) {
              final actualGradeData = actualYearData.grades[grade];

              final updatedDates = actualGradeData?.date
                  .map((date) => '$year-$date')
                  .cast<String>()
                  .toList();
              commProductionData[grade]["date"]!.addAll(updatedDates ?? []);

              // date 길이만큼 price에 0을 추가
              final zeroPrices = List.filled(updatedDates?.length ?? 0, 0.0);
              commProductionData[grade]["price"]!.addAll(zeroPrices);
            }
          }
        }

        // 실제 데이터 처리
        yearData = priceInfo?.actual.years[year];
        if (yearData != null && yearData.grades.containsKey(grade)) {
          final gradeData = yearData.grades[grade];

          currentProductionData[grade]["price"]!.addAll(gradeData?.price);

          final updatedDates = (gradeData?.date as List<dynamic>?)
              ?.map((date) => '$year-$date')
              .cast<String>()
              .toList();
          currentProductionData[grade]["date"]!.addAll(updatedDates ?? []);
        }
      }
    }

    // 실제 계절지수 데이터 처리
    for (var year in sortedYears) {
      var indexData;
      indexData = priceInfo?.actual.seasonal[year];
      if (indexData != null) {
        seasonalIndex.addAll(indexData);
      }
    }
    seasonalIndexDate = currentProductionData[selectedGrades[0]]["date"];

    // 예측 
    predProductionData[selectedPredGrades] = {
      "act_price": <double?>[],
      "pred_price": <double?>[],
      "date": <String?>[],
    };

    for (var year in selectedPredYears..sort()) {
      final yearData = priceInfo?.predict.years[year];
      if (yearData != null && yearData.grades.containsKey(selectedPredGrades)) {
        final gradeData = yearData.grades[selectedPredGrades];
        predProductionData[selectedPredGrades]["act_price"]!
            .addAll(gradeData?.actPrice);
        predProductionData[selectedPredGrades]["pred_price"]!
            .addAll(gradeData?.predPrice);
        final updatedDates = (gradeData?.date as List<dynamic>?)
            ?.map((date) => '$year-$date')
            .cast<String>()
            .toList();
        predProductionData[selectedPredGrades]["date"]!
            .addAll(updatedDates ?? []);
      }
    }

    final sortedPredYears = [...selectedPredYears]..sort();
    // 실제 계절지수 데이터 처리
    for (var year in sortedPredYears) {
      var indexData;
      indexData = priceInfo?.predict.predSeasonal[year];
      if (indexData != null) {
        seasonalPredIndex.addAll(indexData);
      }
    }
    predSeasonalIndexDate = predProductionData[selectedPredGrades[0]]["date"];
    setState(() {});
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
            const SizedBox(height: 10),
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
                              '현재가(${actAnalysis?.date})',
                              '${actAnalysis?.currencyUnit}${formatCurrency(actAnalysis?.thisValue)}',
                              ' (${actAnalysis?.weightUnit})',
                              '직전대비',
                              formatPositiveValue(
                                  actAnalysis?.rateComparedLastValue)
                            ],
                            [
                              '전년',
                              formatCurrency(actAnalysis?.lastYearValue),
                              '${formatArrowIndicator(actAnalysis?.diffComparedLastValueYear)}(${formatPositiveValue(actAnalysis?.rateComparedLastYear)})'
                            ],
                            [
                              '평년',
                              formatCurrency(
                                  actAnalysis?.valueComparedCommon3Years),
                              '${formatArrowIndicator(actAnalysis?.diffValueComparedCommon3Years)}(${formatPositiveValue(actAnalysis?.rateComparedCommon3Years)})'
                            ],
                            [
                              '1년 평균가',
                              formatCurrency(actAnalysis?.yearAverageValue)
                            ],
                            [
                              '1년 변동가',
                              formatCurrency(actAnalysis?.yearChangeValue)
                            ],
                            ['계절 지수', '${actAnalysis?.seasonalIndex}'],
                            [
                              '공급 안정성 지수',
                              '${actAnalysis?.supplyStabilityIndex}'
                            ],
                          ]
                        : [
                            ['현재가()', '', '', '직전대비', ''],
                            ['전년', '', ''],
                            ['평년', '', ''],
                            ['1년 평균가', ''],
                            ['1년 변동가', ''],
                            ['계절 지수', ''],
                            ['공급 안정성 지수', ''],
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
                      availableYears: availableGrades,
                      selectedYears: selectedGrades,
                      onYearsChanged: (updatedSelectedYears) {
                        setState(() {
                          selectedGrades = updatedSelectedYears;
                          _updateChartData();
                        });
                      },
                      yearColorMap: gradeColorMap,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CurrentChart(
                    currentProductionData: currentProductionData,
                    commProductionData: commProductionData,
                    gradeColorMap: gradeColorMap,
                  ),
                  SeasonalBarWidget(
                    seasonalIndex: seasonalIndex,
                    seasonalDate: seasonalIndexDate,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            const Divider(),
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
                              '${predAnalysis?.currencyUnit}${formatCurrency(predAnalysis?.predictedPrice)}',
                              ' (${predAnalysis?.weightUnit})',
                              '직전대비',
                              '${predAnalysis?.rateComparedLastValue}%'
                            ],
                            [
                              '범위',
                              '${formatCurrency(predAnalysis?.range?[0])} ~ ${formatCurrency(predAnalysis?.range?[1])}'
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
                            [
                              '계절 보정가',
                              formatCurrency(
                                  predAnalysis?.seasonallyAdjustedPrice)
                            ],
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
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: YearButtonWidget(
                      availableYears: availablePredYears,
                      selectedYears: selectedPredYears,
                      onYearsChanged: (updatedSelectedYears) {
                        setState(() {
                          selectedPredYears = updatedSelectedYears;
                          _updateChartData();
                        });
                      },
                      yearColorMap: yearPredColorMap,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GradeButtonWidget(
                      onGradeChanged: (newSelectedForecast) {
                        setState(() {
                          selectedPredGrades = newSelectedForecast;
                          _updateChartData();
                        });
                      },
                      btnNames: availablePredGrades,
                      selectedBtn: selectedPredGrades,
                    ),
                  ),
                  TrendChart(
                    predProductionData: predProductionData,
                  ),
                  SeasonalBarWidget(
                    seasonalIndex: seasonalPredIndex,
                    seasonalDate: predSeasonalIndexDate,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: PredTableWidget(
                      predTableData: predTableData,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
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

import 'package:flutter/material.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted/mock_data/price_mock.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted/models/price_model.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted/service/prod_info_service.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted/widget/current_chart.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted/widget/grade_btn.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted/widget/pred_curr_chart.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted/widget/price_table.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted/widget/seasonal_bar.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted/widget/year_btn.dart';
import 'package:v3_mvp/widgets/font_size_helper/font_size_helper.dart';

class SubsInfoPage extends StatefulWidget {
  const SubsInfoPage({Key? key}) : super(key: key);

  @override
  State<SubsInfoPage> createState() => _SubsInfoPageState();
}

class _SubsInfoPageState extends State<SubsInfoPage> {
  //공통
  final PriceService _priceService = PriceService();
  late CropData? priceInfo;
  String selectedProduct = "딸기";
  bool isLoading = true;

  // 분석
  ActAnalysis? actAnalysis;
  List<String> availableYears = [];
  List<String> selectedYears = [];
  List<String> availableGrades = [];
  List<String> selectedGrades = [];
  Map<String, dynamic> currentProductionData = {}; //선택한 년도에 대한 분석데이터
  Map<String, dynamic> commProductionData = {}; //선택한 년도에 대한 분석데이터
  List<double> seasonalIndex = []; //선택한 년도에 대한 계절데이터
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
  Map<String, Color> yearPredColorMap = {};

  @override
  void initState() {
    super.initState();
    fetchAndPrintPriceInfo();
  }

  void fetchAndPrintPriceInfo() async {
    try {
      priceInfo = await _priceService.getPriceData(selectedProduct);
      // 분석
      availableYears = priceInfo!.actual.years.keys.toList();
      availableGrades =
          priceInfo!.actual.years[availableYears[0]]!.grades.keys.toList();
      selectedGrades = [availableGrades[0]];
      actAnalysis = priceInfo!.actual.actAnalysis!;
      // 예측
      availablePredYears = priceInfo!.predict.years.keys.toList();
      availablePredGrades =
          priceInfo!.predict.years[availablePredYears[0]]!.grades.keys.toList();
      selectedPredGrades = availablePredGrades[0];
      predAnalysis = priceInfo!.predict.predAnalysis!;

      _updateYearColorMap();
      _updateGradeColorMap();
      _updateChartData();
    } catch (e) {
      print('Error fetching price data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
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
          gradeColorMap[grade] = const Color(0xFFEB5C5C); // 특
          break;
        case '상':
          gradeColorMap[grade] = const Color(0xFFFF9500); // 상
          break;
        case '중':
          gradeColorMap[grade] = const Color(0xFFF8D32D); // 중
          break;
        case '하':
          gradeColorMap[grade] = const Color(0xFF9568EE); // 하
          break;
        case '등급외':
          gradeColorMap[grade] = const Color(0xFFEE68C4); // 등급외
          break;
        case '해당없음':
          gradeColorMap[grade] = const Color(0xFF0084FF); // 해당없음
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

      if (selectedYears.contains('평년')) {
        final sortedYears = [...selectedYears]..remove('평년')..sort();
        for (var year in sortedYears) {
          var yearData;
          yearData = priceInfo!.actual.commYears['평년']!.commyears[year];
          if (yearData != null && yearData.grades.containsKey(grade)) {
            final gradeData = yearData.grades[grade];
            commProductionData[grade]["price"]!.addAll(gradeData?.price);
            commProductionData[grade]["date"]!.addAll(gradeData?.date);
          }
        }
      }

      for (var year in selectedYears..sort()) {
        var yearData;
        // 선택된 년도 데이터를 가져옴
          yearData = priceInfo?.actual.years[year];
          if (yearData != null && yearData.grades.containsKey(grade)) {
            final gradeData = yearData.grades[grade];
            currentProductionData[grade]["price"]!.addAll(gradeData?.price);
            currentProductionData[grade]["date"]!.addAll(gradeData?.date);
          }
      }
    }

    predProductionData[selectedPredGrades] = {
      "act_price": <double?>[],
      "pred_price": <double?>[],
      "date": <String?>[],
    };

    for (var year in selectedPredYears..sort()) {
      // 선택된 년도 데이터를 가져옴
      final yearData = priceInfo?.predict.years[year];
      if (yearData != null && yearData.grades.containsKey(selectedPredGrades)) {
        final gradeData = yearData.grades[selectedPredGrades];
        predProductionData[selectedPredGrades]["act_price"]!
            .addAll(gradeData?.actPrice);
        predProductionData[selectedPredGrades]["pred_price"]!
            .addAll(gradeData?.predPrice);
        predProductionData[selectedPredGrades]["date"]!.addAll(gradeData?.date);
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      // 로딩 화면
      return Center(
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
                              '${actAnalysis?.currencyUnit}${actAnalysis?.thisValue}',
                              ' (kg)',
                              '직전대비',
                              '+${actAnalysis?.rateComparedLastValue}%'
                            ],
                            [
                              '전년',
                              '${actAnalysis?.valueComparedLastYear}',
                              '${actAnalysis?.diffComparedLastValueYear}(${actAnalysis?.rateComparedLastYear}%)'
                            ],
                            [
                              '평년',
                              '${actAnalysis?.valueComparedCommon3Years}',
                              '${actAnalysis?.diffValueComparedCommon3Years}(${actAnalysis?.rateComparedCommon3Years}%)'
                            ],
                            [
                              '1년 평균가',
                              '${actAnalysis?.valueComparedCommon3Years}'
                            ],
                            ['1년 변동가', '${actAnalysis?.yearChangeValue}'],
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
                  // SeasonalBarWidget(
                  //   seasonalIndex: seasonalIndex,
                  //   selectedYears: selectedYears,
                  // ),
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
                              '${predAnalysis?.currencyUnit}${predAnalysis?.predictedPrice}',
                              ' (${predAnalysis?.weightUnit})',
                              '직전대비',
                              '${predAnalysis?.rateComparedLastValue}%'
                            ],
                            [
                              '범위',
                              '${predAnalysis?.range?[0]} ~ ${predAnalysis?.range?[1]}'
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
                              '${predAnalysis?.seasonallyAdjustedPrice}'
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
                  // SeasonalBarWidget(
                  //   seasonalIndex: seasonalPredIndex,
                  //   selectedYears: selectedPredYears,
                  // ),
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

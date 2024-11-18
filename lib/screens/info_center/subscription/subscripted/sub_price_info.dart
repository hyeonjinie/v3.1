import 'package:flutter/material.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted/mock_data/price_mock.dart';
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
  Map<String, dynamic> priceMockupData = priceMockData;
  String selectedProduct = "들깨";
  String selectedPriceType = "해외";
  String priceCategory = "수출가격";
  bool isContinuousView = false; //그래프 이어서 보기

  // 분석
  Map<String, dynamic> cropData = {}; // 선택된 작물 및 옵션의 실제가격 데이터
  Map<String, List<double>> currentProductionData = {}; //선택한 년도에 대한 분석데이터
  List<double> seasonalIndex = []; //선택한 년도에 대한 계절데이터
  Map<String, Color> yearColorMap = {}; //생성된 년도에 따른 컬러 매핑
  List<String> availableYears = []; // 생성해야 하는 연도 버튼
  List<String> selectedYears = [];
  List<String> availableGrades = [];
  List<String> selectedGrades = [];
  Map<String, Color> gradeColorMap = {}; //생성된 등급에 따른 컬러 매핑

  // 예측
  Map<String, dynamic> cropPredData = {};
  List<double> predCurrProductionData = [];
  List<double> predProductionData = [];
  List<String> date = [];
  List<double> seasonalPredIndex = [];
  List<String> availablePredYears = [];
  List<String> selectedPredYears = [];
  Map<String, Color> yearPredColorMap = {};
  List<String> availablePredGrades = [];
  String selectedPredGrades = '해당없음';

  @override
  void initState() {
    super.initState();
    _updateYearColorMap();
    _updateGradeColorMap();
    _updateChartData();
  }

  // chart data 추출
  void _updateChartData() {
    // 선택된 작물 및 옵션의 실제가격 데이터 가져오기
    cropData = priceMockupData['selectedCrops'][selectedProduct]['prices']
        [selectedPriceType][priceCategory]['실제가격'];
    cropPredData = priceMockupData['selectedCrops'][selectedProduct]['prices']
        [selectedPriceType][priceCategory]['예측가격'];

// 선택된 연도들의 데이터 가져오기
    currentProductionData = {
      for (var grade in selectedGrades)
        grade: [
          for (var year in (selectedYears..sort()))
            if (year != '평년')
              ...List<double>.from((cropData[year][grade] ?? [])
                  .where((data) => data != null)
                  .map((data) => data!.toDouble()))
        ]
    };

    // 평년 데이터 처리
    if (selectedYears.contains('평년')) {
      currentProductionData['평년'] = [
        for (var year in selectedYears.where((y) => y != '평년').toList()..sort())
          if (cropData['평년'].containsKey(year))
            ...List<double>.from((cropData['평년'][year] ?? [])
                .where((data) => data != null)
                .map((data) => data!.toDouble()))
          else
            ...List<double>.filled(12, 0.0) // 빈 값으로 채우기
      ];
    }

    predProductionData = [
      for (var year in selectedPredYears..sort())
        ...List<double>.from((cropPredData[year][selectedPredGrades] ?? [])
            .where((data) => data != null)
            .map((data) => data!.toDouble()))
    ];
    predCurrProductionData = [
      for (var year in selectedPredYears..sort())
        if (year != '평년')
          ...List<double>.from((cropData[year][selectedPredGrades] ?? [])
              .where((data) => data != null)
              .map((data) => data!.toDouble()))
    ];
    int yearIndex = 0;
    int month = 1;
    date.clear();

    for (int i = 0; i < predProductionData.length; i++) {
      date.add(
          '${selectedPredYears[yearIndex].substring(2)}.${month.toString().padLeft(2, '0')}');
      month++;
      if (month > 12) {
        month = 1;
        yearIndex++;
        if (yearIndex >= selectedPredYears.length) {
          yearIndex = 0;
        }
      }
    }
    date.sort((a, b) {
      int yearA = int.parse(a.split('.')[0]);
      int monthA = int.parse(a.split('.')[1]);
      int yearB = int.parse(b.split('.')[0]);
      int monthB = int.parse(b.split('.')[1]);

      if (yearA == yearB) {
        return monthA.compareTo(monthB);
      } else {
        return yearA.compareTo(yearB);
      }
    });

    // 계절지수 설정하기
    seasonalIndex = [
      for (var year in selectedYears..sort())
        if (year != '평년')
          ...List<double>.from((cropData['monthly_seasonal_index'][year] ?? [])
              .where((data) => data != null)
              .map((data) => data!.toDouble()))
    ];
    seasonalPredIndex = [
      for (var year in selectedPredYears..sort())
        ...List<double>.from(
            (cropPredData['monthly_seasonal_index'][year] ?? [])
                .where((data) => data != null)
                .map((data) => data!.toDouble()))
    ];

    setState(() {});
  }

  // 연도 버튼 컬러 매핑
  void _updateYearColorMap() {
    yearColorMap.clear(); // 기존 맵 초기화
    availableYears = priceMockupData['selectedCrops'][selectedProduct]['prices']
            [selectedPriceType][priceCategory]['실제가격']
        .keys
        .where((year) =>
            year != 'act_analysis' &&
            year != '평년' &&
            year != 'monthly_seasonal_index')
        .toList();
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

    availablePredYears = priceMockupData['selectedCrops'][selectedProduct]
            ['prices'][selectedPriceType][priceCategory]['예측가격']
        .keys
        .where((year) =>
            year != 'pred_analysis' && year != 'monthly_seasonal_index')
        .toList();
    availablePredYears.sort((a, b) => int.parse(b).compareTo(int.parse(a)));
    selectedPredYears = [availablePredYears[0]];

    for (int i = 0; i < availablePredYears.length; i++) {
      String year = availablePredYears[i];
      if (year == '평년') {
        yearPredColorMap[year] = const Color(0xFF78B060);
      } else {
        yearPredColorMap[year] = const Color(0xFF0084FF);
      }
    }
  }

  // 등급 버튼 컬러 매핑
  void _updateGradeColorMap() {
    gradeColorMap.clear(); // 기존 맵 초기화
    availableGrades = priceMockupData['selectedCrops'][selectedProduct]
                ['prices'][selectedPriceType][priceCategory]['실제가격']
            [availableYears[0]]
        .keys
        .toList();
    selectedGrades = ['해당없음'];
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
    availablePredGrades = priceMockupData['selectedCrops'][selectedProduct]
                ['prices'][selectedPriceType][priceCategory]['예측가격']
            [availableYears[0]]
        .keys
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
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
                    dataRows: cropData['act_analysis'] != null
                        ? [
                            ['현재가()', '￦1,100', ' (ton)', '직전대비', '+3%'],
                            ['전년', '1,050', '▲100(+0.4%)'],
                            ['평년', '1,050', '▲100(+0.4%)'],
                            ['1년 평균가', '1,450'],
                            ['1년 변동가', '1,450'],
                            ['계절 지수', '1.08'],
                            ['공급 안정성 지수', '13.25'],
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
                  YearButtonWidget(
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
                  YearButtonWidget(
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
                  const SizedBox(height: 16),
                  CurrentChart(
                    selectedGrades: selectedGrades,
                    selectedYears: selectedYears,
                    currentProductionData: currentProductionData,
                    onToggleView: (bool newValue) {
                      setState(() {
                        isContinuousView = newValue;
                      });
                    },
                    gradeColorMap: gradeColorMap,
                    unit: cropData['act_analysis'] != null
                        ? '(${cropData['act_analysis']['currency_unit']})'
                        : '',
                    hoverText: 'point.x: point.y',
                  ),
                  SeasonalBarWidget(
                    seasonalIndex: seasonalIndex,
                    selectedYears: selectedYears,
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
              padding: EdgeInsets.symmetric(horizontal: 16.0),
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
                    dataRows: cropPredData['pred_analysis'] != null
                        ? [
                            ['예측가()', '', '', '직전대비', ''],
                            ['범위', ' ~ '],
                            ['범위 이탈 확률', '%'],
                            ['안정 구간 확률', '%'],
                            ['일관성 지수', ''],
                            ['계절 보정가', ''],
                            ['신호 지수', ''],
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
                  YearButtonWidget(
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
                  GradeButtonWidget(
                    onGradeChanged: (newSelectedForecast) {
                      setState(() {
                        selectedPredGrades = newSelectedForecast;
                        _updateChartData();
                      });
                    },
                    btnNames: availablePredGrades,
                    selectedBtn: selectedPredGrades,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TrendChart(
                    latestPred: predProductionData,
                    latestActual: predCurrProductionData,
                    date: date,
                    actualName: '현재가격',
                    predictedName: '예측가격',
                    unit: '',
                  ),
                  SeasonalBarWidget(
                    seasonalIndex: seasonalPredIndex,
                    selectedYears: selectedPredYears,
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

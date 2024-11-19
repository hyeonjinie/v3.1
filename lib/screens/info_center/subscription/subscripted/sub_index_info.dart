import 'package:flutter/material.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted/mock_data/index_mock.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted/widget/index_curr_chart.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted/widget/pred_curr_chart.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted/widget/price_table.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted/widget/year_btn.dart';
import 'package:v3_mvp/screens/utils/positive_negative_formatter.dart';

class SubIndexInfo extends StatefulWidget {
  const SubIndexInfo({Key? key}) : super(key: key);

  @override
  State<SubIndexInfo> createState() => _SubIndexInfoState();
}

class _SubIndexInfoState extends State<SubIndexInfo> {
  //공통
  Map<String, dynamic> indexMockupData = indexMockData;

  // 분석
  Map<String, dynamic> cropData = {}; // 선택된 작물 및 옵션의 실제가격 데이터
  Map<String, List<double>> currentProductionData = {}; //선택한 년도에 대한 분석데이터
  Map<String, Color> yearColorMap = {}; //생성된 년도에 따른 컬러 매핑
  List<String> availableYears = []; // 생성해야 하는 연도 버튼
  List<String> selectedYears = [];
  Map<String, Color> maColorMap = {
    'MA30': Color(0xFFD58585),
    'MA60': Color(0xFF469E79)
  };

  // 예측
  Map<String, dynamic> cropPredData = {};
  List<double> predCurrProductionData = [];
  List<double> predProductionData = [];
  List<String> date = [];
  List<String> availablePredYears = [];
  List<String> selectedPredYears = [];
  Map<String, Color> yearPredColorMap = {};

  @override
  void initState() {
    super.initState();
    _updateYearColorMap();
    _updateChartData();
  }

  // chart data 추출
  void _updateChartData() {
    // 선택된 작물 및 옵션의 실제가격 데이터 가져오기
    cropData = indexMockupData['subscription']['index']['묶음지수']['농산물']['가락top5']
        ['실제지수'];
    cropPredData = indexMockupData['subscription']['index']['묶음지수']['농산물']
        ['가락top5']['예측지수'];

    currentProductionData = {};
    // 선택된 연도들의 데이터 가져오기
    currentProductionData['분석지수'] = [
      for (var year in (selectedYears..sort()))
        if (year != '평년' && year != 'MA30' && year != 'MA60')
          ...List<double>.from((cropData[year] ?? [])
              .where((data) => data != null)
              .map((data) => data!.toDouble()))
    ];

    // 평년 데이터 처리
    if (selectedYears.contains('평년')) {
      currentProductionData['평년'] = [
        for (var year
            in selectedYears
                .where((y) => (y != '평년' && y != 'MA30' && y != 'MA60'))
                .toList()
              ..sort())
          if (cropData['평년'].containsKey(year))
            ...List<double>.from((cropData['평년'][year] ?? [])
                .where((data) => data != null)
                .map((data) => data!.toDouble()))
          else
            ...List<double>.filled(12, 0.0) // 빈 값으로 채우기
      ];
    }

    // MA 데이터 처리
    for (var maKey in ['MA30', 'MA60']) {
      if (selectedYears.contains(maKey)) {
        currentProductionData[maKey] = [
          for (var year
              in selectedYears
                  .where((y) => (y != '평년' && y != 'MA30' && y != 'MA60'))
                  .toList()
                ..sort())
            if (cropData[maKey].containsKey(year))
              ...List<double>.from((cropData[maKey][year] ?? [])
                  .where((data) => data != null)
                  .map((data) => data!.toDouble()))
            else
              ...List<double>.filled(12, 0.0)
        ];
      }
    }

    predProductionData = [
      for (var year in selectedPredYears..sort())
        ...List<double>.from((cropPredData[year] ?? [])
            .where((data) => data != null)
            .map((data) => data!.toDouble()))
    ];
    predCurrProductionData = [
      for (var year in selectedPredYears..sort())
        if (year != '평년')
          ...List<double>.from((cropData[year] ?? [])
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

    setState(() {});
  }

  // 연도 버튼 컬러 매핑
  void _updateYearColorMap() {
    yearColorMap.clear(); // 기존 맵 초기화
    availableYears = indexMockupData['subscription']['index']['묶음지수']['농산물']
            ['가락top5']['실제지수']
        .keys
        .where((year) =>
            year != 'act_analysis' &&
            year != '평년' &&
            year != 'MA30' &&
            year != 'MA60')
        .toList();
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

    availablePredYears = indexMockupData['subscription']['index']['묶음지수']['농산물']
            ['가락top5']['예측지수']
        .keys
        .where((year) =>
            year != 'pred_analysis')
        .toList();
    availablePredYears.sort((a, b) => int.parse(b).compareTo(int.parse(a)));
    selectedPredYears = [availablePredYears[0]];

    for (int i = 0; i < availablePredYears.length; i++) {
      String year = availablePredYears[i];
      yearPredColorMap[year] = Color(0xFF0084FF);
    }
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
                            [
                              '현재(${cropData['act_analysis']['date']})',
                              '${cropData['act_analysis']['this_value']}',
                              ' ',
                              '직전대비',
                              formatPositiveValue(cropData['act_analysis']
                                  ['rate_compared_last_value'])
                            ],
                            [
                              '전년',
                              '${cropData['act_analysis']['value_compared_last_year']}',
                              '${formatArrowIndicator(cropData['act_analysis']['diff_compared_last_value_year'])}(${formatPositiveValue(cropData['act_analysis']['rate_compared_last_year'])})'
                            ],
                            [
                              '평년',
                              '${cropData['act_analysis']['value_compared_common_3years']}',
                              '${formatArrowIndicator(cropData['act_analysis']['diff_compared_last_value_year'])}(${formatPositiveValue(cropData['act_analysis']['rate_compared_common_3years'])})'
                            ],
                            [
                              '1년 평균가',
                              '${cropData['act_analysis']['year_average_value']}'
                            ],
                            [
                              '안정성 비율',
                              '${cropData['act_analysis']['rate_stability']}%'
                            ],
                            [
                              '상관계수',
                              '${cropData['act_analysis']['correlation_coefficient']}'
                            ],
                            [
                              '민감도',
                              '${cropData['act_analysis']['sensitivity']}'
                            ],
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
                    availableYears: ['MA30', 'MA60'],
                    selectedYears: selectedYears,
                    onYearsChanged: (updatedSelectedYears) {
                      setState(() {
                        selectedYears = updatedSelectedYears;
                        _updateChartData();
                      });
                    },
                    yearColorMap: maColorMap,
                  ),
                  const SizedBox(height: 16),
                  IndexCurrentChart(
                    selectedYears: selectedYears,
                    currentProductionData: currentProductionData,
                    hoverText: 'point.x: point.y',
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
                            [
                              '예측가(${cropPredData['pred_analysis']['date']})',
                              '${cropPredData['pred_analysis']['predicted_index']}',
                              ' ',
                              '직전대비',
                              formatPositiveValue(cropPredData['pred_analysis']
                                  ['rate_compared_last_value'])
                            ],
                            [
                              '범위',
                              '${cropPredData['pred_analysis']['range'][0]} ~ ${cropPredData['pred_analysis']['range'][1]}'
                            ],
                            [
                              '범위 이탈 확률',
                              '${cropPredData['pred_analysis']['out_of_range_probability']}%'
                            ],
                            [
                              '안정 구간 확률',
                              '${cropPredData['pred_analysis']['stability_section_probability']}%'
                            ],
                            [
                              '일관성 지수',
                              '${cropPredData['pred_analysis']['consistency_index']}'
                            ],
                            [
                              '계절 보정가',
                              '${cropPredData['pred_analysis']['resilience_index']}'
                            ],
                            [
                              '신호 지수',
                              '${cropPredData['pred_analysis']['signal_index']}'
                            ],
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

                  const SizedBox(
                    height: 10,
                  ),
                  TrendChart(
                    latestPred: predProductionData,
                    latestActual: predCurrProductionData,
                    date: date,
                    actualName: '현재',
                    predictedName: '예측',
                    unit: '',
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

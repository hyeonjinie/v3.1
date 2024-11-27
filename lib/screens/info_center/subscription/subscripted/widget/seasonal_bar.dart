import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SeasonalBarWidget extends StatelessWidget {
  final List<double> seasonalIndex;
  final List<String?> seasonalDate;

  const SeasonalBarWidget({
    Key? key,
    required this.seasonalIndex,
    required this.seasonalDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Y축 최대값 계산: 최대값에 약간의 여유를 추가
    double dynamicMaxValue = (seasonalIndex.isNotEmpty
            ? seasonalIndex.reduce((a, b) => a > b ? a : b)
            : 1.0) +
        0.5;

    return SizedBox(
      height: 150,
      child: SfCartesianChart(
        tooltipBehavior: TooltipBehavior(
          enable: true, 
          header: '', 
          canShowMarker: false, 
          format: 'point.x : point.y', 
        ),
        primaryXAxis: const CategoryAxis(
          majorGridLines: MajorGridLines(width: 0),
          labelRotation: -20, 
          interval: 1,
          labelStyle: TextStyle(
            color: Color(0xFF666C77),
            fontSize: 12,
          ),
        ),
        primaryYAxis: NumericAxis(
          minimum: 0,
          maximum: dynamicMaxValue,
          interval: 1,
          majorGridLines: const MajorGridLines(
            width: 0.5,
            color: Color(0xFFEEEEEE),
          ),
          labelStyle: const TextStyle(
            color: Color(0xFF666C77),
            fontSize: 12,
          ),
        ),
        series: <CartesianSeries>[
          // 실제 데이터 막대 시리즈
          StackedColumnSeries<double, String>(
            dataSource: seasonalIndex,
            xValueMapper: (data, index) => seasonalDate[index],
            yValueMapper: (data, _) => data,
            pointColorMapper: (data, _) =>
                data < 1 ? const Color(0xFF2478C7) : const Color(0xFFEB5C5C),
            animationDuration: 500,
            dataLabelSettings: const DataLabelSettings(isVisible: false),
            enableTooltip: true, 
          ),
          // 회색 고정 막대 시리즈
          StackedColumnSeries<double, String>(
            dataSource: List.filled(seasonalIndex.length, dynamicMaxValue),
            xValueMapper: (data, index) => seasonalDate[index],
            yValueMapper: (data, _) => data,
            color: Colors.grey.withOpacity(0.3),
            animationDuration: 500,
            dataLabelSettings: const DataLabelSettings(isVisible: false),
            enableTooltip: false, 
          ),
        ],
      ),
    );
  }
}

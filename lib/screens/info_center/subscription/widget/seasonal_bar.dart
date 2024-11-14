import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SeasonalBarWidget extends StatelessWidget {
  final List<double> seasonalIndex;
  final List<String> selectedYears;

  const SeasonalBarWidget({
    Key? key,
    required this.seasonalIndex,
    required this.selectedYears,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 최대값 설정 (Y축 범위에 맞춰서 설정)
    double maxBarValue = 1.5;

    List<String> xLabels = [];
    List<String> years = List.from(selectedYears.where((year) => year != '평년'))
      ..sort();

    int month = 1;
    for (var year in years) {
      while (month <= 12 && xLabels.length < seasonalIndex.length) {
        xLabels.add('$year.${month.toString().padLeft(2, '0')}');
        month++;
      }
      month = 1;
    }

    return Container(
      height: 150,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(
          minimum: 0,
          maximum: maxBarValue,
          interval: 1,
        ),
        series: <CartesianSeries>[
          StackedColumnSeries<double, String>(
            dataSource: seasonalIndex,
            xValueMapper: (data, index) => xLabels[index],
            yValueMapper: (data, _) => data,
            pointColorMapper: (data, _) =>
                data < 1 ? const Color(0xFF2478C7) : const Color(0xFFEB5C5C),
            animationDuration: 500,
          ),
          // 회색 고정 막대 시리즈
          StackedColumnSeries<double, String>(
            dataSource: List.filled(seasonalIndex.length, maxBarValue),
            xValueMapper: (data, index) => xLabels[index],
            yValueMapper: (data, _) => data,
            color: Colors.grey.withOpacity(0.3),
            animationDuration: 500,
          ),
          // 실제 데이터 막대 시리즈
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CurrentChart extends StatefulWidget {
  final List<String> selectedGrades;
  final List<String> selectedYears;
  final Map<String, List<double>> currentProductionData;
  final ValueChanged<bool> onToggleView;
  final Map<String, Color> gradeColorMap;
  final String unit;
  final String hoverText;

  const CurrentChart({
    Key? key,
    required this.selectedGrades,
    required this.selectedYears,
    required this.currentProductionData,
    required this.onToggleView,
    required this.gradeColorMap,
    required this.unit,
    required this.hoverText,
  }) : super(key: key);

  @override
  _CurrentChartState createState() => _CurrentChartState();
}

class _CurrentChartState extends State<CurrentChart> {
  @override
  Widget build(BuildContext context) {
    return _buildChart();
  }

  // 그래프 그리기
  Widget _buildChart() {
    final TooltipBehavior tooltipBehavior = TooltipBehavior(
      enable: true,
      format: widget.hoverText,
    );

    final TrackballBehavior trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap, // 터치할 때 트랙볼 활성화
      tooltipSettings: InteractiveTooltip(
        enable: true,
        format: widget.hoverText,
      ),
      lineType: TrackballLineType.vertical, // 수평으로 호버 이펙트 표시
      markerSettings: TrackballMarkerSettings(
          markerVisibility: TrackballVisibilityMode.visible),
    );

    List<String> xLabels = [];
    List<String> years =
        List.from(widget.selectedYears.where((year) => year != '평년'))..sort();

    int month = 1;
    for (var year in years) {
      while (month <= 12 && xLabels.length < widget.currentProductionData.values.first.length) {
        xLabels.add(
            '$year.${month.toString().padLeft(2, '0')}'); // 'YYYY.MM' 형식으로 추가
        month++;
      }
      month = 1; 
    }

    return Container(
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(
          labelRotation: 0,
          interval: null,
          desiredIntervals: null, // 연속 그래프일 때 레이블 간격 설정
          edgeLabelPlacement: EdgeLabelPlacement.shift,
        ),
        tooltipBehavior: tooltipBehavior,
        trackballBehavior: trackballBehavior,
        series: widget.selectedGrades.map((grade) {
          List<double> filteredData = widget.currentProductionData[grade] ?? [];
          return LineSeries<double, String>(
            name: grade,
            dataSource: filteredData,
            xValueMapper: (double data, int index) => xLabels[index],
            yValueMapper: (double data, _) => data,
            // markerSettings: MarkerSettings(isVisible: true),
            color: widget.gradeColorMap[grade],
            animationDuration: 0,
          );
        }).toList(),
      ),
    );
  }
}

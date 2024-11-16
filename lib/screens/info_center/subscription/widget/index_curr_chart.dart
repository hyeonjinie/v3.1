import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// _ChartData 클래스 정의 추가
class _ChartData {
  final String x;
  final double y;

  _ChartData(this.x, this.y);
}

class IndexCurrentChart extends StatefulWidget {
  final Map<String, List<double>> currentProductionData;
  final List<String> selectedYears;
  final String hoverText;

  const IndexCurrentChart({
    Key? key, 
    required this.currentProductionData,
    required this.selectedYears,
    required this.hoverText,
  }) : super(key: key);

  @override
  State<IndexCurrentChart> createState() => _CurrentChartState();
}

class _CurrentChartState extends State<IndexCurrentChart> {
  @override
  Widget build(BuildContext context) {
    return _buildChart();
  }

  Widget _buildChart() {
    final TooltipBehavior tooltipBehavior = TooltipBehavior(
      enable: true,
      format: widget.hoverText,
    );

    final TrackballBehavior trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
      tooltipSettings: const InteractiveTooltip(
        enable: true,
      ),
      lineType: TrackballLineType.vertical,
      markerSettings: const TrackballMarkerSettings(
        markerVisibility: TrackballVisibilityMode.visible,
      ),
    );

    // xLabels 생성: 선택된 연도와 평년을 포함한 통합 타임라인 생성
    List<String> xLabels = [];
    List<String> years =
        List.from(widget.selectedYears.where((year) => year != '평년'))..sort();

    for (var year in years) {
      for (int month = 1; month <= 12; month++) {
        xLabels.add(
            '${year.substring(2)}.${month.toString().padLeft(2, '0')}'); // 'YY.MM'
      }
    }

    // x축 레이블에 중복 제거
    xLabels = xLabels.toSet().toList();

    return SfCartesianChart(
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
        labelRotation: 0,
        interval: 1,
        labelStyle: TextStyle(
          color: Color(0xFF666C77),
          fontSize: 12,
        ),
      ),
      primaryYAxis: const NumericAxis(
        majorGridLines: MajorGridLines(
          width: 0.5,
          color: Color(0xFFEEEEEE),
        ),
        labelStyle: TextStyle(
          color: Color(0xFF666C77),
          fontSize: 12,
        ),
      ),
      tooltipBehavior: tooltipBehavior,
      trackballBehavior: trackballBehavior,
      series: [
        LineSeries<_ChartData, String>(
            name: '분석지수',
            dataSource: List.generate(
              widget.currentProductionData['분석지수']!.length,
              (index) => _ChartData(
                  xLabels[index], widget.currentProductionData['분석지수']![index]),
            ),
            xValueMapper: (_ChartData data, _) => data.x,
            yValueMapper: (_ChartData data, _) => data.y,
            color: const Color(0xFF0084FF), 
            animationDuration: 0,
            markerSettings: const MarkerSettings(
              isVisible: true,
              width: 4, 
              height: 4, 
            ),
          ),
        // 평년 데이터 추가
        if (widget.currentProductionData.containsKey('평년'))
          LineSeries<_ChartData, String>(
            name: '평년',
            dataSource: List.generate(
              widget.currentProductionData['평년']!.length,
              (index) => _ChartData(
                  xLabels[index], widget.currentProductionData['평년']![index]),
            ),
            xValueMapper: (_ChartData data, _) => data.x,
            yValueMapper: (_ChartData data, _) => data.y,
            color: const Color(0xFFB8D9AA), // 평년 데이터 색상
            animationDuration: 0,
            markerSettings: const MarkerSettings(
              isVisible: true,
              width: 4, // TrendChart와 동일한 크기
              height: 4, // TrendChart와 동일한 크기
            ),
          ),
          // MA30 데이터 추가
        if (widget.currentProductionData.containsKey('MA30'))
          LineSeries<_ChartData, String>(
            name: 'MA30',
            dataSource: List.generate(
              widget.currentProductionData['MA30']!.length,
              (index) => _ChartData(
                  xLabels[index], widget.currentProductionData['MA30']![index]),
            ),
            xValueMapper: (_ChartData data, _) => data.x,
            yValueMapper: (_ChartData data, _) => data.y,
            color: const Color(0xFFD58585),
            animationDuration: 0,
            markerSettings: const MarkerSettings(
              isVisible: true,
              width: 4, // TrendChart와 동일한 크기
              height: 4, // TrendChart와 동일한 크기
            ),
          ),
          // MA60 데이터 추가
        if (widget.currentProductionData.containsKey('MA60'))
          LineSeries<_ChartData, String>(
            name: 'MA60',
            dataSource: List.generate(
              widget.currentProductionData['MA60']!.length,
              (index) => _ChartData(
                  xLabels[index], widget.currentProductionData['MA60']![index]),
            ),
            xValueMapper: (_ChartData data, _) => data.x,
            yValueMapper: (_ChartData data, _) => data.y,
            color: const Color(0xFF469E79), 
            animationDuration: 0,
            markerSettings: const MarkerSettings(
              isVisible: true,
              width: 4, // TrendChart와 동일한 크기
              height: 4, // TrendChart와 동일한 크기
            ),
          ),
      ],
    );
  }
}

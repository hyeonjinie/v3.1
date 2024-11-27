import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CurrentChart extends StatelessWidget {
  final Map<String, dynamic> currentProductionData;
  final Map<String, dynamic> commProductionData;
  final Map<String, Color> gradeColorMap;

  const CurrentChart({
    Key? key,
    required this.currentProductionData,
    required this.commProductionData,
    required this.gradeColorMap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // 첫 번째 등급의 date를 x축 값으로 설정
    final List<String> xAxisLabels = commProductionData.values.first['price'].isEmpty
        ? List<String>.from(currentProductionData.values.first['date'])
        : List<String>.from(commProductionData.values.first['date']);

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

    return Container(
      width: screenWidth,
      height: 350, 
      child: Stack(
        children: [
          SfCartesianChart(
            primaryXAxis: const CategoryAxis(
              majorGridLines: MajorGridLines(width: 0),
              labelRotation: -20, 
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
            tooltipBehavior: TooltipBehavior(enable: true),
            trackballBehavior: trackballBehavior,
            series: [
              // Current production data series
              ...currentProductionData.entries.map((entry) {
                final grade = entry.key;
                final data = entry.value;
                final List<double> prices = List<double>.from(data['price']);

                final chartData = List.generate(
                  prices.length,
                  (index) => _ChartData(xAxisLabels[index], prices[index]),
                );

                return LineSeries<_ChartData, String>(
                  name: grade,
                  dataSource: chartData,
                  xValueMapper: (_ChartData data, _) => data.x,
                  yValueMapper: (_ChartData data, _) => data.y,
                  color: gradeColorMap[grade],
                  animationDuration: 0,
                  markerSettings: const MarkerSettings(
                    isVisible: true,
                    width: 1,
                    height: 1,
                  ),
                );
              }).toList(),

              if (commProductionData.isNotEmpty)
                ...commProductionData.entries.map((entry) {
                  final grade = entry.key;
                  final data = entry.value;
                  final List<double> prices = List<double>.from(data['price']);

                  final chartData = List.generate(
                    prices.length,
                    (index) => _ChartData(xAxisLabels[index], prices[index]),
                  );

                  return LineSeries<_ChartData, String>(
                    name: grade,
                    dataSource: chartData,
                    xValueMapper: (_ChartData data, _) => data.x,
                    yValueMapper: (_ChartData data, _) => data.y,
                    color: gradeColorMap[grade],
                    animationDuration: 0,
                    markerSettings: const MarkerSettings(
                      isVisible: true,
                      width: 1,
                      height: 1,
                    ),
                    dashArray: <double>[1, 5], // 점선 스타일로 설정
                  );
                }).toList(),
            ],
          ),
          
          // '실선: 동향, 점선: 평년' 텍스트 표시
          if (commProductionData.values.first['price'].isNotEmpty)
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.white.withOpacity(0.8),
                child: const Text(
                  '실선: 동향 \n점선: 평년',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF666C77),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// x축과 y축 데이터를 저장하는 클래스
class _ChartData {
  final String x;
  final double y;

  _ChartData(this.x, this.y);
}

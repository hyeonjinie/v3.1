import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class IndexCurrentChart extends StatelessWidget {
  final Map<String, dynamic> currentProductionData;
  final Map<String, dynamic>? commProductionData; // Nullable로 변경

  const IndexCurrentChart({
    Key? key,
    required this.currentProductionData,
    this.commProductionData, // Nullable 허용
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // x축 레이블 설정 (commProductionData가 null인 경우 currentProductionData 사용)
    final List<String> xAxisLabels = commProductionData != null && commProductionData!['date'] != null
        ? List<String>.from(commProductionData!['date'])
        : List<String>.from(currentProductionData['date']);

    // 트랙볼 설정
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

    // 그래프 색상 매핑
    const indexColor = Color(0xFF0084FF);
    const ma30Color = Color(0xFFD58585);
    const ma60Color = Color(0xFF469E79);

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
              // Current production data series (solid lines)
              ..._createSeries(
                xAxisLabels,
                currentProductionData,
                isDashed: false,
                indexColor: indexColor,
                ma30Color: ma30Color,
                ma60Color: ma60Color,
              ),

              // Comm production data series (dashed lines), commProductionData가 null이 아닌 경우에만 추가
              if (commProductionData != null)
                ..._createSeries(
                  xAxisLabels,
                  commProductionData!,
                  isDashed: true,
                  indexColor: indexColor,
                  ma30Color: ma30Color,
                  ma60Color: ma60Color,
                ),
            ],
          ),

          // '실선: 동향, 점선: 평년' 텍스트 표시
          if (commProductionData != null &&
              commProductionData!['index'] != null &&
              commProductionData!['index'].isNotEmpty)
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

  List<LineSeries<_ChartData, String>> _createSeries(
    List<String> xAxisLabels,
    Map<String, dynamic> productionData, {
    required bool isDashed,
    required Color indexColor,
    required Color ma30Color,
    required Color ma60Color,
  }) {
    final List<LineSeries<_ChartData, String>> seriesList = [];

    // 데이터 키들 (index, ma30, ma60)
    final keys = ['index', 'MA30', 'MA60'];
    final colors = [indexColor, ma30Color, ma60Color];

    for (int i = 0; i < keys.length; i++) {
      final key = keys[i];
      if (productionData[key] != null) {
        final List<double> values = List<double>.from(productionData[key]);
        final chartData = List.generate(
          values.length,
          (index) => _ChartData(xAxisLabels[index], values[index]),
        );

        seriesList.add(
          LineSeries<_ChartData, String>(
            name: key.toUpperCase(), 
            dataSource: chartData,
            xValueMapper: (_ChartData data, _) => data.x,
            yValueMapper: (_ChartData data, _) => data.y,
            color: colors[i],
            dashArray: isDashed ? [1, 7] : null, 
            animationDuration: 0,
            markerSettings: const MarkerSettings(
              isVisible: false,
              width: 1,
              height: 1,
            ),
          ),
        );
      }
    }

    return seriesList;
  }
}

// x축과 y축 데이터를 저장하는 클래스
class _ChartData {
  final String x;
  final double y;

  _ChartData(this.x, this.y);
}

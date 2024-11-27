import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class IndexPredChart extends StatelessWidget {
  final Map<String, dynamic> predProductionData;

  IndexPredChart({required this.predProductionData});

  @override
  Widget build(BuildContext context) {

    // 날짜, 실제 가격, 예측 가격
    final List<String> date = List<String>.from(predProductionData['date']);
    final List<dynamic> actualIndex = List<dynamic>.from(predProductionData['act_index']);
    final List<dynamic> predictedIndex =
        List<dynamic>.from(predProductionData['pred_index']);

    // ChartData로 변환
    List<ChartData> actualData = List.generate(
      actualIndex.length,
      (index) => ChartData(date[index], actualIndex[index]),
    );

    List<ChartData> predDataList = List.generate(
      date.length,
      (index) => ChartData(date[index], predictedIndex[index]),
    );

    final TooltipBehavior tooltipBehavior = TooltipBehavior(enable: true);
    final TrackballBehavior trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
      lineType: TrackballLineType.vertical,
      tooltipSettings: const InteractiveTooltip(
        enable: true,
        color: Colors.black54,
        textStyle: TextStyle(color: Colors.white),
      ),
    );

    return Stack(
      children: [
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(
              majorGridLines: MajorGridLines(width: 0),
              labelRotation: -20,
              labelStyle: TextStyle(
                color: Color(0xFF666C77),
                fontSize: 12,
              )),
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
          legend: const Legend(
            isVisible: true,
            alignment: ChartAlignment.far,
            position: LegendPosition.top,
            toggleSeriesVisibility: true,
            overflowMode: LegendItemOverflowMode.wrap,
          ),
          tooltipBehavior: tooltipBehavior,
          trackballBehavior: trackballBehavior,
          series: <CartesianSeries<ChartData, String>>[
            LineSeries<ChartData, String>(
              dataSource: actualData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              name: '실제 가격',
              color: Color(0xFF67CEB8),
              animationDuration: 0,
              markerSettings: MarkerSettings(
                isVisible: actualData.length <= 12,
                height: 1,
                width: 1,
              ),
            ),
            LineSeries<ChartData, String>(
              dataSource: predDataList,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              name: '예측 가격',
              color: Color(0xFF4F8A97),
              dashArray: <double>[1, 5],
              animationDuration: 0,
              markerSettings: MarkerSettings(
                isVisible: predDataList.length <= 12,
                height: 1,
                width: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// 차트 데이터 클래스를 정의
class ChartData {
  final String x;
  final dynamic? y;

  ChartData(this.x, this.y);
}

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:v3_mvp/widgets/font_size_helper/font_size_helper.dart';

class PriceTrendChart extends StatelessWidget {
  final Map<String, dynamic> data;

  const PriceTrendChart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    List<ChartData> chartData = data.entries
        .map((entry) => ChartData(entry.key, entry.value?.toDouble() ?? 0.0))
        .toList();

    bool isEmpty = chartData.every((element) => element.sales == 0.0);

    return SingleChildScrollView(
      child: Center(
        child: Container(
          width: screenWidth > 1200 ? 1200 : screenWidth,
          padding: const EdgeInsets.all(8.0),
          child: isEmpty
              ? Container(
            width: double.infinity,
            height: 400,
            color: Colors.grey.withOpacity(0.3),
            child: Center(
              child: Text(
                "해당 등급의 데이터가 없습니다.\n다른 등급을 선택해주세요.",
                style: TextStyle(
                  fontSize: getFontSize(context, FontSizeType.medium),
                  color: Colors.black54,
                ),
              ),
            ),
          )
              : SfCartesianChart(
            primaryXAxis: const CategoryAxis(),
            series: <CartesianSeries>[
              LineSeries<ChartData, String>(
                dataSource: chartData,
                xValueMapper: (ChartData data, _) => data.year,
                yValueMapper: (ChartData data, _) => data.sales,
                animationDuration: 500,
              ),
            ],
            trackballBehavior: TrackballBehavior(
              enable: true,
              activationMode: ActivationMode.singleTap,
              tooltipSettings: const InteractiveTooltip(
                enable: true,
                format: 'point.x : point.y원',
                borderWidth: 2,
                borderColor: Colors.black,
                color: Colors.white,
                textStyle: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ChartData {
  final String year;
  final double sales;

  ChartData(this.year, this.sales);
}

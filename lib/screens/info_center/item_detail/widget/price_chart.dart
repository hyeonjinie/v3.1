import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

class PriceChart extends StatelessWidget {
  final Map<DateTime, double> data;

  PriceChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final chartData = getChartData();
    final allZeroData = chartData.every((element) => element.price == 0.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          buildChart(chartData), // 차트 생성 부분을 메서드로 분리
          if (allZeroData || chartData.isEmpty) // 데이터가 없거나 모두 0.0일 경우
            Positioned.fill(
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 3, sigmaY: 3), // 블러 처리
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.black.withOpacity(0.1), // 반투명 배경
                  child: const Text(
                    "해당 등급의 데이터가 없습니다.",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildChart(List<ChartData> chartData) {
    final minPrice = chartData.isNotEmpty ? chartData.map((e) => e.price).reduce(min) : 0.0;
    final maxPrice = chartData.isNotEmpty ? chartData.map((e) => e.price).reduce(max) : 0.0;
    final adjustedMinPrice = minPrice - (minPrice * 0.02);
    final adjustedMaxPrice = maxPrice + (maxPrice * 0.02);

    return SfCartesianChart(
      primaryXAxis: DateTimeAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        dateFormat: DateFormat.Md(),
        intervalType: DateTimeIntervalType.days,
        majorGridLines: const MajorGridLines(width: 0),
        labelStyle: const TextStyle(color: Colors.black, fontSize: 15),
        axisLine: const AxisLine(width: 0),
      ),
      primaryYAxis: NumericAxis(
        minimum: adjustedMinPrice,
        maximum: adjustedMaxPrice,
        labelFormat: '{value}원',
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
      ),
      plotAreaBorderWidth: 0,
      series: <CartesianSeries>[
        LineSeries<ChartData, DateTime>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.date,
          yValueMapper: (ChartData data, _) => data.price,
          animationDuration: 50,
        )
      ],
      trackballBehavior: TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
        tooltipSettings: const InteractiveTooltip(
          format: 'point.x : point.y',
          borderWidth: 2,
          borderColor: Colors.black,
          color: Colors.white,
          textStyle: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  List<ChartData> getChartData() {
    if (data.isEmpty) {
      return [];
    }

    final sortedEntries = data.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    final firstDate = sortedEntries.first.key;
    final interval = calculateInterval(sortedEntries.length);

    return sortedEntries
        .where((entry) => entry.key.difference(firstDate).inDays % interval == 0)
        .map((entry) => ChartData(entry.key, entry.value))
        .toList();
  }

  int calculateInterval(int length) {
    if (length >= 365) return 7;
    if (length >= 180) return 3;
    if (length >= 90) return 2;
    return 1;
  }
}

class ChartData {
  final DateTime date;
  final double price;

  ChartData(this.date, this.price);
}





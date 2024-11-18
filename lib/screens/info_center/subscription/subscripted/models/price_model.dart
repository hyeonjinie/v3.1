class PriceData {
  final Map<String, Map<String, YearData>> actual;
  final Map<String, Map<String, YearData>> predict;
  final Map<String, ActAnalysis> actAnalysis;

  PriceData({
    required this.actual,
    required this.predict,
    required this.actAnalysis,
  });

  // fromJson 메서드 수정
  static Future<PriceData> fromJson(Map<String, dynamic> cropData) async {
    try {
      if (cropData.isEmpty) {
        throw Exception("No data found in cropData");
      }

      final actualData = cropData['actual'];
      final predictData = cropData['predict'];
      final actAnalysisData = cropData['act_analysis'];

      if (actualData == null || predictData == null || actAnalysisData == null) {
        throw Exception("Missing required data keys in cropData");
      }

      return PriceData(
        actual: Map<String, Map<String, YearData>>.from(
          actualData.map((key, value) => MapEntry(key, YearData.fromMap(value))),
        ),
        predict: Map<String, Map<String, YearData>>.from(
          predictData.map((key, value) => MapEntry(key, YearData.fromMap(value))),
        ),
        actAnalysis: Map<String, ActAnalysis>.from(
          actAnalysisData.map((key, value) => MapEntry(key, ActAnalysis.fromMap(value))),
        ),
      );
    } catch (e) {
      throw Exception("Failed to parse cropData: $e");
    }
  }
}


class YearData {
  final Map<String, PriceDetails> yearDetails;

  YearData({
    required this.yearDetails,
  });

  factory YearData.fromMap(Map<String, dynamic> map) {
    return YearData(
      yearDetails: Map<String, PriceDetails>.from(
        map.map((key, value) => MapEntry(key, PriceDetails.fromMap(value))),
      ),
    );
  }
}

class PriceDetails {
  final List<double?> price;
  final List<int> date;

  PriceDetails({
    required this.price,
    required this.date,
  });

  factory PriceDetails.fromMap(Map<String, dynamic> map) {
    return PriceDetails(
      price: List<double?>.from(
        map['price'].map((x) => x == null ? 0.0 : x.toDouble()),
      ),
      date: List<int>.from(map['date']),
    );
  }
}

class ActAnalysis {
  final String date;
  final double thisValue;
  final double rateComparedLastValue;
  final double valueComparedLastYear;
  final double diffComparedLastValueYear;
  final double rateComparedLastYear;
  final double valueComparedCommon3Years;
  final double diffValueComparedCommon3Years;
  final double rateComparedCommon3Years;
  final double yearAverageValue;
  final double yearChangeValue;
  final double seasonalIndex;
  final double supplyStabilityIndex;
  final String currencyUnit;

  ActAnalysis({
    required this.date,
    required this.thisValue,
    required this.rateComparedLastValue,
    required this.valueComparedLastYear,
    required this.diffComparedLastValueYear,
    required this.rateComparedLastYear,
    required this.valueComparedCommon3Years,
    required this.diffValueComparedCommon3Years,
    required this.rateComparedCommon3Years,
    required this.yearAverageValue,
    required this.yearChangeValue,
    required this.seasonalIndex,
    required this.supplyStabilityIndex,
    required this.currencyUnit,
  });

  factory ActAnalysis.fromMap(Map<String, dynamic> map) {
    return ActAnalysis(
      date: map['date'] ?? '',
      thisValue: map['this_value'] ?? 0.0,
      rateComparedLastValue: map['rate_compared_last_value'] ?? 0.0,
      valueComparedLastYear: map['value_compared_last_year'] ?? 0.0,
      diffComparedLastValueYear: map['diff_compared_last_value_year'] ?? 0.0,
      rateComparedLastYear: map['rate_compared_last_year'] ?? 0.0,
      valueComparedCommon3Years: map['value_compared_common_3years'] ?? 0.0,
      diffValueComparedCommon3Years: map['diff_value_compared_common_3years'] ?? 0.0,
      rateComparedCommon3Years: map['rate_compared_common_3years'] ?? 0.0,
      yearAverageValue: map['year_average_value'] ?? 0.0,
      yearChangeValue: map['year_change_value'] ?? 0.0,
      seasonalIndex: map['seasonal_index'] ?? 0.0,
      supplyStabilityIndex: map['supply_stability_index'] ?? 0.0,
      currencyUnit: map['currency_unit'] ?? '￦',
    );
  }
}

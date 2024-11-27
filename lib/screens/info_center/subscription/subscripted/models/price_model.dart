class CropData {
  final ActualData actual;
  final PredictData predict;

  CropData({required this.actual, required this.predict});

  factory CropData.fromJson(Map<String, dynamic> json) {
    return CropData(
      actual: ActualData.fromJson(json['actual'] ?? {}),
      predict: PredictData.fromJson(json['predict'] ?? {}),
    );
  }
}

class ActualData {
  final Map<String, YearData> years;
  final Map<String, CommonData> commYears;
  final Map<String, List<double?>> seasonal;
  final ActAnalysis? actAnalysis;

  ActualData(
      {required this.years,
      required this.commYears,
      required this.seasonal,
      this.actAnalysis});

  factory ActualData.fromJson(Map<String, dynamic> json) {
    return ActualData(
      years: Map.fromEntries(
        json.entries
            .where((entry) =>
                entry.key != 'act_analysis' &&
                entry.key != '평년' &&
                entry.key != 'daily_seasonal_index')
            .map(
                (entry) => MapEntry(entry.key, YearData.fromJson(entry.value))),
      ),
      commYears: Map.fromEntries(
        json.entries.where((entry) => entry.key == '평년').map(
            (entry) => MapEntry(entry.key, CommonData.fromJson(entry.value))),
      ),
      seasonal: (json['daily_seasonal_index'] as Map<String, dynamic>? ?? {})
          .map((key, value) => MapEntry(
                key,
                (value as List<dynamic>)
                    .map((item) => (item as num).toDouble())
                    .toList(),
              )),
      actAnalysis: json['act_analysis'] != null
          ? ActAnalysis.fromJson(json['act_analysis'])
          : null,
    );
  }
}

class CommonData {
  final Map<String, YearData> commyears;

  CommonData({required this.commyears});

  factory CommonData.fromJson(Map<String, dynamic> json) {
    return CommonData(
      commyears: Map.fromEntries(
        json.entries.map(
            (entry) => MapEntry(entry.key, YearData.fromJson(entry.value))),
      ),
    );
  }
}

class YearData {
  final Map<String, GradeData> grades;

  YearData({required this.grades});

  factory YearData.fromJson(Map<String, dynamic> json) {
    return YearData(
      grades: Map.fromEntries(
        json.entries.map(
            (entry) => MapEntry(entry.key, GradeData.fromJson(entry.value))),
      ),
    );
  }
}

class GradeData {
  final List<double?> price;
  final List<String?> date;

  GradeData({required this.price, required this.date});

  factory GradeData.fromJson(Map<String, dynamic> json) {
    return GradeData(
      price: (json['price'] as List<dynamic>? ?? [])
          .map((item) => item != null ? (item as num).toDouble() : null)
          .toList(),
      date: (json['date'] as List<dynamic>? ?? [])
          .map((item) => item != null ? item as String : null)
          .toList(),
    );
  }
}

class ActAnalysis {
  final String date;
  final double? thisValue;
  final double? rateComparedLastValue;
  final double? valueComparedYesterday;
  final double? lastYearValue;
  final double? diffComparedLastValueYear;
  final double? rateComparedLastYear;
  final double? valueComparedCommon3Years;
  final double? diffValueComparedCommon3Years;
  final double? rateComparedCommon3Years;
  final double? yearAverageValue;
  final double? yearChangeValue;
  final double? seasonalIndex;
  final double? supplyStabilityIndex;
  final String currencyUnit;
  final String weightUnit;

  ActAnalysis({
    required this.date,
    this.thisValue,
    this.rateComparedLastValue,
    this.valueComparedYesterday,
    this.lastYearValue,
    this.diffComparedLastValueYear,
    this.rateComparedLastYear,
    this.valueComparedCommon3Years,
    this.diffValueComparedCommon3Years,
    this.rateComparedCommon3Years,
    this.yearAverageValue,
    this.yearChangeValue,
    this.seasonalIndex,
    this.supplyStabilityIndex,
    required this.currencyUnit,
    required this.weightUnit,
  });

  factory ActAnalysis.fromJson(Map<String, dynamic> json) {
    return ActAnalysis(
      date: json['date'] ?? '',
      thisValue: json['this_value']?.toDouble(),
      rateComparedLastValue: json['rate_compared_last_value']?.toDouble(),
      valueComparedYesterday: json['value_compared_yesterday']?.toDouble(),
      lastYearValue: json['last_year_value']?.toDouble(),
      diffComparedLastValueYear:
          json['diff_compared_last_value_year']?.toDouble(),
      rateComparedLastYear: json['rate_compared_last_year']?.toDouble(),
      valueComparedCommon3Years:
          json['value_compared_common_3years']?.toDouble(),
      diffValueComparedCommon3Years:
          json['diff_value_compared_common_3years']?.toDouble(),
      rateComparedCommon3Years: json['rate_compared_common_3years']?.toDouble(),
      yearAverageValue: json['year_average_value']?.toDouble(),
      yearChangeValue: json['year_change_value']?.toDouble(),
      seasonalIndex: json['seasonal_index']?.toDouble(),
      supplyStabilityIndex: json['supply_stability_index']?.toDouble(),
      currencyUnit: json['currency_unit'] ?? '',
      weightUnit: json['weight_unit'] ?? '',
    );
  }
}

class PredictData {
  final Map<String, PredYearData> years;
  final Map<String, List<double?>> predSeasonal;
  final PredAnalysis? predAnalysis;

  PredictData(
      {required this.years, required this.predSeasonal, this.predAnalysis});

  factory PredictData.fromJson(Map<String, dynamic> json) {
    return PredictData(
      years: Map.fromEntries(
        json.entries
            .where((entry) =>
                entry.key != 'pred_analysis' &&
                entry.key != 'pred_seasonal_index')
            .map((entry) =>
                MapEntry(entry.key, PredYearData.fromJson(entry.value))),
      ),
      predSeasonal: (json['pred_seasonal_index'] as Map<String, dynamic>? ?? {})
          .map((key, value) => MapEntry(
                key,
                (value as List<dynamic>)
                    .map((item) => (item as num).toDouble())
                    .toList(),
              )),
      predAnalysis: json['pred_analysis'] != null
          ? PredAnalysis.fromJson(json['pred_analysis'])
          : null,
    );
  }
}

class PredYearData {
  final Map<String, PredGradeData> grades;

  PredYearData({required this.grades});

  factory PredYearData.fromJson(Map<String, dynamic> json) {
    return PredYearData(
      grades: Map.fromEntries(
        json.entries.map((entry) =>
            MapEntry(entry.key, PredGradeData.fromJson(entry.value))),
      ),
    );
  }
}

class PredGradeData {
  final List<double?> actPrice;
  final List<double?> predPrice;
  final List<double?> predHPrice;
  final List<double?> predLPrice;
  final List<String?> date;

  PredGradeData({
    required this.actPrice,
    required this.predPrice,
    required this.predHPrice,
    required this.predLPrice,
    required this.date,
  });

  factory PredGradeData.fromJson(Map<String, dynamic> json) {
    return PredGradeData(
      actPrice: (json['act_price'] as List<dynamic>? ?? [])
          .map((item) => item != null ? (item as num).toDouble() : null)
          .toList(),
      predPrice: (json['pred_price'] as List<dynamic>? ?? [])
          .map((item) => item != null ? (item as num).toDouble() : null)
          .toList(),
      predHPrice: (json['pred_h_price'] as List<dynamic>? ?? [])
          .map((item) => item != null ? (item as num).toDouble() : null)
          .toList(),
      predLPrice: (json['pred_l_price'] as List<dynamic>? ?? [])
          .map((item) => item != null ? (item as num).toDouble() : null)
          .toList(),
      date: (json['date'] as List<dynamic>? ?? [])
          .map((item) => item != null ? item as String : null)
          .toList(),
    );
  }
}

class PredAnalysis {
  final String date;
  final double? predictedPrice;
  final double? rateComparedLastValue;
  final List<dynamic>? range;
  final double? outOfRangeProbability;
  final double? stabilitySectionProbability;
  final double? consistencyIndex;
  final double? seasonallyAdjustedPrice;
  final double? signalIndex;
  final String currencyUnit;
  final String weightUnit;

  PredAnalysis({
    required this.date,
    this.predictedPrice,
    this.rateComparedLastValue,
    this.range,
    this.outOfRangeProbability,
    this.stabilitySectionProbability,
    this.consistencyIndex,
    this.seasonallyAdjustedPrice,
    this.signalIndex,
    required this.currencyUnit,
    required this.weightUnit,
  });

  factory PredAnalysis.fromJson(Map<String, dynamic> json) {
    return PredAnalysis(
      date: json['date'] ?? '',
      predictedPrice: json['predicted_price']?.toDouble(),
      rateComparedLastValue: json['rate_compared_last_value']?.toDouble(),
      range: json['range'] ?? [],
      outOfRangeProbability: json['out_of_range_probability']?.toDouble(),
      stabilitySectionProbability:
          json['stability_section_probability']?.toDouble(),
      consistencyIndex: json['consistency_index']?.toDouble(),
      seasonallyAdjustedPrice: json['seasonally_adjusted_price']?.toDouble(),
      signalIndex: json['signal_index']?.toDouble(),
      currencyUnit: json['currency_unit'] ?? '',
      weightUnit: json['weight_unit'] ?? '',
    );
  }
}

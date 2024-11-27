class ProdData {
  final ActualIndexData actual;
  final PredictData predict;

  ProdData({
    required this.actual,
    required this.predict,
  });

  factory ProdData.fromJson(Map<String, dynamic> json) {
    return ProdData(
      actual: ActualIndexData.fromJson(json['actual'] ?? {}),
      predict: PredictData.fromJson(json['predict'] ?? {}),
    );
  }
}

class ActualIndexData {
  final Map<String, YearIndexData> years;
  final Map<String, CommonIndexData> commYears;
  final IndexActAnalysis? actAnalysis;

  ActualIndexData(
      {required this.years, required this.commYears, this.actAnalysis});

  factory ActualIndexData.fromJson(Map<String, dynamic> json) {
    return ActualIndexData(
      years: Map.fromEntries(
        json.entries
            .where((entry) => entry.key != 'act_analysis' && entry.key != '평년')
            .map((entry) =>
                MapEntry(entry.key, YearIndexData.fromJson(entry.value))),
      ),
      commYears: Map.fromEntries(
        json.entries.where((entry) => entry.key == '평년').map((entry) =>
            MapEntry(entry.key, CommonIndexData.fromJson(entry.value))),
      ),
      actAnalysis: json['act_analysis'] != null
          ? IndexActAnalysis.fromJson(json['act_analysis'])
          : null,
    );
  }
}

class CommonIndexData {
  final Map<String, YearIndexData> commyears;

  CommonIndexData({required this.commyears});

  factory CommonIndexData.fromJson(Map<String, dynamic> json) {
    return CommonIndexData(
      commyears: Map.fromEntries(
        json.entries.map((entry) =>
            MapEntry(entry.key, YearIndexData.fromJson(entry.value))),
      ),
    );
  }
}

class YearIndexData {
  final List<double?> index;
  final List<double?> ma30;
  final List<double?> ma60;
  final List<String?> date;

  YearIndexData({
    required this.index,
    required this.ma30,
    required this.ma60,
    required this.date,
  });

  factory YearIndexData.fromJson(Map<String, dynamic> json) {
    return YearIndexData(
      index: (json['index'] as List<dynamic>? ?? [])
          .map((item) => item != null ? (item as num).toDouble() : null)
          .toList(),
      ma30: (json['ma30'] as List<dynamic>? ?? [])
          .map((item) => item != null ? (item as num).toDouble() : null)
          .toList(),
      ma60: (json['ma60'] as List<dynamic>? ?? [])
          .map((item) => item != null ? (item as num).toDouble() : null)
          .toList(),
      date: (json['date'] as List<dynamic>? ?? [])
          .map((item) => item != null ? item as String : null)
          .toList(),
    );
  }
}

class IndexActAnalysis {
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
  final double rateStability;
  final double correlationCoefficient;
  final double sensitivity;

  IndexActAnalysis({
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
    required this.rateStability,
    required this.correlationCoefficient,
    required this.sensitivity,
  });

  factory IndexActAnalysis.fromJson(Map<String, dynamic> json) {
    return IndexActAnalysis(
      date: json['date'] ?? '',
      thisValue: json['this_value']?.toDouble() ?? 0.0,
      rateComparedLastValue:
          json['rate_compared_last_value']?.toDouble() ?? 0.0,
      valueComparedLastYear:
          json['value_compared_last_year']?.toDouble() ?? 0.0,
      diffComparedLastValueYear:
          json['diff_compared_last_value_year']?.toDouble() ?? 0.0,
      rateComparedLastYear: json['rate_compared_last_year']?.toDouble() ?? 0.0,
      valueComparedCommon3Years:
          json['value_compared_common_3years']?.toDouble() ?? 0.0,
      diffValueComparedCommon3Years:
          json['diff_value_compared_common_3years']?.toDouble() ?? 0.0,
      rateComparedCommon3Years:
          json['rate_compared_common_3years']?.toDouble() ?? 0.0,
      yearAverageValue: json['year_average_value']?.toDouble() ?? 0.0,
      rateStability: json['rate_stability']?.toDouble() ?? 0.0,
      correlationCoefficient:
          json['correlation_coefficient']?.toDouble() ?? 0.0,
      sensitivity: json['sensitivity']?.toDouble() ?? 0.0,
    );
  }
}

class PredictData {
  final Map<String, PredYearData> years;
  final PredAnalysis? predAnalysis;

  PredictData(
      {required this.years, this.predAnalysis});

  factory PredictData.fromJson(Map<String, dynamic> json) {
    return PredictData(
      years: Map.fromEntries(
        json.entries
            .where((entry) =>
                entry.key != 'pred_analysis')
            .map((entry) =>
                MapEntry(entry.key, PredYearData.fromJson(entry.value))),
      ),
      predAnalysis: json['pred_analysis'] != null
          ? PredAnalysis.fromJson(json['pred_analysis'])
          : null,
    );
  }
}

class PredYearData {
  final List<double?> index;
  final List<String?> date;

  PredYearData({
    required this.index,
    required this.date,
  });

  factory PredYearData.fromJson(Map<String, dynamic> json) {
    return PredYearData(
      index: (json['index'] as List<dynamic>? ?? [])
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
  final double predictedIndex;
  final double rateComparedLastValue;
  final List<double> range;
  final double outOfRangeProbability;
  final double stabilitySectionProbability;
  final double consistencyIndex;
  final double resilienceIndex;
  final double signalIndex;

  PredAnalysis({
    required this.date,
    required this.predictedIndex,
    required this.rateComparedLastValue,
    required this.range,
    required this.outOfRangeProbability,
    required this.stabilitySectionProbability,
    required this.consistencyIndex,
    required this.resilienceIndex,
    required this.signalIndex,
  });

  factory PredAnalysis.fromJson(Map<String, dynamic> json) {
    return PredAnalysis(
      date: json['date'],
      predictedIndex: (json['predicted_index'] as num).toDouble(),
      rateComparedLastValue: (json['rate_compared_last_value'] as num).toDouble(),
      range: List<double>.from(json['range']),
      outOfRangeProbability: (json['out_of_range_probability'] as num).toDouble(),
      stabilitySectionProbability:
          (json['stability_section_probability'] as num).toDouble(),
      consistencyIndex: (json['consistency_index'] as num).toDouble(),
      resilienceIndex: (json['resilience_index'] as num).toDouble(),
      signalIndex: (json['signal_index'] as num).toDouble(),
    );
  }
}
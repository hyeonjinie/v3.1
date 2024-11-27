class ProdData {
  final ActualIndexData actual;
  // final PredictData predict;

  ProdData({
    required this.actual,
    // required this.predict,
  });

  factory ProdData.fromJson(Map<String, dynamic> json) {
    return ProdData(
      actual: ActualIndexData.fromJson(json['actual'] ?? {}),
      // predict: PredictData.fromJson(json['predict'] ?? {}),
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
  final Map<String, List<double?>> predSeasonal;

  PredictData(
      {required this.predSeasonal});

  factory PredictData.fromJson(Map<String, dynamic> json) {
    return PredictData(
      
      predSeasonal: (json['pred_seasonal_index'] as Map<String, dynamic>? ?? {})
          .map((key, value) => MapEntry(
                key,
                (value as List<dynamic>)
                    .map((item) => (item as num).toDouble())
                    .toList(),
              )),
      
    );
  }
}
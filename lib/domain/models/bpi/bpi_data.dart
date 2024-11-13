class BpiData {
  final DateTime date;
  final double value;

  BpiData(this.date, this.value);

  factory BpiData.fromJson(Map<String, dynamic> json) {
    return BpiData(
      DateTime.parse(json['date']),
      json['value'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'value': value,
    };
  }
}

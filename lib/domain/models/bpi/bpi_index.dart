
import 'bpi_data.dart';

class BpiIndex {
  final String indexName;
  final List<BpiData> data;

  BpiIndex({required this.indexName, required this.data});

  factory BpiIndex.fromJson(Map<String, dynamic> json) {
    List<BpiData> dataList = (json['data'] as Map<String, dynamic>).entries.map((entry) {
      return BpiData(DateTime.parse(entry.key), entry.value.toDouble());
    }).toList();
    return BpiIndex(indexName: json['indexName'] as String, data: dataList);
  }

  Map<String, dynamic> toJson() {
    final dataMap = {for (var item in data) item.date.toIso8601String(): item.value};
    return {
      'indexName': indexName,
      'data': dataMap,
    };
  }
}

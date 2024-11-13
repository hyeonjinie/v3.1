import 'dart:math';

Map<String, Map<DateTime, double>> generateMappedData() {
  final categories = ['특', '상', '중', '하'];
  final Map<String, Map<DateTime, double>> dataMap = {};
  final Random random = Random();
  final now = DateTime.now();

  for (var category in categories) {
    Map<DateTime, double> datePriceMap = {};
    for (int i = 0; i < 365; i++) {
      final date = now.subtract(Duration(days: i));
      final basePrice = category == '특' ? 9000 : category == '상' ? 7000 : category == '중' ? 5000 : 4000;
      double fluctuation = random.nextDouble() * 2000 - 1000;  // Random fluctuation between -1000 and +1000
      double price = basePrice + fluctuation;
      datePriceMap[date] = price;
    }
    dataMap[category] = datePriceMap;
  }
  return dataMap;
}



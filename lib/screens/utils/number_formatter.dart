import 'package:intl/intl.dart';

class NumberFormatter {
  static String formatNumber(double number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }
}

String formatCurrency(dynamic value) {
  final formatterWithDecimals = NumberFormat('#,##0.##'); 
  final formatterWithoutDecimals = NumberFormat('#,###'); 
  
  if (value is String && value == '-') {
    return value; // '-' 그대로 반환
  } else if (value is num) {
    if (value % 1 == 0) {
      return formatterWithoutDecimals.format(value); // 정수로 표시
    } else {
      return formatterWithDecimals.format(value); // 소수 포함하여 표시
    }
  }
  return value.toString(); // 기본 문자열로 변환
}
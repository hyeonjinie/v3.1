import 'package:intl/intl.dart';

class NumberFormatter {
  static String formatNumber(double number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }
}
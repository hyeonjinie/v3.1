import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DurationDatePicker {
  static Future<Map<String, String?>?> selectDateRange(
      BuildContext context) async {
    // Pick the start date
    final DateTime? startDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: '시작 날짜 선택',
      locale: const Locale('ko', 'KR'),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.green,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.green,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (startDate == null) return null;
    final DateTime? endDate = await showDatePicker(
      initialDate: startDate.add(const Duration(days: 1)),
      context: context,
      firstDate: startDate,
      lastDate: DateTime(2100),
      helpText: '종료 날짜 선택',
      locale: const Locale('ko', 'KR'),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.green,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.green,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (endDate == null) return null;

    return {
      "start": DateFormat('yyyy.MM.dd', 'ko_KR').format(startDate),
      "end": DateFormat('yyyy.MM.dd', 'ko_KR').format(endDate),
    };
  }
}

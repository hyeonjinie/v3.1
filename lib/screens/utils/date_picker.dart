import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker {
  static Future<String?> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: '',
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
      locale: const Locale('ko', 'KR'),
    );

    if (picked != null) {
      return DateFormat('yyyy.MM.dd', 'ko_KR').format(picked);
    }
    return null;
  }
}

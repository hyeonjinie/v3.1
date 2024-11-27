import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PredTableWidget extends StatelessWidget {
  final Map<String, dynamic> predTableData;

  const PredTableWidget({Key? key, required this.predTableData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: predTableData.keys.map((grade) {
          final gradeData = predTableData[grade] as Map<String, dynamic>?;

          if (gradeData == null) {
            return SizedBox.shrink();
          }

          final predPrice = (gradeData["pred_price"] as List?)?.cast<num?>() ?? [];
          final predHPrice = (gradeData["pred_h_price"] as List?)?.cast<num?>() ?? [];
          final predLPrice = (gradeData["pred_l_price"] as List?)?.cast<num?>() ?? [];

          // 테이블 위젯 생성
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\'$grade\' 등급',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Table(
                border: TableBorder.all(color: Color(0xFFDDE1E6)),
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                  3: FlexColumnWidth(1),
                },
                children: [
                  // 테이블 헤더
                  TableRow(
                    decoration: BoxDecoration(color: Color(0xFFF8F8F8)),
                    children: [
                      _buildTableCell('날짜', isHeader: true),
                      _buildTableCell('고가', isHeader: true),
                      _buildTableCell('평균가', isHeader: true),
                      _buildTableCell('저가', isHeader: true),
                    ],
                  ),
                  // 테이블 행 데이터
                  for (int i = 0; i < predPrice.length; i++)
                    TableRow(
                      children: [
                        _buildTableCell('D + ${i + 1}'),
                        _buildTableCell(_formatValue(predHPrice[i])),
                        _buildTableCell(_formatValue(predPrice[i])),
                        _buildTableCell(_formatValue(predLPrice[i])),
                      ],
                    ),
                ],
              ),
              SizedBox(height: 16),
            ],
          );
        }).toList(),
      ),
    );
  }

  // 테이블 셀 빌드 메서드
  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  // 값 포맷팅 메서드 (천 단위 콤마 추가)
  String _formatValue(num? value) {
    if (value == null) return '-';
    final formatter = NumberFormat("#,##0.##"); // 천 단위 콤마 및 소수점 두 자리까지 처리
    return formatter.format(value);
  }
}

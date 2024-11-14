import 'package:flutter/material.dart';
import 'package:v3_mvp/screens/info_center/subscription/widget/tooltip.dart';

class PriceTableWidget extends StatelessWidget {
  final List<List<String>> dataRows; // Dynamic data rows

  PriceTableWidget({
    required this.dataRows,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleRow(dataRows[0]),
          _buildDataGrid(context),
        ],
      ),
    );
  }

  Widget _buildTitleRow(List<String> titleData) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF8F8F8),
        border: Border(
          top: BorderSide(color: Color(0xFFDDE1E6), width: 1),
          bottom: BorderSide(color: Color(0xFFDDE1E6), width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                titleData[0],
                style: TextStyle(fontSize: 14),
              ),
              Spacer(),
              Text(
                titleData[1],
                style: TextStyle(fontSize: 25),
              ),
              Text(
                titleData[2],
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                titleData[3],
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                titleData[4],
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 데이터를 2행 3열의 그리드로 보여주는 함수
  Widget _buildDataGrid(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      children: [
        for (int i = 1; i < dataRows.length; i++)
          _buildDataCell(context, dataRows[i][0], dataRows[i][1],
              dataRows[i].length > 2 ? dataRows[i][2] : '')
      ],
    );
  }

  // 데이터를 포함하는 셀을 구성하는 함수
  Widget _buildDataCell(BuildContext context, String title, String value,
      String? additionalValue) {
    return Container(
      width: (MediaQuery.of(context).size.width - 32) / 3,
      height: 85,
      // padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFDDE1E6), width: 1),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: TextStyle(fontSize: 14)),
              if (title == '계절 지수')
                TooltipWidget(
                    message:
                        '1보다 크면 현재 가격이 연평균보다 높음.\n1보다 작으면 현재 가격이 연평균보다 낮음'),
              if (title == '공급 안정성 지수')
                TooltipWidget(message: '10 이상: 매우 안정\n5 ~ 10: 보통\n5 미만: 불안정'),
              if (title == '일관성 지수')
                TooltipWidget(
                    message:
                        '0.9 이상: 일관된 예측\n0.75 ~ 0.90: 약간의 변동성\n0.75 미만: 변동폭이 클 수 있음'),
              if (title == '계절 보정가') TooltipWidget(message: '계절 지수를 반영한 보정가'),
              if (title == '신호 지수')
                TooltipWidget(
                    message:
                        '1.5 이상: 강한 상승 신호\n-1.5 ~ 1.5: 신호 없음\n-1.5 미만: 강한 하락 신호'),
            ],
          ),

          const SizedBox(height: 4),
          // 두 번째 값이 상하 기준으로 중앙 정렬되도록 수정
          if (additionalValue == null || additionalValue.isEmpty)
            Container(
              height: 40, // 중앙 정렬을 위해 빈 공간을 확보
              alignment: Alignment.center,
              child: Text(
                value,
                style: value.length > 10
                    ? TextStyle(fontSize: 16)
                    : TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            )
          else
            Text(value,
                style: value.length > 10
                    ? TextStyle(fontSize: 16)
                    : TextStyle(fontSize: 16)),
          if (additionalValue != null && additionalValue.isNotEmpty) ...[
            const SizedBox(height: 1), // 줄 간격을 줄이기 위해 크기 조정
            Text(
              additionalValue,
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                fontSize: 10,
                color: additionalValue.startsWith('▲')
                    ? const Color(0xFFEB5C5C)
                    : additionalValue.startsWith('▼')
                        ? const Color(0xFF2478C7)
                        : Colors.black,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

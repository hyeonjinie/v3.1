import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:v3_mvp/widgets/font_size_helper/font_size_helper.dart';
import '../../../utils/number_formatter.dart';

class NoDataWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.warning, size: 50, color: Colors.grey),
          Text(
            "데이터가 없습니다.",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            "다른 등급을 클릭해 보세요.",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class MarketPricesList extends StatefulWidget {
  final double averagePrice;
  final double maxPrice;
  final double minPrice;
  final Map<DateTime, double> currentData;

  MarketPricesList({
    required this.averagePrice,
    required this.maxPrice,
    required this.minPrice,
    required this.currentData,
  });

  @override
  _MarketPricesListState createState() => _MarketPricesListState();
}

class _MarketPricesListState extends State<MarketPricesList> {
  bool isWeb = kIsWeb;
  // final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    bool allDataZero = widget.currentData.values.every((v) => v == 0.0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('시세정보',
              style: TextStyle(fontSize: isWeb ? 24 : 20, fontWeight: FontWeight.bold)
          ),
          Container(
            decoration: BoxDecoration(
            ),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: _buildStatBox(
                        '1년 평균',
                        '${NumberFormatter.formatNumber(widget.averagePrice)}원',
                        screenHeight * 0.4 / 3,
                        context,
                      ),
                    ),
                    Expanded(
                      child: _buildStatBox(
                        '1년 최고',
                        '${NumberFormatter.formatNumber(widget.maxPrice)}원',
                        screenHeight * 0.4 / 3,
                        context,
                      ),
                    ),
                    Expanded(
                      child: _buildStatBox(
                        '1년 최저',
                        '${NumberFormatter.formatNumber(widget.minPrice)}원',
                        screenHeight * 0.4 / 3,
                        context,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Color(0xFFF6F6F6)
            ),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: allDataZero ? NoDataWidget() : Center(child: buildDataTable()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDataTable() {
    // 화면 너비와 높이에 비례하여 폰트 크기 계산, 최대 폰트 크기를 24로 제한
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double fontSize = screenHeight * 0.015;
    fontSize = fontSize > 24 ? 24 : fontSize;
    double maxTableWidth = screenWidth > 1200 ? 1200 : screenWidth;

    // 데이터를 내림차순으로 정렬하고 마지막 항목을 제거
    var sortedEntries = widget.currentData.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));
    sortedEntries.removeLast();

    return SizedBox(
      width: screenWidth, // 화면 너비에 맞게 설정
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: SizedBox(
            width: maxTableWidth, // 최대 너비를 1200으로 제한
            child: DataTable(
              columnSpacing: 20, // 열 간격 조정
              columns: [
                DataColumn(
                  label: SizedBox(
                    width: maxTableWidth * 0.3, // 각 열 너비를 화면 너비의 일정 비율로 설정
                    child: Text(
                      '날짜',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: getFontSize(context, FontSizeType.medium), overflow: TextOverflow.ellipsis),
                      overflow: TextOverflow.ellipsis, // 텍스트가 넘칠 경우 생략 부호 추가
                    ),
                  ),
                ),
                DataColumn(
                  label: SizedBox(
                    width: maxTableWidth * 0.2,
                    child: Text(
                      '가격',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: getFontSize(context, FontSizeType.medium), overflow: TextOverflow.ellipsis),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataColumn(
                  label: SizedBox(
                    width: maxTableWidth * 0.2,
                    child: Text(
                      '변동률',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: getFontSize(context, FontSizeType.medium), overflow: TextOverflow.ellipsis),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
              rows: List<DataRow>.generate(sortedEntries.length, (index) {
                DateTime date = sortedEntries[index].key;
                double price = sortedEntries[index].value;
                double? changeRate;
                if (index < sortedEntries.length - 1) {
                  double previousPrice = sortedEntries[index + 1].value;
                  changeRate = ((price - previousPrice) / previousPrice) * 100;
                }

                return DataRow(
                  cells: [
                    DataCell(SizedBox(
                      width: maxTableWidth * 0.2,
                      child: Text(DateFormat('yyyy.MM.dd').format(date), style: TextStyle(fontSize: getFontSize(context, FontSizeType.medium)), overflow: TextOverflow.ellipsis),
                    )),
                    DataCell(SizedBox(
                      width: maxTableWidth * 0.2,
                      child: Text('${NumberFormatter.formatNumber(price)}원', style: TextStyle(fontSize: getFontSize(context, FontSizeType.medium)), overflow: TextOverflow.ellipsis),
                    )),
                    DataCell(SizedBox(
                      width: maxTableWidth * 0.2,
                      child: changeRate != null
                          ? Row(
                        children: [
                          CustomPaint(
                            size: Size(10, 10),
                            painter: TrianglePainter(
                              isUp: changeRate > 0,
                              color: changeRate > 0 ? Color(0xFFFF5F5F) : Color(0xFF7982BD),
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${changeRate.toStringAsFixed(2)}%',
                            style: TextStyle(
                              fontSize: getFontSize(context, FontSizeType.large),
                              color: changeRate > 0 ? Color(0xFFFF5F5F) : Color(0xFF7982BD),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      )
                          : Container(), // 변동률이 없는 마지막 항목은 빈 컨테이너로 대체
                    )),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }



  Widget _buildStatBox(String title, String value, double height, BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double fontSize = screenHeight * 0.02; // 화면 높이에 비례하여 폰트 크기 계산
    fontSize = fontSize > 24 ? 24 : fontSize; // 최대 폰트 크기를 24로 제한

    return Container(
      height: height,
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Color(0xFFF5F8FF),
        border: Border.all(color: Color(0xFFDEE6FF)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: fontSize, color: Colors.black),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final bool isUp;
  final Color color;

  TrianglePainter({required this.isUp, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    var path = Path();
    if (isUp) {
      path.moveTo(size.width / 2, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(size.width / 2, size.height);
      path.lineTo(0, 0);
      path.lineTo(size.width, 0);
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

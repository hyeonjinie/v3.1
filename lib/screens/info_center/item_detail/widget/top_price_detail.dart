import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v3_mvp/screens/utils/number_formatter.dart';
import 'package:v3_mvp/widgets/font_size_helper/font_size_helper.dart';

import '../../../../../../domain/models/item.dart';

class TopPriceDetail extends StatelessWidget {
  final nowPrice;
  final nowChange;
  final nowChangePercent;
  final Item item;
  final double? errorValue;

  TopPriceDetail({
    required this.item,
    required this.nowPrice,
    required this.nowChange,
    required this.nowChangePercent,
    this.errorValue,
  });

  @override
  Widget build(BuildContext context) {
    Color valueColor = nowChange > 0 ? const Color(0xFFFF7070) : Color(0xFF7982BD);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name,
                      style: TextStyle(fontSize: getFontSize(context, FontSizeType.extraLarge), fontWeight: FontWeight.bold)),
                  Text('${NumberFormatter.formatNumber(nowPrice)}원',
                      style: TextStyle(fontSize: getFontSize(context, FontSizeType.extraLarge), fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Text('${NumberFormatter.formatNumber(nowChange)}원', style: TextStyle(fontSize: getFontSize(context, FontSizeType.medium), color: valueColor)),
                      SizedBox(width: 10),
                      Text(('${NumberFormatter.formatNumber(nowChangePercent)}%'),
                          style: TextStyle(fontSize: getFontSize(context, FontSizeType.medium), color: valueColor)),
                    ],
                  ),
                ],
              ),

              if (errorValue != null) ...[
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: errorValue! > 0 ? Color(0xFFFF7070) : Color(0xFF7982BD),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.trending_up, color: Colors.white, size: 24),
                      SizedBox(width: 8),
                      Text(
                        errorValue! > 0
                            ? (errorValue! > 10 ? '10% 이상 상승 예정' : '10% 이내 상승 예정')
                            : (errorValue! < -10 ? '10% 이상 하락 예정' : '10% 이내 하락 예정'),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(width: 10),
                      Tooltip(
                        message: '가격예측정보는 농산물의 가격에 영향을 주는 다양한 요인(날씨, 유통, 거래, 가격 등)을 활용, AI 기술로 분석한 정보입니다.',
                        triggerMode: TooltipTriggerMode.tap,
                        child: Icon(Icons.help_outline, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),

        ],
      ),
    );
  }
}

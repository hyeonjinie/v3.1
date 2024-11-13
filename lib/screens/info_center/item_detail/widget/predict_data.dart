import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class PredictData extends StatelessWidget {
  final double? predictChange;

  PredictData({required this.predictChange});

  @override
  Widget build(BuildContext context) {
    final bool isWeb = kIsWeb;
    final double width = isWeb ? MediaQuery.of(context).size.width * 0.1 : MediaQuery.of(context).size.width * 0.3;
    final double height = isWeb ? MediaQuery.of(context).size.height * 0.02 : MediaQuery.of(context).size.height * 0.04;


    String message = '';
    Color backgroundColor = Colors.grey[200]!;
    IconData icon = Icons.info_outline;
    Color iconColor = Colors.blue;

    if (predictChange != null) {
      if (predictChange! > 10) {
        message = '10% 이상';
        backgroundColor = Colors.green[300]!;
        icon = Icons.trending_up;
        iconColor = Colors.green[800]!;
      } else if (predictChange! > 0) {
        message = '10% 이내';
        backgroundColor = Colors.green[100]!;
        icon = Icons.trending_up;
        iconColor = Colors.green[600]!;
      } else if (predictChange! < -10) {
        message = '10% 이상';
        backgroundColor = Colors.red[300]!;
        icon = Icons.trending_down;
        iconColor = Colors.red[800]!;
      } else if (predictChange! < 0) {
        message = '10% 이내';
        backgroundColor = Colors.red[100]!;
        icon = Icons.trending_down;
        iconColor = Colors.red[600]!;
      }
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 24),
          SizedBox(width: 5),
          Text(
            message,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: iconColor),
          ),
        ],
      ),
    );
  }
}

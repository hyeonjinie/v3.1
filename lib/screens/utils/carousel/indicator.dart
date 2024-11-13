import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  final int itemCount;
  final Color color;

  const Indicator({
    Key? key,
    required this.itemCount,
    this.color = Colors.black54,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        return Container(
          width: 8.0,
          height: 8.0,
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        );
      }),
    );
  }
}

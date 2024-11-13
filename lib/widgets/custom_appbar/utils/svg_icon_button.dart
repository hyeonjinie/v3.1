import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIconButton extends StatelessWidget {
  const SvgIconButton({
    required this.icon,
    // required this.color,
    this.padding = 2.0,
  });

  final double padding;
  final String icon;

  // final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: SvgPicture.asset(icon),
    );
  }
}

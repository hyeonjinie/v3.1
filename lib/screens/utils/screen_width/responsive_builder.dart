import 'package:flutter/material.dart';

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, double width) builder;

  const ResponsiveBuilder({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double contentWidth = screenWidth > 1200 ? 1200 : screenWidth;

    return builder(context, contentWidth);
  }
}

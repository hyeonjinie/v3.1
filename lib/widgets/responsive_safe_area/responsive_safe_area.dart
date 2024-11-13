import 'package:flutter/material.dart';

class ResponsiveSafeArea extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ResponsiveSafeArea({required this.child, this.maxWidth = 1200});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

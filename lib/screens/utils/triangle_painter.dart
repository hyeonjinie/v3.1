import 'package:flutter/material.dart';

class TrianglePainter extends CustomPainter {
  final Color color;
  final bool isUp;

  TrianglePainter({required this.color, required this.isUp});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    if (isUp) {
      path.moveTo(size.width / 2, 0); // Top
      path.lineTo(size.width, size.height); // Bottom Right
      path.lineTo(0, size.height); // Bottom Left
    } else {
      path.moveTo(size.width / 2, size.height); // Bottom
      path.lineTo(size.width, 0); // Top Right
      path.lineTo(0, 0); // Top Left
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

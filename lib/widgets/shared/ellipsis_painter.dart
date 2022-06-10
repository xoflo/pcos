import 'package:flutter/material.dart';

class EllipsisPainter extends CustomPainter {
  final Color color;
  final double heightMultiplier;
  final double x1Multiplier;
  final double x2Multiplier;
  final double y1Multiplier;
  final double y2Multiplier;

  EllipsisPainter({
    required this.color,
    this.heightMultiplier = 1,
    this.x1Multiplier = 1,
    this.x2Multiplier = 1,
    this.y1Multiplier = 1,
    this.y2Multiplier = 1,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = color;
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, size.height * heightMultiplier);
    path.quadraticBezierTo(
      size.width * x1Multiplier,
      size.height * y1Multiplier,
      size.width * x2Multiplier,
      size.height * y2Multiplier,
    );
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

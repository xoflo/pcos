import 'package:flutter/material.dart';

class DrawCircle extends CustomPainter {
  final Color circleColor;

  DrawCircle({this.circleColor});

  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = circleColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(0, 0), size.width, paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

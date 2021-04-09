import 'package:flutter/material.dart';

class DrawCircle extends CustomPainter {
  final Color circleColor;
  final bool isFilled;

  DrawCircle({@required this.circleColor, @required this.isFilled});

  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = circleColor
      ..strokeWidth = isFilled ? 1 : 3
      ..style = isFilled ? PaintingStyle.fill : PaintingStyle.stroke;
    canvas.drawCircle(Offset(0, 0), size.width, paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

import 'package:flutter/material.dart';

class CirclePainter extends CustomPainter {
  CirclePainter({required this.color});

  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width, paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

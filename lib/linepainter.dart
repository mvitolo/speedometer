import 'dart:math';

import 'package:flutter/material.dart';

class LinePainter extends CustomPainter {
  Color lineColor;
  Color completeColor;
  double startPercent;
  double endPercent;
  double width;
  int startValue;
  int endValue;
  final angle = 2 * pi / 60;

  LinePainter(
      {required this.lineColor,
      required this.completeColor,
      required this.startValue,
      required this.endValue,
      required this.startPercent,
      required this.endPercent,
      required this.width});
  @override
  void paint(Canvas canvas, Size size) {
    Paint line = Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Paint complete = Paint()
      ..color = completeColor
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), 25 * angle,
        40 * angle, false, line);

    canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        25 * angle + (40 * angle) * startPercent,
        (40 * angle) * (endPercent - startPercent),
        false,
        complete);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

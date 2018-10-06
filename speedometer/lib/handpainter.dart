import 'dart:math';

import 'package:flutter/material.dart';

class HandPainter extends CustomPainter{
  final Paint minuteHandPaint;
  double value;
  int start;
  int end;

  HandPainter({this.value,this.start,this.end}):minuteHandPaint= new Paint(){
    minuteHandPaint.color= const Color(0xFF333333);
    minuteHandPaint.style= PaintingStyle.fill;

  }

  @override
  void paint(Canvas canvas, Size size) {
    final radius= size.width/2;

    double downSizedValue = ((value <= (this.end/2))? value : value - (this.end/2))*(40/this.end);
    double realValue = (((value <= (this.end/2))? downSizedValue+40 : downSizedValue)%this.end);

    canvas.save();

    canvas.translate(radius, radius);

    canvas.rotate(2*pi*((realValue)/this.end));

    Path path= new Path();
    path.moveTo(-1.5, -radius-10.0);
    path.lineTo(-5.0, -radius/1.8);
    path.lineTo(-2.0, 10.0);
    path.lineTo(2.0, 10.0);
    path.lineTo(5.0, -radius/1.8);
    path.lineTo(1.5, -radius-10.0);
    path.close();

    canvas.drawPath(path, minuteHandPaint);
    canvas.drawShadow(path, Colors.black, 4.0, false);

    canvas.restore();

  }

  @override
  bool shouldRepaint(HandPainter oldDelegate) {
    return true;
  }
}

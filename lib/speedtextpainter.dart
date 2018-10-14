import 'dart:math';
import 'package:flutter/material.dart';

class SpeedTextPainter extends CustomPainter {
    final hourTickMarkLength = 20.0;
    final minuteTickMarkLength = 0.0;
    
    final hourTickMarkWidth = 3.0;
    final minuteTickMarkWidth = 1.5;
    
    final Paint tickPaint;
    final TextPainter textPainter;
    final TextStyle textStyle;
    int end;
    int start;
    double value;
    
    SpeedTextPainter({this.start, this.end, this.value})
        : tickPaint = new Paint(),
            textPainter = new TextPainter(
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
            ),
            textStyle = const TextStyle(
                color: Colors.black,
                fontSize: 15.0,
            ) {
        tickPaint.color = Colors.white;
    }
    
    @override
    void paint(Canvas canvas, Size size) {
        var tickMarkLength;
        final angle = 2 * pi / 60;
        final radius = size.width / 2;
        canvas.save();
        
        // drawing
        canvas.translate(radius, radius);
        for (var i = 0; i < 60; i++) {
            //make the length and stroke of the tick marker longer and thicker depending
            tickMarkLength = i % 5 == 0 && !(i < 41 && i > 19)
                ? hourTickMarkLength
                : minuteTickMarkLength;
            tickPaint.strokeWidth = i % 5 == 0 && !(i < 41 && i > 19)
                ? hourTickMarkWidth
                : minuteTickMarkWidth;
            canvas.drawLine(new Offset(0.0, -radius - 20),
                new Offset(0.0, -radius - 20 + tickMarkLength), tickPaint);
            
            //draw the text
            if (i == 40 || i == 20) {
                String label = i == 40 ? start.toString() : this.end.toString();
                canvas.save();
                canvas.translate(i == 40 ? -20.0 : 20.0, -radius + 50.0);
                
                textPainter.text = new TextSpan(
                    text: label,
                    style: textStyle,
                );
                
                //helps make the text painted vertically
                canvas.rotate(-angle * i);
                
                textPainter.layout();
                
                textPainter.paint(canvas,
                    new Offset(-(textPainter.width / 2), -(textPainter.height / 2)));
                
                canvas.restore();
            } else if (i == 30) {
                String label = this.value.toStringAsFixed(1);
                canvas.save();
                canvas.translate(0.0, -radius + 50.0);
                
                textPainter.text = new TextSpan(
                    text: label,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 35.0,
                    ),
                );
                canvas.rotate(-angle * i);
                
                textPainter.layout();
                
                textPainter.paint(canvas,
                    new Offset(-(textPainter.width / 2), -(textPainter.height / 2)));
                
                canvas.restore();
            }
            
            canvas.rotate(angle);
        }
        
        canvas.restore();
    }
    
    @override
    bool shouldRepaint(SpeedTextPainter oldDelegate) {
        return false;
    }
}

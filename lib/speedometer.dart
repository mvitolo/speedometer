library speedometer;

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:speedometer/handpainter.dart';
import 'package:speedometer/linepainter.dart';
import 'package:speedometer/speedtextpainter.dart';
import 'package:rxdart/rxdart.dart';

class SpeedOMeter extends StatefulWidget {
  int start;
  int end;
  double highlightStart;
  double highlightEnd;
  Duration animationDuration;
  ThemeData themeData;

  PublishSubject<double> eventObservable;

  SpeedOMeter(
      {required this.start,
      required this.end,
      required this.highlightStart,
      required this.highlightEnd,
      required this.themeData,
      required this.eventObservable,
      this.animationDuration = const Duration(milliseconds: 1000)});

  @override
  _SpeedOMeterState createState() => _SpeedOMeterState(
      start: this.start,
      end: this.end,
      highlightStart: this.highlightStart,
      highlightEnd: this.highlightEnd,
      animationDuration: this.animationDuration,
      eventObservable: this.eventObservable);
}

class _SpeedOMeterState extends State<SpeedOMeter>
    with TickerProviderStateMixin {
  int start;
  int end;
  double highlightStart;
  double highlightEnd;
  Duration animationDuration;
  PublishSubject<double> eventObservable;

  double val = 0.0;
  late double newVal;
  double textVal = 0.0;
  AnimationController? percentageAnimationController;
  late StreamSubscription<double> subscription;

  _SpeedOMeterState(
      {required this.start,
      required this.end,
      required this.highlightStart,
      required this.highlightEnd,
      required this.animationDuration,
      required this.eventObservable}) {
    subscription = this.eventObservable.listen((value) {
      textVal = value;
      (value >= this.end) ? reloadData(this.end.toDouble()) : reloadData(value);
    });
  }

  reloadData(double value) {
    debugPrint(
        "value: $value, animationDuration: ${percentageAnimationController?.duration}");
    newVal = value;
    if (percentageAnimationController == null) {
      percentageAnimationController =
          AnimationController(vsync: this, duration: animationDuration)
            ..addListener(() {
              if (mounted) {
                setState(() {
                  val = lerpDouble(
                      val, newVal, percentageAnimationController!.value)!;
                });
              }
            });
    }
    percentageAnimationController!.forward(from: 0.0);
  }

  @override
  void didUpdateWidget(covariant SpeedOMeter oldWidget) {
    debugPrint(
        "didUpdateWidget with new animationDuration: ${widget.animationDuration}");
    super.didUpdateWidget(oldWidget);
    // Check if the animationDuration has changed
    if (oldWidget.animationDuration != widget.animationDuration) {
      // Update the AnimationController with the new duration
      percentageAnimationController?.duration = widget.animationDuration;
      // If needed, restart the animation with the new duration
      if (percentageAnimationController?.isAnimating ?? false) {
        percentageAnimationController?.forward(from: 0.0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)?.isCurrent == false) {
      return Text("");
    }
    return Center(
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          height: constraints.maxWidth,
          width: constraints.maxWidth,
          child: Stack(fit: StackFit.expand, children: <Widget>[
            Container(
              child: CustomPaint(
                  foregroundPainter: LinePainter(
                      lineColor: this.widget.themeData.colorScheme.background,
                      completeColor: this.widget.themeData.colorScheme.primary,
                      startValue: this.start,
                      endValue: this.end,
                      startPercent: this.widget.highlightStart,
                      endPercent: this.widget.highlightEnd,
                      width: 40.0)),
            ),
            Center(
                //   aspectRatio: 1.0,
                child: Container(
                    height: constraints.maxWidth,
                    width: double.infinity,
                    padding: const EdgeInsets.all(20.0),
                    child: Stack(fit: StackFit.expand, children: <Widget>[
                      CustomPaint(
                        painter: HandPainter(
                            value: val,
                            start: this.start,
                            end: this.end,
                            color: this.widget.themeData.colorScheme.secondary),
                      ),
                    ]))),
            Center(
              child: Container(
                width: 30.0,
                height: 30.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: this.widget.themeData.colorScheme.background,
                ),
              ),
            ),
            CustomPaint(
                painter: SpeedTextPainter(
                    start: this.start, end: this.end, value: this.textVal)),
          ]),
        );
      }),
    );
  }

  @override
  dispose() {
    if (percentageAnimationController != null) {
      percentageAnimationController!.dispose();
    }
    subscription.cancel();
    super.dispose();
  }
}

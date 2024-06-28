import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:speedometer/speedometer.dart';
import 'package:rxdart/rxdart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'SpeedOMeter Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _lowerValue = 20.0;
  double _upperValue = 40.0;
  int start = 0;
  int end = 60;

  int counter = 0;

  Duration _animationDuration = Duration(milliseconds: 100);

  PublishSubject<double> eventObservable = PublishSubject();
  @override
  void initState() {
    super.initState();
    const click = const Duration(milliseconds: 500);
    var rng = Random();
    Timer.periodic(click,
        (Timer t) => eventObservable.add(rng.nextInt(59) + rng.nextDouble()));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData();
    ThemeData somTheme = theme.copyWith(
      colorScheme: theme.colorScheme.copyWith(
        primary: Colors.blue,
        secondary: Colors.black,
        background: Colors.grey,
      ),
    );
    var speedOMeter = SpeedOMeter(
      start: start,
      end: end,
      highlightStart: (_lowerValue / end),
      highlightEnd: (_upperValue / end),
      themeData: somTheme,
      eventObservable: this.eventObservable,
      animationDuration: _animationDuration,
    );
    return Scaffold(
        appBar: AppBar(
          title: Text("SpeedOMeter"),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(40.0),
              child: speedOMeter,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _animationDuration += Duration(milliseconds: 100);
                });
              },
              child: Text('Slower...'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _animationDuration -= Duration(milliseconds: 100);
                });
              },
              child: Text('Faster!'),
            ),
          ],
        ));
  }
}

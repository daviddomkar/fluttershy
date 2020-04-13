import 'dart:math';

import 'package:flutter/material.dart' hide State, Transform, Size;
import 'package:fluttershy/fluttershy.dart';
import 'package:fluttershy/backend.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Fluttershy(
          backgroundColor: Colors.pink,
          backend: CustomBackend(),
        ),
      ),
    );
  }
}

class CustomBackend extends Backend {
  final Paint paint = Paint()..color = Colors.amber;

  double time = 0;
  double positionY = 0;

  @override
  void update(double deltaTime) {
    positionY = sin(time * 5) * 20;

    time += deltaTime;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawOval(Rect.fromLTWH(20, 75 + positionY, 200, 200), paint);
  }
}

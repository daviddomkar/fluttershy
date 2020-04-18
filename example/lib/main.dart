import 'dart:math';

import 'package:flutter/material.dart'
    hide State, Transform, Size, PointerMoveEvent;
import 'package:fluttershy/fluttershy.dart';
import 'package:fluttershy/backend.dart';
import 'package:fluttershy/event.dart';
import 'package:fluttershy/events/pointer_event.dart';

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
        body: Container(
          margin: EdgeInsets.all(200),
          child: Fluttershy(
            backgroundColor: Colors.pink,
            backend: CustomBackend(),
          ),
        ),
      ),
    );
  }
}

class CustomBackend extends Backend {
  final Paint paint = Paint()..color = Colors.amber;

  double time = 0;
  double positionX = 200;
  double positionY = 200;

  @override
  void update(double deltaTime) {
    time += deltaTime;
  }

  @override
  void event(Type type, Event event) {
    if (type == PointerMoveEvent) {
      positionX = (event as PointerMoveEvent).screenX;
      positionY = (event as PointerMoveEvent).screenY;
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(positionX, positionY + sin(time * 5) * 20),
            width: 200,
            height: 200),
        paint);
  }
}

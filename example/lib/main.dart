import 'dart:math';

import 'package:flutter/material.dart'
    hide State, Transform, Size, PointerMoveEvent;
import 'package:fluttershy/fluttershy.dart';
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
          child: FluttershyWidget(
            contextBuilder: () => ExampleContext(),
            event: (context, event) {
              if (event.type == PointerMoveEvent) {
                context.positionX = (event as PointerMoveEvent).position.x;
                context.positionY = (event as PointerMoveEvent).position.y;
              }
            },
            update: (context, deltaTime) {
              context.time += deltaTime;
            },
            render: (context, canvas) {
              canvas.drawOval(
                  Rect.fromCenter(
                      center: Offset(context.positionX,
                          context.positionY + sin(context.time * 5) * 20),
                      width: 200,
                      height: 200),
                  context.paint);
            },
            backgroundColor: Colors.pink,
          ),
        ),
      ),
    );
  }
}

class ExampleContext extends Context {
  final Paint paint = Paint()..color = Colors.amber;

  double time = 0;
  double positionX = 200;
  double positionY = 200;
}

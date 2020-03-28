import 'package:flutter/material.dart' hide State, Transform, Size;
import 'package:fluttershy/fluttershy.dart';
import 'package:fluttershy/foundation/scene.dart';
import 'package:fluttershy/foundation/rectangle.dart';
import 'package:fluttershy/foundation/rive.dart';
import 'package:fluttershy/foundation/camera.dart';
import 'package:fluttershy/foundation/size.dart';
import 'package:fluttershy/foundation/anchor.dart';

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
        body: Fluttershy(
          defaultScene: ExampleScene(),
        ),
      ),
    );
  }
}

class ExampleScene extends Scene {
  @override
  void setup(BuildContext context) {
    super.setup(context);

    final camera = Camera(
      size: Size(double.infinity, 900),
      anchor: Anchor.center,
    );

    final rectangle = Rectangle(
      color: Colors.green,
      size: Size(180, 180),
      anchor: Anchor.center,
    );

    final rive = Rive(
      fileName: 'assets/log.flr',
      size: Size(180, 180 * 2.0),
      anchor: Anchor.center,
    );

    root.attachChild(camera);
    root.attachChild(rectangle);
    root.attachChild(rive);
  }
}

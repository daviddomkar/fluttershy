import 'dart:math';

import 'package:dartex/dartex.dart';
import 'package:flutter/material.dart' hide State, Transform, Size;
import 'package:fluttershy/fluttershy.dart';
import 'package:fluttershy/foundation/state.dart';
import 'package:fluttershy/modules/events/events_module.dart';
import 'package:fluttershy/modules/transform/transform_module.dart';
import 'package:fluttershy/modules/time/time_module.dart';
import 'package:fluttershy/modules/rendering/rendering_module.dart';
import 'package:fluttershy/modules/rendering/components/rectangle.dart';
import 'package:fluttershy/modules/rendering/components/camera.dart';
import 'package:fluttershy/foundation/components/size.dart';
import 'package:fluttershy/modules/transform/components/transform.dart';
import 'package:fluttershy/modules/transform/components/translation.dart';
import 'package:fluttershy/modules/transform/components/scale.dart';

import 'systems/rectangle_move_system.dart';

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
          defaultState: ExampleState(),
          modules: [
            EventsModule(),
            TimeModule(),
            TransformModule(),
            RenderingModule(),
          ],
          systems: [
            RectangleMoveSystem(),
          ],
        ),
      ),
    );
  }
}

class ExampleState extends State {
  @override
  void onStart(World world) {
    world
        .createEntity()
        .withComponent(Transform())
        .withComponent(Translation(0, 0, 0))
        .withComponent(Scale(0.5, 0.5, 1.0))
        .withComponent(Camera(size: Size(double.infinity, 900)))
        .build();

    final random = Random();

    for (var i = 0; i < 10000; i++) {
      world
          .createEntity()
          .withComponent(Transform())
          .withComponent(Translation(
              random.nextDouble() * 1600, random.nextDouble() * 900, 0))
          .withComponent(Scale(1.0, 1.0, 1.0))
          .withComponent(Rectangle(color: Colors.blue, size: Size(5, 5)))
          .build();
    }
  }
}

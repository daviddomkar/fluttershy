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
import 'package:fluttershy/modules/rendering/components/rive.dart';
import 'package:fluttershy/modules/rendering/components/camera.dart';
import 'package:fluttershy/foundation/size.dart';
import 'package:fluttershy/foundation/parent.dart';
import 'package:fluttershy/foundation/anchor.dart';
import 'package:fluttershy/modules/transform/components/local_to_world.dart';
import 'package:fluttershy/modules/transform/components/local_to_parent.dart';
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
            /* RectangleMoveSystem(),*/
          ],
        ),
      ),
    );
  }
}

class ExampleState extends State {
  @override
  void onStart(BuildContext context, World world) {
    world
        .createEntity()
        .withComponent(LocalToWorld())
        .withComponent(Translation(0, 0, 0))
        .withComponent(Scale(1.0, 1.0, 1.0))
        .withComponent(Camera(size: Size(double.infinity, 900)))
        .build();

    final scale = 1.0;

    world
        .createEntity()
        .withComponent(LocalToWorld())
        .withComponent(Translation(0, 0, 0))
        .withComponent(Scale(scale, scale, 1.0))
        .withComponent(Rectangle(color: Colors.amber, size: Size(200, 200)))
        .withComponent(Anchor.bottomLeft)
        .build();

    world
        .createEntity()
        .withComponent(LocalToWorld())
        .withComponent(Translation(0, 200 * scale, 0))
        .withComponent(Scale(scale, scale, 1.0))
        .withComponent(Rectangle(color: Colors.green, size: Size(200, 200)))
        .withComponent(Anchor.bottomLeft)
        .build();

    world
        .createEntity()
        .withComponent(LocalToWorld())
        .withComponent(Translation(0, 0, 0))
        .withComponent(Scale(scale, scale, 1.0))
        .withComponent(
            Rive(fileName: 'assets/log.flr', size: Size(200, 200 * 2.0)))
        .build();
  }
}

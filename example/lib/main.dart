import 'package:dartex/dartex.dart';
import 'package:flutter/material.dart' hide State, Transform;
import 'package:fluttershy/fluttershy.dart';
import 'package:fluttershy/foundation/state.dart';
import 'package:fluttershy/modules/events/events_module.dart';
import 'package:fluttershy/modules/transform/transform_module.dart';
import 'package:fluttershy/modules/rendering/rendering_module.dart';
import 'package:fluttershy/modules/transform/components/transform.dart';
import 'package:fluttershy/modules/transform/components/translation.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

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
          defaultState: PilgrimState(),
          modules: [
            EventsModule(),
            TransformModule(),
            RenderingModule(),
          ],
          systems: [],
        ),
      ),
    );
  }
}

class PilgrimState extends State {
  @override
  void onStart(World world) {
    world
        .createEntity()
        .withComponent(Transform())
        .withComponent(Translation(20, 20, 0))
        .build();
  }

  @override
  void onRender(World world, Canvas canvas) {
    final query = world.query([Transform, Translation]);

    print(query.entities);

    var camera = Matrix4.identity();
    var object = Matrix4.identity();

    Vector3 cameraPos = Vector3(20, 300, 0);
    Vector3 objectPos = Vector3(0, 200, 0);

    object.translate(objectPos);
    camera.translate(cameraPos);

    camera.invert();

    canvas.transform(camera.storage);

    canvas.drawRect(
        Rect.fromCenter(
            center:
                Offset(object.getTranslation().x, object.getTranslation().y),
            width: 300,
            height: 300),
        Paint()..color = Colors.amber);
  }
}

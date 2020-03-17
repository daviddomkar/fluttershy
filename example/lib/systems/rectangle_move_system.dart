import 'dart:math';

import 'package:dartex/dartex.dart';
import 'package:fluttershy/modules/rendering/components/rectangle.dart';
import 'package:fluttershy/modules/transform/components/translation.dart';
import 'package:fluttershy/modules/transform/components/local_to_world.dart';
import 'package:fluttershy/modules/time/resources/timer.dart';

class RectangleMoveSystem extends System {
  RectangleMoveSystem() : super(type: [Rectangle, LocalToWorld, Translation]);

  final random = Random();

  @override
  void run(World world, List<Entity> entities) {
    double deltaTime = world.getResource<Timer>().deltaTime;

    entities.forEach((entity) {
      entity.getComponent<Translation>().x +=
          ((random.nextDouble() - 0.5) * 4) * 50 * deltaTime;
    });
  }
}

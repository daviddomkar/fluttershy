import 'package:dartex/system.dart';
import 'package:dartex/world.dart';
import 'package:fluttershy/modules/transform/components/previous_transform_component.dart';
import 'package:fluttershy/modules/transform/components/transform_component.dart';
import 'package:fluttershy/foundation/transform.dart';

class PreviousTransformSystem extends System {
  PreviousTransformSystem()
      : super([TransformComponent, PreviousTransformComponent]);

  @override
  void run(World world, List<Entity> entities) {
    entities.forEach((entity) {
      Transform current = entity.getComponent<TransformComponent>();
      Transform previous = entity.getComponent<PreviousTransformComponent>();

      previous.position = current.position.copyWith();
      previous.scale = current.scale.copyWith();
    });
  }
}

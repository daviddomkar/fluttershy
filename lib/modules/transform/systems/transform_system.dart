import 'package:dartex/system.dart';
import 'package:dartex/world.dart';
import 'package:fluttershy/modules/transform/components/transform_component.dart';

class TransformSystem extends System {
  TransformSystem() : super([TransformComponent]);

  @override
  void run(World world, List<Entity> entities) {
    entities.forEach((entity) {
      var transformComponent = entity.getComponent<TransformComponent>();

      var parent = transformComponent.parent;
      var worldTransform = transformComponent.localTransform.copyWith();

      while (parent != null) {
        var parentTransformComponent =
            entity.getComponent<TransformComponent>();

        worldTransform.position
            .add(parentTransformComponent.localTransform.position);
      }

      transformComponent.worldTransform = worldTransform;
    });
  }
}

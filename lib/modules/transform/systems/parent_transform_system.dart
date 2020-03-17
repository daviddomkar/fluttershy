import 'package:dartex/dartex.dart';
import 'package:fluttershy/foundation/parent.dart';
import 'package:fluttershy/modules/transform/components/local_to_parent.dart';
import 'package:fluttershy/modules/transform/components/local_to_world.dart';

class ParentTransformSystem extends System {
  ParentTransformSystem()
      : super(type: [
          LocalToWorld,
          LocalToParent,
          Parent,
        ]);

  @override
  void run(World world, List<Entity> entities) {
    entities.forEach((entity) {
      final worldTransform = entity.getComponent<LocalToWorld>();
      final parentTransform = entity.getComponent<LocalToParent>();
      final parent = entity.getComponent<Parent>();

      // TODO improve this, not sure of possible side effects

      worldTransform.matrix.setFrom(
          parent.entity.getComponent<LocalToWorld>().matrix *
              parentTransform.matrix);
    });
  }
}

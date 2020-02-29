import 'package:dartex/system.dart';
import 'package:dartex/world.dart';
import 'package:fluttershy/modules/transform/components/parent_component.dart';
import 'package:fluttershy/modules/transform/components/transform_component.dart';

class ParentTransformSystem extends System {
  ParentTransformSystem() : super([TransformComponent, ParentComponent]);

  @override
  void run(World world, List<Entity> entities) {
    entities.forEach((entity) {});
  }
}

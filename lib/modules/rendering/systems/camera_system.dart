import 'package:dartex/system.dart';
import 'package:dartex/world.dart';
import 'package:fluttershy/modules/rendering/components/camera_component.dart';
import 'package:fluttershy/modules/rendering/resources/renderer_resource.dart';
import 'package:fluttershy/modules/transform/components/transform_component.dart';

class CameraSystem extends System {
  CameraSystem() : super([CameraComponent]);

  @override
  void run(World world, List<Entity> entities) {
    if (entities.isNotEmpty) {
      var camera = entities[0].getComponent<CameraComponent>();
      var transform =
          entities[0].getComponent<TransformComponent>().worldTransform;

      var renderer = world.getResource<RendererResource>();

      renderer.viewportSize = camera.size.copyWith();
      renderer.transform.position = transform.position.copyWith();
      renderer.transform.scale = transform.scale.copyWith();
    }
  }
}

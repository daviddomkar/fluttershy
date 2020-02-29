import 'package:dartex/system.dart';
import 'package:dartex/world.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttershy/modules/rendering/components/rectangle_component.dart';
import 'package:fluttershy/modules/rendering/resources/renderer_resource.dart';
import 'package:fluttershy/modules/transform/components/transform_component.dart';

class RectangleRenderingSystem extends System {
  RectangleRenderingSystem() : super([TransformComponent, RectangleComponent]);

  @override
  void run(World world, List<Entity> entities) {
    var renderer = world.getResource<RendererResource>();

    entities.forEach((entity) {
      renderer.submitRenderableEntity(entity, (canvas, entity) {
        var transformComponent = entity.getComponent<TransformComponent>();
        var rectangleComponent = entity.getComponent<RectangleComponent>();

        canvas.drawRect(
            Rect.fromCenter(
                center: transformComponent.position.toOffset(),
                width: rectangleComponent.size.width,
                height: rectangleComponent.size.height),
            Paint()..color = rectangleComponent.color);
      });
    });
  }
}

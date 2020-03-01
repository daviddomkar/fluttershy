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
      renderer.submit(entity, (canvas, entity) {
        var transformComponent = entity.getComponent<TransformComponent>();
        var rectangleComponent = entity.getComponent<RectangleComponent>();

        var x = transformComponent.worldTransform.position.x;
        var y = transformComponent.worldTransform.position.y;

        var paint = Paint()..color = rectangleComponent.color;

        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(x, y),
            width: rectangleComponent.size.width,
            height: rectangleComponent.size.height,
          ),
          paint,
        );
      });
    });
  }
}

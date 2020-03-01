import 'package:dartex/system.dart';
import 'package:dartex/world.dart';
import 'package:flutter/rendering.dart' hide Size;
import 'package:fluttershy/foundation/anchor.dart';
import 'package:fluttershy/foundation/size.dart';
import 'package:fluttershy/foundation/transform.dart';
import 'package:fluttershy/modules/rendering/components/rectangle_component.dart';
import 'package:fluttershy/modules/rendering/resources/renderer_resource.dart';
import 'package:fluttershy/modules/transform/components/transform_component.dart';

class RectangleRenderingSystem extends System {
  final Paint _paint;

  RectangleRenderingSystem()
      : _paint = Paint(),
        super([TransformComponent, RectangleComponent]);

  @override
  void run(World world, List<Entity> entities) {
    var renderer = world.getResource<RendererResource>();

    entities.forEach((entity) {
      renderer.submit(entity, (canvas, transform) {
        var rectangleComponent = entity.getComponent<RectangleComponent>();

        _paint.color = rectangleComponent.color;

        var rect = _computeAnchoredRect(
          rectangleComponent.anchor,
          transform,
          rectangleComponent.size,
        );

        canvas.drawRect(
          rect,
          _paint,
        );
      });
    });
  }

  Rect _computeAnchoredRect(Anchor anchor, Transform transform, Size size) {
    var x = transform.position.x;
    var y = transform.position.y;
    var width = size.width * transform.scale.x;
    var height = size.height * transform.scale.y;

    switch (anchor) {
      case Anchor.topLeft:
        return Rect.fromLTRB(x, y, x + width, y + height);
      case Anchor.topCenter:
        return Rect.fromLTRB(x - width / 2, y, x + width / 2, y + height);
      case Anchor.topRight:
        return Rect.fromLTRB(x - width, y, x, y + height);
      case Anchor.centerLeft:
        return Rect.fromLTRB(x, y - height / 2, x + width, y + height / 2);
      case Anchor.center:
        return Rect.fromLTRB(
            x - width / 2, y - height / 2, x + width / 2, y + height / 2);
      case Anchor.centerRight:
        return Rect.fromLTRB(x - width, y - height / 2, x, y + height / 2);
      case Anchor.bottomLeft:
        return Rect.fromLTRB(x, y - height, x + width, y);
      case Anchor.bottomCenter:
        return Rect.fromLTRB(x - width / 2, y - height, x + width / 2, y);
      case Anchor.bottomRight:
        return Rect.fromLTRB(x - width, y - height, x, y);
    }

    return Rect.fromLTRB(x, y, x + width, y + height);
  }
}

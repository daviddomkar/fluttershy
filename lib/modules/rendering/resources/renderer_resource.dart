import 'package:dartex/resource.dart';
import 'package:dartex/world.dart';
import 'package:flutter/material.dart' hide Size, Transform;
import 'package:flutter/rendering.dart';
import 'package:fluttershy/foundation/position.dart';
import 'package:fluttershy/foundation/scale.dart';
import 'package:fluttershy/foundation/size.dart';
import 'package:fluttershy/foundation/transform.dart';
import 'package:fluttershy/modules/transform/components/transform_component.dart';
import 'package:ordered_set/comparing.dart';
import 'package:ordered_set/ordered_set.dart';
import 'package:tuple/tuple.dart';

class RendererResource with Resource {
  final OrderedSet<Tuple2<Entity, Function(Canvas, Transform)>> _renderables;

  Color backgroundColor;

  Size size;
  Size viewportSize;
  Transform transform;

  RendererResource({this.backgroundColor, this.size, this.transform})
      : _renderables = OrderedSet(
          Comparing.on(
            (tuple) => tuple.item1
                .getComponent<TransformComponent>()
                .worldTransform
                .position
                .z,
          ),
        ) {
    viewportSize = size;
    transform = transform ??
        Transform(
          position: Position.zero(),
          scale: Scale.normal(),
        );
  }

  void submit(Entity entity, Function(Canvas, Transform) renderFunction) {
    _renderables.add(Tuple2(entity, renderFunction));
  }

  void render(Canvas canvas) {
    canvas.drawColor(backgroundColor ?? Colors.black, BlendMode.color);
    canvas.scale(size.height / viewportSize.height);
    canvas.translate(-this.transform.position.x, this.transform.position.y);

    _renderables.forEach((renderable) {
      var transform = renderable.item1
          .getComponent<TransformComponent>()
          .worldTransform
          .copyWith();

      transform.position.y += (viewportSize.height - transform.position.y * 2);

      renderable.item2(canvas, transform);
    });
    _renderables.clear();
  }
}

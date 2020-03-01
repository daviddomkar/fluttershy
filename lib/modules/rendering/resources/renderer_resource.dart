import 'package:dartex/resource.dart';
import 'package:dartex/world.dart';
import 'package:flutter/material.dart' hide Size, Transform;
import 'package:flutter/rendering.dart';
import 'package:fluttershy/foundation/size.dart';
import 'package:fluttershy/foundation/transform.dart';
import 'package:fluttershy/modules/transform/components/transform_component.dart';
import 'package:ordered_set/comparing.dart';
import 'package:ordered_set/ordered_set.dart';
import 'package:tuple/tuple.dart';

class RendererResource with Resource {
  Size screenSize;

  OrderedSet<Tuple2<Entity, Function(Canvas, Transform)>> _renderables;

  RendererResource(Size screenSize)
      : _renderables = OrderedSet(
          Comparing.on(
            (tuple) => tuple.item1
                .getComponent<TransformComponent>()
                .worldTransform
                .position
                .z,
          ),
        ) {
    this.screenSize = screenSize;
  }

  void submit(Entity entity, Function(Canvas, Transform) renderFunction) {
    _renderables.add(Tuple2(entity, renderFunction));
  }

  void render(Canvas canvas) {
    canvas.drawColor(Colors.black, BlendMode.color);

    _renderables.forEach((renderable) {
      var transform = renderable.item1
          .getComponent<TransformComponent>()
          .worldTransform
          .copyWith();

      transform.position.y += (screenSize.height - transform.position.y * 2);

      renderable.item2(canvas, transform);
    });
    _renderables.clear();
  }
}

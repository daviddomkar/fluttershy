import 'package:dartex/resource.dart';
import 'package:dartex/world.dart';
import 'package:flutter/material.dart' hide Size, Transform;
import 'package:flutter/rendering.dart';
import 'package:fluttershy/foundation/anchor.dart';
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
  Anchor anchor;

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

    var scaleFactorX = (1 / this.transform.scale.x);
    var scaleFactorY = (1 / this.transform.scale.y);

    if (viewportSize.width == double.infinity &&
        viewportSize.height != double.infinity) {
      scaleFactorX *= size.height / viewportSize.height;
      scaleFactorY *= size.height / viewportSize.height;
    } else if (viewportSize.width != double.infinity &&
        viewportSize.height == double.infinity) {
      scaleFactorX *= size.width / viewportSize.width;
      scaleFactorY *= size.width / viewportSize.width;
    } else if (viewportSize.width != double.infinity &&
        viewportSize.height != double.infinity) {
      scaleFactorX *= size.width / viewportSize.width;
      scaleFactorY *= size.height / viewportSize.height;
    }

    canvas.scale(scaleFactorX, scaleFactorY);

    print('=============');
    print(size.height);
    print(size.height / scaleFactorY);
    print(transform.position.y);

    switch (anchor) {
      case Anchor.topLeft:
        canvas.translate(
            -transform.position.x, transform.position.y - size.height);
        break;
      case Anchor.topCenter:
        canvas.translate(
            -transform.position.x + (size.width / scaleFactorX) / 2,
            transform.position.y - size.height);
        break;
      case Anchor.topRight:
        canvas.translate(-transform.position.x + (size.width / scaleFactorX),
            transform.position.y - size.height);
        break;
      case Anchor.centerLeft:
        break;
      case Anchor.center:
        break;
      case Anchor.centerRight:
        break;
      case Anchor.bottomLeft:
        canvas.translate(
            -transform.position.x,
            transform.position.y -
                (size.height - (size.height / scaleFactorY)));
        break;
      case Anchor.bottomCenter:
        canvas.translate(
            -transform.position.x + (size.width / scaleFactorX) / 2,
            transform.position.y - size.height + (size.height / scaleFactorY));
        break;
      case Anchor.bottomRight:
        canvas.translate(-transform.position.x + (size.width / scaleFactorX),
            transform.position.y - size.height + (size.height / scaleFactorY));
        break;
    }

    _renderables.forEach((renderable) {
      var transform = renderable.item1
          .getComponent<TransformComponent>()
          .worldTransform
          .copyWith();

      transform.position.y += size.height - transform.position.y * 2;

      renderable.item2(canvas, transform);
    });
    _renderables.clear();
  }
}

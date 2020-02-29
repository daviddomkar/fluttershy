import 'package:dartex/resource.dart';
import 'package:dartex/world.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttershy/foundation/size.dart';
import 'package:fluttershy/modules/transform/components/transform_component.dart';
import 'package:ordered_set/comparing.dart';
import 'package:ordered_set/ordered_set.dart';
import 'package:tuple/tuple.dart';

class RendererResource with Resource {
  Size screenSize;

  OrderedSet<Tuple2<Entity, Function(Canvas, Entity)>> _renderables;

  RendererResource(Size screenSize)
      : _renderables = OrderedSet(Comparing.on((tuple) =>
            tuple.item1.getComponent<TransformComponent>().position.z));

  void submitRenderableEntity(
      Entity entity, Function(Canvas, Entity) renderFunction) {
    _renderables.add(Tuple2(entity, renderFunction));
  }

  void render(Canvas canvas) {
    _renderables
        .forEach((renderable) => renderable.item2(canvas, renderable.item1));
    _renderables.clear();
  }
}

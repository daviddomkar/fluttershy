import 'dart:ui' hide Size;

import 'package:dartex/dartex.dart';
import 'package:fluttershy/foundation/anchor.dart';
import 'package:fluttershy/modules/rendering/components/rectangle.dart';
import 'package:fluttershy/modules/rendering/render_command.dart';
import 'package:fluttershy/modules/rendering/resources/render_command_buffer.dart';
import 'package:fluttershy/modules/transform/components/local_to_world.dart';

class RectangleRenderCommand extends RenderCommand {
  final Rectangle rectangle;
  final LocalToWorld transform;
  final Anchor anchor;

  RectangleRenderCommand({this.rectangle, this.transform, this.anchor})
      : super(priority: transform.matrix.getTranslation().z);

  @override
  void render(Canvas canvas) {
    final translation = transform.matrix.getTranslation();
    final anchor = this.anchor ?? Anchor.center;
    final ltrb = Anchor.computeLTRBfromLTWH(
      anchor,
      translation.x,
      translation.y,
      rectangle.size.width * transform.matrix.getRow(0).x,
      rectangle.size.height * transform.matrix.getRow(1).y,
    );

    canvas.drawRect(Rect.fromLTRB(ltrb.left, ltrb.top, ltrb.right, ltrb.bottom),
        Paint()..color = rectangle.color);
  }
}

class RectangleRenderingSystem extends System {
  RectangleRenderingSystem() : super(type: [Rectangle, LocalToWorld]);

  @override
  void run(World world, List<Entity> entities) {
    final commandBuffer = world.getResource<RenderCommandBuffer>();

    entities.forEach(
      (entity) {
        commandBuffer.submitCommand(
          RectangleRenderCommand(
            rectangle: entity.getComponent<Rectangle>(),
            transform: entity.getComponent<LocalToWorld>(),
            anchor: entity.hasComponent<Anchor>()
                ? entity.getComponent<Anchor>()
                : null,
          ),
        );
      },
    );
  }
}

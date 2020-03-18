import 'dart:ui';

import 'package:dartex/dartex.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttershy/foundation/anchor.dart';
import 'package:fluttershy/modules/rendering/components/rive.dart';
import 'package:fluttershy/modules/rendering/render_command.dart';
import 'package:fluttershy/modules/rendering/resources/asset_bundle.dart';
import 'package:fluttershy/modules/rendering/resources/render_command_buffer.dart';
import 'package:fluttershy/modules/transform/components/local_to_world.dart';
import 'package:fluttershy/modules/transform/components/scale.dart';
import 'package:vector_math/vector_math_64.dart';

class RiveRenderCommand extends RenderCommand {
  final Picture picture;
  final Vector3 position;

  RiveRenderCommand({@required this.picture, @required this.position})
      : super(priority: position.z);

  @override
  void render(Canvas canvas) {
    canvas.drawPicture(picture);
  }
}

class RiveRenderingSystem extends System {
  RiveRenderingSystem() : super(type: [Rive, LocalToWorld]);

  @override
  void run(World world, List<Entity> entities) {
    final commandBuffer = world.getResource<RenderCommandBuffer>();
    final assetBundle = world.getResource<AssetBundle>();

    entities.forEach(
      (entity) {
        final rive = entity.getComponent<Rive>();
        final position =
            entity.getComponent<LocalToWorld>().matrix.getTranslation();

        if (!rive.loading && !rive.loaded) {
          rive.load(assetBundle.bundle);
        }

        if (rive.loaded) {
          final scale = entity.getComponent<Scale>();
          final anchor = entity.getComponent<Anchor>() ?? Anchor.bottomLeft;

          final r = PictureRecorder();
          final c = Canvas(r);

          var scaleX = 1.0;
          var scaleY = 1.0;

          if (scale != null) {
            scaleX = rive.size.width / rive.artboard.width * scale.x;
            scaleY = rive.size.width / rive.artboard.width * scale.y;
          } else {
            scaleX = rive.size.width / rive.artboard.width;
            scaleY = rive.size.width / rive.artboard.width;
          }

          c.scale(scaleX, scaleY);

          switch (anchor) {
            case Anchor.topLeft:
              c.translate(
                scaleX * position.x,
                scaleY * position.y,
              );
              break;
            case Anchor.topCenter:
              c.translate(
                scaleX * position.x - rive.artboard.width / 2,
                scaleY * position.y,
              );
              break;
            case Anchor.topRight:
              c.translate(
                scaleX * position.x - rive.artboard.width,
                scaleY * position.y,
              );
              break;
            case Anchor.centerLeft:
              c.translate(
                scaleX * position.x,
                scaleY * position.y - rive.artboard.height / 2,
              );
              break;
            case Anchor.center:
              c.translate(
                scaleX * position.x - rive.artboard.width / 2,
                scaleY * position.y - rive.artboard.height / 2,
              );
              break;
            case Anchor.centerRight:
              c.translate(
                scaleX * position.x - rive.artboard.width,
                scaleY * position.y - rive.artboard.height / 2,
              );
              break;
            case Anchor.bottomLeft:
              c.translate(
                scaleX * position.x,
                scaleY * position.y - rive.artboard.height,
              );
              break;
            case Anchor.bottomCenter:
              c.translate(
                scaleX * position.x - rive.artboard.width / 2,
                scaleY * position.y - rive.artboard.height,
              );
              break;
            case Anchor.bottomRight:
              c.translate(
                scaleX * position.x - rive.artboard.width,
                scaleY * position.y - rive.artboard.height,
              );
              break;
          }

          rive.artboard.draw(c);

          commandBuffer.submitCommand(
            RiveRenderCommand(picture: r.endRecording(), position: position),
          );
        }
      },
    );
  }
}

import 'package:dartex/dartex.dart';
import 'package:flutter/material.dart' hide Size, Transform;
import 'package:fluttershy/foundation/anchor.dart';
import 'package:fluttershy/foundation/size.dart';
import 'package:fluttershy/foundation/module.dart';
import 'package:fluttershy/modules/rendering/components/camera.dart';
import 'package:fluttershy/modules/rendering/resources/asset_bundle.dart';
import 'package:fluttershy/modules/rendering/resources/render_command_buffer.dart';
import 'package:fluttershy/modules/rendering/resources/screen_dimensions.dart';
import 'package:fluttershy/modules/rendering/systems/rectangle_rendering_system.dart';
import 'package:fluttershy/modules/rendering/systems/rive_rendering_system.dart';
import 'package:fluttershy/modules/transform/components/local_to_world.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

class RenderingModule extends Module {
  final Color backgroundColor;

  RenderingModule({Color backgroundColor})
      : backgroundColor = backgroundColor ?? Colors.black,
        super(
          priority: ExecutionPriority.after,
          systems: [
            RectangleRenderingSystem(),
            RiveRenderingSystem(),
          ],
        );

  @override
  Widget buildMiddleware(BuildContext context, Widget child, World world) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          color: backgroundColor,
          child: child,
        );
      },
    );
  }

  @override
  void onStart(BuildContext context, World world) {
    world.insertResource(AssetBundle(DefaultAssetBundle.of(context)));
    world.insertResource(RenderCommandBuffer());
    world.insertResource(ScreenDimensions());
  }

  @override
  void onResize(World world, Size size) {
    world.getResource<ScreenDimensions>().size = size;
  }

  @override
  void onRender(World world, Canvas canvas) {
    canvas.drawColor(backgroundColor, BlendMode.color);

    canvas.transform(_computeCameraTransform(world).storage);

    final commandBuffer = world.getResource<RenderCommandBuffer>();

    commandBuffer.commands.forEach((command) {
      command.render(canvas);
    });

    commandBuffer.commands.clear();
  }

  Matrix4 _computeCameraTransform(World world) {
    QueryResult cameraQuery = world.query([Camera, LocalToWorld]);

    if (cameraQuery.entities.isNotEmpty) {
      Entity camera = cameraQuery.entities[0];

      final transform = camera.getComponent<LocalToWorld>().matrix.clone();
      final screenSize = world.getResource<ScreenDimensions>().size;
      final size = camera.getComponent<Camera>().size.copy();

      transform.invert();

      var scaleX = 1.0;
      var scaleY = 1.0;

      if (size.width == double.infinity && size.height != double.infinity) {
        scaleX = screenSize.height / size.height;
        scaleY = screenSize.height / size.height;
        size.width = screenSize.width * (1 / scaleX);
      } else if (size.width != double.infinity &&
          size.height == double.infinity) {
        scaleX = screenSize.width / size.width;
        scaleY = screenSize.width / size.width;
        size.height = screenSize.height * (1 / scaleY);
      } else if (size.width != double.infinity &&
          size.height != double.infinity) {
        scaleX = screenSize.width / size.width;
        scaleY = screenSize.height / size.height;
      } else {
        size.width = screenSize.width;
        size.height = screenSize.height;
      }

      transform.scale(scaleX, scaleY, 1);

      final translation = transform.getTranslation();
      final anchor = camera.getComponent<Anchor>() ?? Anchor.bottomLeft;

      switch (anchor) {
        case Anchor.topLeft:
          transform.setTranslationRaw(
            scaleX * translation.x,
            scaleY * translation.y,
            translation.z,
          );
          break;
        case Anchor.topCenter:
          transform.setTranslationRaw(
            scaleX * translation.x + screenSize.width / 2,
            scaleY * translation.y,
            translation.z,
          );
          break;
        case Anchor.topRight:
          transform.setTranslationRaw(
            scaleX * translation.x + screenSize.width,
            scaleY * translation.y,
            translation.z,
          );
          break;
        case Anchor.centerLeft:
          transform.setTranslationRaw(
            scaleX * translation.x,
            scaleY * translation.y + screenSize.height / 2,
            translation.z,
          );
          break;
        case Anchor.center:
          transform.setTranslationRaw(
            scaleX * translation.x + screenSize.width / 2,
            scaleY * translation.y + screenSize.height / 2,
            translation.z,
          );
          break;
        case Anchor.centerRight:
          transform.setTranslationRaw(
            scaleX * translation.x + screenSize.width,
            scaleY * translation.y + screenSize.height / 2,
            translation.z,
          );
          break;
        case Anchor.bottomLeft:
          transform.setTranslationRaw(
            scaleX * translation.x,
            scaleY * translation.y + screenSize.height,
            translation.z,
          );
          break;
        case Anchor.bottomCenter:
          transform.setTranslationRaw(
            scaleX * translation.x + screenSize.width / 2,
            scaleY * translation.y + screenSize.height,
            translation.z,
          );
          break;
        case Anchor.bottomRight:
          transform.setTranslationRaw(
            scaleX * translation.x + screenSize.width,
            scaleY * translation.y + screenSize.height,
            translation.z,
          );
          break;
      }

      return transform;
    } else {
      return Matrix4.identity();
    }
  }
}

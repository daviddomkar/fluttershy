import 'package:dartex/world.dart';
import 'package:flutter/material.dart' hide Size;
import 'package:fluttershy/foundation/event.dart';
import 'package:fluttershy/foundation/events/create_event.dart';
import 'package:fluttershy/foundation/events/render_event.dart';
import 'package:fluttershy/foundation/events/resize_event.dart';
import 'package:fluttershy/foundation/module.dart';
import 'package:fluttershy/foundation/size.dart';
import 'package:fluttershy/modules/rendering/components/camera_component.dart';
import 'package:fluttershy/modules/rendering/components/rectangle_component.dart';
import 'package:fluttershy/modules/rendering/resources/renderer_resource.dart';
import 'package:fluttershy/modules/rendering/systems/rectangle_rendering_system.dart';

class RenderingModule extends Module {
  final Color _backgroundColor;

  RenderingModule({Color backgroundColor})
      : _backgroundColor = backgroundColor ?? Colors.black,
        super([
          CameraComponent,
          RectangleComponent,
        ], [
          RectangleRenderingSystem(),
        ]);

  @override
  Widget buildMiddleware(BuildContext context, Widget child, World world) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          color: _backgroundColor,
          child: child,
        );
      },
    );
  }

  void onEvent(Event event, World world) {
    if (event is ResizeEvent) {
      _resize(world, event.size);
    } else if (event is RenderEvent) {
      _render(world, event.canvas);
    }
  }

  void _resize(World world, Size size) {
    var renderer = world.getResource<RendererResource>();

    if (renderer != null) {
      renderer.screenSize = size;
    } else {
      world.insertResource(RendererResource(size));
    }
  }

  void _render(World world, Canvas canvas) {
    world.getResource<RendererResource>().render(canvas);
  }
}

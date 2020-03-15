import 'package:fluttershy/foundation/module.dart';
import 'package:fluttershy/modules/rendering/systems/rectangle_rendering_system.dart';

class RenderingModule extends Module {
  RenderingModule()
      : super(priority: ExecutionPriority.after, systems: [
          RectangleRenderingSystem(),
        ]);
}

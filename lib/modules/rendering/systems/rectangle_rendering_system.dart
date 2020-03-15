import 'package:dartex/dartex.dart';
import 'package:fluttershy/foundation/components/size.dart';
import 'package:fluttershy/modules/rendering/components/rectangle.dart';
import 'package:fluttershy/modules/transform/components/transform.dart';

class RectangleRenderingSystem extends System {
  RectangleRenderingSystem() : super(type: [Transform, Size, Rectangle]);

  @override
  void run(World world, List<Entity> entities) {}
}

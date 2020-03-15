import 'package:dartex/dartex.dart';
import 'package:fluttershy/foundation/components/size.dart';
import 'package:fluttershy/foundation/module.dart';
import 'package:fluttershy/foundation/resources/dimensions.dart';
import 'package:fluttershy/modules/transform/systems/transform_system.dart';

class TransformModule extends Module {
  TransformModule()
      : super(
          priority: ExecutionPriority.after,
          systems: [
            TransformSystem(),
          ],
        );

  @override
  void onStart(World world) {
    if (world.getResource<Dimensions>() == null) {
      world.insertResource(Dimensions());
    }
  }

  @override
  void onResize(World world, Size size) {
    world.getResource<Dimensions>().screenSize = size;
  }
}

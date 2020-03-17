import 'package:dartex/dartex.dart';
import 'package:fluttershy/foundation/size.dart';
import 'package:fluttershy/foundation/module.dart';
import 'package:fluttershy/modules/transform/systems/parent_transform_system.dart';
import 'package:fluttershy/modules/transform/systems/transform_system.dart';

class TransformModule extends Module {
  TransformModule()
      : super(
          priority: ExecutionPriority.after,
          systems: [
            TransformSystem(),
            ParentTransformSystem(),
          ],
        );
}

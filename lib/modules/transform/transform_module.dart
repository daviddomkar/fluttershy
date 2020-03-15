import 'package:fluttershy/foundation/module.dart';
import 'package:fluttershy/modules/transform/systems/translate_transform_system.dart';

class TransformModule extends Module {
  TransformModule()
      : super(priority: ExecutionPriority.after, systems: [
          TranslateTransformSystem(),
        ]);
}

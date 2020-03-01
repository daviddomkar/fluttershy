import 'package:fluttershy/modules/transform/components/previous_transform_component.dart';
import 'package:fluttershy/modules/transform/components/transform_component.dart';
import 'package:fluttershy/foundation/module.dart';
import 'package:fluttershy/modules/transform/systems/transform_system.dart';

class TransformModule extends Module {
  TransformModule()
      : super([
          TransformComponent,
          PreviousTransformComponent,
        ], [
          TransformSystem(),
        ]);
}

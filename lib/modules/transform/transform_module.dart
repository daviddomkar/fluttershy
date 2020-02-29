import 'package:fluttershy/modules/transform/components/parent_component.dart';
import 'package:fluttershy/modules/transform/components/previous_transform_component.dart';
import 'package:fluttershy/modules/transform/components/transform_component.dart';
import 'package:fluttershy/modules/transform/systems/parent_transform_system.dart';
import 'package:fluttershy/modules/transform/systems/previous_transform_system.dart';
import 'package:fluttershy/foundation/module.dart';

class TransformModule extends Module {
  TransformModule()
      : super([
          TransformComponent,
          PreviousTransformComponent,
          ParentComponent,
        ], [
          PreviousTransformSystem(),
          ParentTransformSystem(),
        ]);
}

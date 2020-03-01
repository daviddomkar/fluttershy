import 'package:dartex/component.dart';
import 'package:dartex/world.dart';
import 'package:fluttershy/foundation/transform.dart';

class TransformComponent with Component {
  Entity parent;
  Transform localTransform;
  Transform worldTransform;
}

import 'package:dartex/component.dart';
import 'package:dartex/world.dart';
import 'package:fluttershy/foundation/transform.dart';

class ParentComponent implements Component {
  Entity parent;
  Transform worldTransform;
}

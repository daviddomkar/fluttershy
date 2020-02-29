import 'package:fluttershy/foundation/position.dart';
import 'package:fluttershy/foundation/scale.dart';

class Transform {
  Position position;
  Scale scale;

  Transform(
      [Position position = const Position(), Scale scale = const Scale()]);
}

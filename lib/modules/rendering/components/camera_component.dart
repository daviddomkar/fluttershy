import 'package:dartex/component.dart';
import 'package:fluttershy/foundation/anchor.dart';
import 'package:fluttershy/foundation/size.dart';

class CameraComponent with Component {
  CameraComponent({this.size, this.anchor});

  Size size;
  Anchor anchor;
}

import 'package:dartex/component.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttershy/foundation/anchor.dart';
import 'package:fluttershy/foundation/size.dart';

class RectangleComponent with Component {
  RectangleComponent({this.size, this.color, this.anchor});

  Size size;
  Color color;
  Anchor anchor;
}

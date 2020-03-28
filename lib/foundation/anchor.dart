import 'package:fluttershy/foundation/copyable.dart';
import 'package:fluttershy/foundation/node.dart';

class LTRB {
  double left;
  double top;
  double right;
  double bottom;

  LTRB(this.left, this.top, this.right, this.bottom);
}

class Anchor with Copyable<Anchor> {
  final String name;
  const Anchor._(this.name);

  @override
  Anchor copy() {
    return this;
  }

  @override
  String toString() {
    return name;
  }

  static const Anchor topLeft = const Anchor._('TopLeft');
  static const Anchor topCenter = const Anchor._('TopCenter');
  static const Anchor topRight = const Anchor._('TopRight');
  static const Anchor centerLeft = const Anchor._('CenterLeft');
  static const Anchor center = const Anchor._('Center');
  static const Anchor centerRight = const Anchor._('CenterRight');
  static const Anchor bottomLeft = const Anchor._('BottomLeft');
  static const Anchor bottomCenter = const Anchor._('BottomCenter');
  static const Anchor bottomRight = const Anchor._('BottomRight');

  static computeLTRBfromLTWH(
      Anchor anchor, double x, double y, double width, double height) {
    switch (anchor) {
      case Anchor.topLeft:
        return LTRB(x, y, x + width, y + height);
      case Anchor.topCenter:
        return LTRB(x - width / 2, y, x + width / 2, y + height);
      case Anchor.topRight:
        return LTRB(x - width, y, x, y + height);
      case Anchor.centerLeft:
        return LTRB(x, y - height / 2, x + width, y + height / 2);
      case Anchor.center:
        return LTRB(
            x - width / 2, y - height / 2, x + width / 2, y + height / 2);
      case Anchor.centerRight:
        return LTRB(x - width, y - height / 2, x, y + height / 2);
      case Anchor.bottomLeft:
        return LTRB(x, y - height, x + width, y);
      case Anchor.bottomCenter:
        return LTRB(x - width / 2, y - height, x + width / 2, y);
      case Anchor.bottomRight:
        return LTRB(x - width, y - height, x, y);
    }
  }
}

mixin Anchorable on Node {
  Anchor anchor = Anchor.bottomLeft;
}

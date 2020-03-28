import 'package:fluttershy/foundation/copyable.dart';
import 'package:fluttershy/foundation/node.dart';

class Size with Copyable<Size> {
  double width;
  double height;

  Size(this.width, this.height);

  @override
  Size copy() {
    return Size(width, height);
  }

  @override
  Size copyWith({double width, double height}) {
    return Size(width ?? this.width, height ?? this.height);
  }

  static Size get zero => Size(0, 0);
}

mixin Sizable on Node {
  Size size = Size(0, 0);
}

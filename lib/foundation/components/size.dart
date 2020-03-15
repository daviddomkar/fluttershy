import 'package:dartex/dartex.dart';

class Size with Component<Size> {
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

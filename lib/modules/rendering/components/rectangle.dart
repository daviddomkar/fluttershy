import 'package:dartex/dartex.dart';
import 'package:flutter/widgets.dart' hide Size;
import 'package:fluttershy/foundation/size.dart';

class Rectangle with Component<Rectangle> {
  final Color color;
  final Size size;

  Rectangle({@required this.color, @required this.size});

  @override
  Rectangle copy() {
    return Rectangle(color: color, size: size);
  }

  @override
  Rectangle copyWith({Color color, Size size}) {
    return Rectangle(color: color ?? this.color, size: size ?? this.size);
  }
}

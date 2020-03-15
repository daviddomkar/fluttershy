import 'package:dartex/dartex.dart';
import 'package:flutter/widgets.dart';

class Rectangle with Component<Rectangle> {
  final Color color;

  Rectangle({@required this.color});

  @override
  Rectangle copy() {
    return Rectangle(color: color);
  }

  @override
  Rectangle copyWith({Color color}) {
    return Rectangle(color: color ?? this.color);
  }
}

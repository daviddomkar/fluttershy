import 'package:dartex/dartex.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttershy/foundation/size.dart';

class Camera with Component<Camera> {
  final Size size;

  Camera({@required this.size});

  @override
  Camera copy() {
    return Camera(size: size);
  }

  @override
  Camera copyWith({Size size}) {
    return Camera(size: size ?? this.size);
  }
}

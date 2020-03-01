import 'package:fluttershy/foundation/position.dart';
import 'package:fluttershy/foundation/scale.dart';

class Transform {
  Position position;
  Scale scale;

  Transform({Position position, Scale scale}) {
    this.position = position ?? Position.zero();
    this.scale = scale ?? Scale.zero();
  }

  Transform copyWith({Position position, Scale scale}) {
    return Transform(
      position: position ?? this.position.copyWith(),
      scale: scale ?? this.scale.copyWith(),
    );
  }
}

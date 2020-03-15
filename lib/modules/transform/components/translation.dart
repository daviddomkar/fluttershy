import 'package:dartex/dartex.dart';
import 'package:vector_math/vector_math.dart';

class Translation with Component<Translation> {
  final Vector3 vector;

  Translation(double x, double y, double z) : vector = Vector3(x, y, z);

  Translation.fromVector(Vector3 vector) : vector = vector.clone();

  static Translation get zero => Translation(0, 0, 0);

  @override
  Translation copy() {
    return Translation.fromVector(this.vector);
  }

  @override
  Translation copyWith({double x, double y, double z}) {
    return Translation(
        x ?? this.vector.x, y ?? this.vector.y, z ?? this.vector.z);
  }
}

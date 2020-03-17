import 'package:fluttershy/foundation/dirty.dart';
import 'package:vector_math/vector_math_64.dart';

class Translation extends Dirty<Translation> {
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

  set x(double value) {
    vector.x = value;
    markDirty();
  }

  set y(double value) {
    vector.y = value;
    markDirty();
  }

  set z(double value) {
    vector.z = value;
    markDirty();
  }

  double get x => vector.x;
  double get y => vector.y;
  double get z => vector.z;
}

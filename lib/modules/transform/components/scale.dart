import 'package:fluttershy/foundation/dirty.dart';
import 'package:vector_math/vector_math_64.dart';

class Scale extends Dirty<Scale> {
  final Vector3 vector;

  Scale(double x, double y, double z) : vector = Vector3(x, y, z);
  Scale.all(double all) : vector = Vector3.all(all);
  Scale.fromVector(Vector3 vector) : vector = vector.clone();

  @override
  Scale copy() {
    return Scale.fromVector(this.vector);
  }

  @override
  Scale copyWith({double x, double y, double z}) {
    return Scale(x ?? this.vector.x, y ?? this.vector.y, z ?? this.vector.z);
  }

  static Scale get normal => Scale(1, 1, 1);

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

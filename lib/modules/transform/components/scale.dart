import 'package:dartex/dartex.dart';
import 'package:vector_math/vector_math.dart';

class Scale with Component<Scale> {
  final Vector3 vector;

  Scale(double x, double y, double z) : vector = Vector3(x, y, z);

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
}

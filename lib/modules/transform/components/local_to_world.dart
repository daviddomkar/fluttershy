import 'package:dartex/dartex.dart';
import 'package:vector_math/vector_math_64.dart';

class LocalToWorld with Component<LocalToWorld> {
  Matrix4 matrix;

  LocalToWorld() : matrix = Matrix4.identity();
  LocalToWorld.fromMatrix4(Matrix4 matrix) : matrix = matrix;

  @override
  LocalToWorld copy() {
    return LocalToWorld.fromMatrix4(matrix);
  }
}

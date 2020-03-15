import 'package:dartex/dartex.dart';
import 'package:vector_math/vector_math.dart';

class Transform with Component<Transform> {
  final Matrix4 matrix;

  Transform() : matrix = Matrix4.identity();

  Transform.fromMatrix4(Matrix4 matrix) : matrix = matrix;

  @override
  Transform copy() {
    return Transform.fromMatrix4(matrix);
  }
}

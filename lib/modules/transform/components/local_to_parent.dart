import 'package:dartex/dartex.dart';
import 'package:vector_math/vector_math_64.dart';

class LocalToParent with Component<LocalToParent> {
  Matrix4 matrix;

  LocalToParent() : matrix = Matrix4.identity();
  LocalToParent.fromMatrix4(Matrix4 matrix) : matrix = matrix;

  @override
  LocalToParent copy() {
    return LocalToParent.fromMatrix4(matrix);
  }
}

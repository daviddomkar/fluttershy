import 'dart:ui';

import 'package:fluttershy/math.dart';

class Camera {
  Vector2 size;
  Vector2 originalSize;
  Vector2 position;
  Vector2 origin;
  double scale;

  Camera({
    Vector2? size,
    Vector2? position,
    Vector2? origin,
    this.scale = 1.0,
  })  : this.originalSize = size?.clone() ?? Vector2(double.infinity, 5.0),
        this.size = size ?? Vector2(double.infinity, 5.0),
        this.position = position ?? Vector2.zero(),
        this.origin = origin ?? Vector2.zero();

  void render(Canvas canvas, Vector2 position, Vector2 origin, double scale, Vector2 size, void Function(Canvas canvas) renderView) {
    canvas.save();

    canvas.transform(_computeProjection(position, origin, scale, size).storage);

    canvas.save();

    final innerProjection = _computeInnerProjection(size);

    canvas.clipRect(Rect.fromLTWH(0, 0, size.x, size.y));
    canvas.transform(innerProjection.storage);
    canvas.drawColor(const Color(0xFF000000), BlendMode.clear);

    canvas.save();

    renderView(canvas);

    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  Vector2 get scaledSize => size * scale;

  Vector2 _computeScale(Vector2 size, Vector2 targetSize) {
    if (size.x != double.infinity && size.y != double.infinity) {
      return Vector2(targetSize.x / size.x, targetSize.y / size.y);
    } else if (size.x == double.infinity && size.y != double.infinity) {
      return Vector2(targetSize.y / size.y, targetSize.y / size.y);
    } else if (size.x != double.infinity && size.y == double.infinity) {
      return Vector2(targetSize.x / size.x, targetSize.x / size.x);
    }

    return Vector2.all(1.0);
  }

  Matrix4 _computeProjection(Vector2 position, Vector2 origin, double scale, Vector2 size) {
    final transform = Matrix4.identity()
      ..setFromTranslationRotationScale(
        Vector3(position.x, position.y, 0.0),
        Quaternion.identity(),
        Vector3(scale, scale, 1.0),
      );

    transform.translate(-Vector3(origin.x * size.x, origin.y * size.y, 0.0));

    return transform;
  }

  Matrix4 _computeInnerProjection(Vector2 targetSize) {
    final transform = Matrix4.identity();

    final screenScale = _computeScale(size, targetSize);

    transform.scale(screenScale.x, screenScale.y);

    transform.multiply(Matrix4.inverted(_computeProjection(position, origin, scale, size)));

    return transform;
  }

  double get top => position.y - origin.y * scaledSize.y;
  double get left => position.x - origin.x * scaledSize.x;
  double get bottom => top + scaledSize.y;
  double get right => left + scaledSize.x;
}

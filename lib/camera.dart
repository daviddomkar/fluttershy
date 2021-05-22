import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttershy/math.dart';

class Camera {
  Vector2 size;
  Vector2 position;
  Vector2 origin;
  double scale;

  Camera({
    Vector2? size,
    Vector2? position,
    Vector2? origin,
    this.scale = 1.0,
  })  : this.size = size ?? Vector2(double.infinity, 5.0),
        this.position = position ?? Vector2.zero(),
        this.origin = origin ?? Vector2.zero();

  void render(Canvas canvas, Vector2 position, Vector2 origin, double scale, Vector2 size, void Function(Canvas canvas) renderView) {
    canvas.save();

    canvas.transform(_computeProjection(position, origin, scale).storage);

    canvas.save();

    final innerProjection = _computeInnerProjection(size);

    canvas.clipRect(Rect.fromLTWH(0, 0, size.x, size.y));
    canvas.transform(innerProjection.storage);
    canvas.drawColor(Colors.black, BlendMode.clear);

    canvas.save();

    renderView(canvas);

    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

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

  Matrix4 _computeProjection(Vector2 position, Vector2 origin, double scale) {
    final transform = Matrix4.identity()
      ..setFromTranslationRotationScale(
        Vector3(position.x, position.y, 0.0),
        Quaternion.identity(),
        Vector3(scale, scale, 1.0),
      );

    transform.translate(-Vector3(origin.x, origin.y, 0.0));

    return transform;
  }

  Matrix4 _computeInnerProjection(Vector2 targetSize) {
    final transform = Matrix4.identity();

    final screenScale = _computeScale(size, targetSize);

    transform.scale(screenScale.x, screenScale.y);

    transform.multiply(Matrix4.inverted(_computeProjection(position, origin, scale)));

    return transform;
  }
}
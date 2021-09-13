import 'dart:ui';

import 'package:fluttershy/fluttershy.dart';
import 'package:fluttershy/math.dart';

class Texture {
  Image image;

  late Vector2 position;
  late Vector2 size;
  late Vector2 trimOffset;
  late Vector2 trimSize;

  Texture.fromImage(
    this.image, {
    Vector2? position,
    Vector2? size,
    Vector2? trimOffset,
    Vector2? trimSize,
  }) {
    this.position = position ?? Vector2.zero();
    this.size = size ??
        Vector2(
          image.width.toDouble(),
          image.height.toDouble(),
        );
    this.trimOffset = trimOffset ?? Vector2.zero();
    this.trimSize = trimSize ??
        size ??
        Vector2(
          image.width.toDouble(),
          image.height.toDouble(),
        );
  }

  void render(Canvas canvas, Vector2 position, double rotation, double scale, ScalingMode scalingMode, Vector2? size, Paint paint) {
    size = size ?? this.size;

    size = computeRenderSize(scalingMode, size);

    final scaleX = trimSize.x / this.size.x;
    final scaleY = trimSize.y / this.size.y;

    final offsetX = trimOffset.x * (size.x / this.size.x) * scale;
    final offsetY = trimOffset.y * (size.y / this.size.y) * scale;

    canvas.save();

    canvas.translate(position.x, position.y);
    canvas.rotate(rotation);
    canvas.translate(-size.x * scale / 2.0, -size.y * scale / 2.0);

    canvas.drawImageRect(
      image,
      Rect.fromLTWH(this.position.x, this.position.y, this.trimSize.x, this.trimSize.y),
      Rect.fromLTWH(offsetX, offsetY, scaleX * size.x * scale, scaleY * size.y * scale),
      paint,
    );

    canvas.restore();
  }

  double computeRenderScale(ScalingMode mode, Vector2? size) {
    if (size == null) return 1.0;

    switch (mode) {
      case ScalingMode.containX:
        return size.x / this.size.x;
      case ScalingMode.containY:
        return size.y / this.size.y;
    }
  }

  Vector2 computeRenderSize(ScalingMode mode, Vector2 size) {
    switch (mode) {
      case ScalingMode.containX:
        return Vector2(size.x, size.x);
      case ScalingMode.containY:
        return Vector2(size.y, size.y);
    }
  }

  Rect get rect => Rect.fromLTWH(position.x, position.y, trimSize.x, trimSize.y);
}

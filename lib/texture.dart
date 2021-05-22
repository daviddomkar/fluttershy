import 'dart:ui';

import 'package:fluttershy/fluttershy.dart';
import 'package:fluttershy/math.dart';

class Texture {
  final Image image;

  late final Vector2 _position;
  late final Vector2 _size;
  late final Vector2 _trimOffset;
  late final Vector2 _trimSize;

  late final Rect rect;

  Texture.fromImage(
    this.image, {
    Vector2? position,
    Vector2? size,
    Vector2? trimOffset,
    Vector2? trimSize,
  }) {
    _position = position ?? Vector2.zero();
    _size = size ??
        Vector2(
          image.width.toDouble(),
          image.height.toDouble(),
        );
    _trimOffset = trimOffset ?? Vector2.zero();
    _trimSize = trimSize ??
        size ??
        Vector2(
          image.width.toDouble(),
          image.height.toDouble(),
        );

    rect = Rect.fromLTWH(_position.x, _position.y, _trimSize.x, _trimSize.y);
  }

  void render(Canvas canvas, Vector2 position, double rotation, double scale, ScalingMode scalingMode, Vector2? size, Paint paint) {
    size = size ?? _size;

    final _scale = computeRenderScale(scalingMode, _trimSize);

    final offsetX = _trimOffset.x * _scale;
    final offsetY = _trimOffset.y * _scale;

    size = computeRenderSize(scalingMode, size);

    canvas.save();

    canvas.translate(position.x, position.y);
    canvas.rotate(rotation);
    canvas.translate(-size.x / 2.0, -size.y / 2.0);

    canvas.drawImageRect(
      image,
      Rect.fromLTWH(_position.x, _position.y, _trimSize.x, _trimSize.y),
      Rect.fromLTWH(offsetX, offsetY, _scale * size.x * scale, _scale * size.y * scale),
      paint,
    );

    canvas.restore();
  }

  double computeRenderOffsetX(double? width) => width == null ? _trimOffset.x : _trimOffset.x * (width / _size.x);
  double computeRenderOffsetY(double? height) => height == null ? _trimOffset.y : _trimOffset.y * (height / _size.y);

  double computeRenderScale(ScalingMode mode, Vector2? size) {
    if (size == null) return 1.0;

    switch (mode) {
      case ScalingMode.containX:
        return size.x / _size.x;
      case ScalingMode.containY:
        return size.y / _size.y;
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

  Vector2 get size => _size;
}

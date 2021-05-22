import 'dart:ui';

import 'package:flutter/material.dart' hide Texture;
import 'package:fluttershy/math.dart';

import 'texture.dart';

enum ScalingMode {
  containX,
  containY,
}

class Sprite {
  final Paint _paint = Paint();

  final Texture texture;

  final ScalingMode _scalingMode;

  Vector2 _position;
  double _rotation;
  double _scale;
  Vector2? _size;

  RSTransform? _transform;
  bool _dirty;

  Sprite({
    required this.texture,
    ScalingMode scalingMode = ScalingMode.containX,
    Vector2? position,
    double? rotation,
    double? scale,
    Vector2? size,
  })  : _scalingMode = scalingMode,
        _position = position ?? Vector2.all(0.0),
        _rotation = rotation ?? 0.0,
        _scale = scale ?? 1.0,
        _size = size,
        _dirty = true;

  void render(Canvas canvas) {
    texture.render(canvas, _position, _rotation, _scale, _scalingMode, _size, _paint);
  }

  set position(Vector2 position) {
    _position = position;
    _dirty = true;
  }

  set rotation(double rotation) {
    _rotation = rotation;
    _dirty = true;
  }

  set scale(double scale) {
    _scale = scale;
    _dirty = true;
  }

  set size(Vector2 _size) {
    _size = position;
    _dirty = true;
  }

  Vector2 get position => _position;
  double get rotation => _rotation;
  double get scale => _scale;

  RSTransform get transform {
    if (_dirty) {
      final offsetX = texture.computeRenderOffsetX(_size?.x);
      final offsetY = texture.computeRenderOffsetY(_size?.y);

      final scale = texture.computeRenderScale(_scalingMode, _size);

      _transform = RSTransform.fromComponents(
        rotation: _rotation,
        scale: scale * _scale,
        anchorX: texture.size.x / 2.0,
        anchorY: texture.size.y / 2.0,
        translateX: _position.x + offsetX,
        translateY: _position.y + offsetY,
      );

      _dirty = false;
    }

    return _transform!;
  }

  double get scos => transform.scos;
  double get ssin => transform.ssin;
  double get tx => transform.tx;
  double get ty => transform.ty;
}

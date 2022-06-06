import 'dart:ui';

import 'package:flutter/material.dart' hide Texture;
import 'package:fluttershy/math.dart';

import 'texture.dart';

enum ScalingMode {
  containX,
  containY,
}

class Sprite {
  final Paint _paint;

  final Texture texture;

  final ScalingMode _scalingMode;

  Vector2 _position;
  double _rotation;
  double _scale;
  Vector2? _size;

  Color _color;

  RSTransform? _transform;
  bool _dirty;

  Sprite({
    required this.texture,
    ScalingMode scalingMode = ScalingMode.containX,
    Vector2? position,
    double? rotation,
    double? scale,
    Vector2? size,
    Color? color,
  })  : _paint = Paint()..color = color ?? Colors.white,
        _color = color ?? Colors.white,
        _scalingMode = scalingMode,
        _position = position ?? Vector2.all(0.0),
        _rotation = rotation ?? 0.0,
        _scale = scale ?? 1.0,
        _size = size,
        _dirty = true;

  void render(Canvas canvas) {
    texture.render(
        canvas, _position, _rotation, _scale, _scalingMode, _size, _paint);
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

  set size(Vector2 size) {
    _size = size;
    _dirty = true;
  }

  // ignore: unnecessary_getters_setters
  set color(Color color) {
    _color = color;
  }

  Vector2 get position => _position;
  double get rotation => _rotation;
  double get scale => _scale;

  RSTransform get transform {
    if (_dirty) {
      _transform = RSTransform.fromComponents(
        rotation: _rotation,
        scale: texture.computeRenderScale(_scalingMode, _size) * _scale,
        anchorX: -texture.trimOffset.x + texture.size.x / 2.0,
        anchorY: -texture.trimOffset.y + texture.size.y / 2.0,
        translateX: _position.x,
        translateY: _position.y,
      );

      _dirty = false;
    }

    return _transform!;
  }

  double get scos => transform.scos;
  double get ssin => transform.ssin;
  double get tx => transform.tx;
  double get ty => transform.ty;

  Vector2 get size => _size ?? texture.size;
  Vector2 get scaledSize => (_size ?? texture.size) * scale;

  // ignore: unnecessary_getters_setters
  Color get color => _color;
}

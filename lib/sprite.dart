import 'dart:ui';

import 'package:flutter/material.dart' hide Texture;
import 'package:fluttershy/math.dart';

import 'texture.dart';

class Sprite {
  final Paint _paint = Paint();

  final Texture texture;

  final Vector2 srcPosition;
  final Vector2 srcSize;

  final Vector2 _position;
  final Vector2 _size;

  final Vector2 _spriteSrcSize;
  final Vector2 _spriteSrcSizeOffset;

  Sprite({
    required this.texture,
    required this.srcPosition,
    required this.srcSize,
    Vector2? position,
    Vector2? size,
    Vector2? spriteSrcSize,
    Vector2? spriteSrcSizeOffset,
  })  : _position = position ?? Vector2.all(0.0),
        _size = size ?? Vector2.all(100.0),
        _spriteSrcSize = spriteSrcSize ?? srcSize,
        _spriteSrcSizeOffset = spriteSrcSizeOffset ?? Vector2.zero();

  void render(Canvas canvas) {
    final scaleX = _spriteSrcSize.x / srcSize.x;
    final scaleY = _spriteSrcSize.y / srcSize.y;

    final offsetX = _spriteSrcSizeOffset.x * (_size.x / srcSize.x);
    final offsetY = _spriteSrcSizeOffset.y * (_size.y / srcSize.y);

    canvas.drawImageRect(
      texture.image,
      Rect.fromLTWH(srcPosition.x, srcPosition.y, _spriteSrcSize.x, _spriteSrcSize.y),
      Rect.fromLTWH(_position.x + offsetX, _position.y + offsetY, scaleX * _size.x, scaleY * _size.y),
      _paint,
    );
  }

  Vector2 get position => _position;
  Vector2 get size => _size;
  Vector2 get spriteSrcSize => _spriteSrcSize;
  Vector2 get spriteSrcSizeOffset => _spriteSrcSizeOffset;

  RSTransform get transform {
    final offsetX = _spriteSrcSizeOffset.x * (_size.x / srcSize.x);
    final offsetY = _spriteSrcSizeOffset.y * (_size.y / srcSize.y);

    return RSTransform.fromComponents(
      rotation: 0.0,
      scale: (_size.x / srcSize.x),
      anchorX: 0.0,
      anchorY: 0.0,
      translateX: _position.x + offsetX,
      translateY: _position.y + offsetY,
    );
  }

  Rect get rect => Rect.fromLTWH(srcPosition.x, srcPosition.y, _spriteSrcSize.x, _spriteSrcSize.y);
}

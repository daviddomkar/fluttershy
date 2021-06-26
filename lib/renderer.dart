import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart' hide Texture, Image;

import 'sprite.dart';
import 'texture.dart';

class Renderer {
  static const maxBatchedObjects = 2000;

  Canvas? _canvas;

  int index = 0;

  final Paint paint = Paint()..filterQuality = FilterQuality.low;

  Image? image;

  final _rawTransforms = Float32List(maxBatchedObjects * 4);
  final _rawSources = Float32List(maxBatchedObjects * 4);
  final _rawColors = Int32List(maxBatchedObjects);

  void begin(Canvas canvas) {
    _canvas = canvas;
  }

  void end() {
    _flush(_canvas);
  }

  void render(void Function(Canvas canvas, Paint defaultPaint) renderCommand) {
    if (_canvas == null) return;

    end();
    renderCommand(_canvas!, paint);
    begin(_canvas!);
  }

  void renderImage(Image image, double left, double top, double right, double bottom, double scos, double ssin, double tx, double ty, [Color? color]) {
    if (this.image != image || index >= maxBatchedObjects) {
      _flush(_canvas);
    }

    this.image = image;

    final int index0 = index * 4;
    final int index1 = index0 + 1;
    final int index2 = index0 + 2;
    final int index3 = index0 + 3;

    _rawTransforms[index0] = scos;
    _rawTransforms[index1] = ssin;
    _rawTransforms[index2] = tx;
    _rawTransforms[index3] = ty;

    _rawSources[index0] = left;
    _rawSources[index1] = top;
    _rawSources[index2] = right;
    _rawSources[index3] = bottom;

    _rawColors[index] = color?.value ?? Colors.white.value;

    index++;
  }

  void renderTexture(Texture texture, double scos, double ssin, double tx, double ty, [Color? color]) {
    final rect = texture.rect;

    renderImage(texture.image, rect.left, rect.top, rect.right, rect.bottom, scos, ssin, tx, ty, color);
  }

  void renderSprite(Sprite sprite) => renderTexture(sprite.texture, sprite.scos, sprite.ssin, sprite.tx, sprite.ty, sprite.color);

  void _flush(Canvas? canvas) {
    if (image == null || canvas == null || index == 0) return;

    _canvas!.drawRawAtlas(image!, _rawTransforms, _rawSources, _rawColors, BlendMode.modulate, null, paint);

    _rawTransforms.fillRange(0, _rawTransforms.length, 0.0);
    _rawSources.fillRange(0, _rawSources.length, 0.0);
    _rawColors.fillRange(0, _rawColors.length, Colors.white.value);

    index = 0;
  }
}

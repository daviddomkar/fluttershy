import 'dart:typed_data';
import 'dart:ui';

import 'sprite.dart';

class SpriteBatch {
  static const maxSprites = 4000;

  Canvas? _canvas;

  int index = 0;

  final Paint paint = Paint();

  Image? image;

  final _rawTransforms = Float32List(maxSprites * 4);
  final _rawSources = Float32List(maxSprites * 4);

  void begin(Canvas canvas) {
    _canvas = canvas;
  }

  void end() {
    _flush(_canvas);
  }

  void render(Sprite sprite) {
    if (sprite.texture.image != image || index >= maxSprites) {
      _flush(_canvas);
    }

    image = sprite.texture.image;

    final rect = sprite.texture.rect;

    final int index0 = index * 4;
    final int index1 = index0 + 1;
    final int index2 = index0 + 2;
    final int index3 = index0 + 3;

    _rawTransforms[index0] = sprite.scos;
    _rawTransforms[index1] = sprite.ssin;
    _rawTransforms[index2] = sprite.tx;
    _rawTransforms[index3] = sprite.ty;

    _rawSources[index0] = rect.left;
    _rawSources[index1] = rect.top;
    _rawSources[index2] = rect.right;
    _rawSources[index3] = rect.bottom;

    index++;
  }

  void _flush(Canvas? canvas) {
    if (image == null || canvas == null) return;

    _canvas!.drawRawAtlas(image!, _rawTransforms, _rawSources, null, null, null, paint);

    _rawTransforms.fillRange(0, _rawTransforms.length, 0.0);
    _rawSources.fillRange(0, _rawSources.length, 0.0);

    index = 0;
  }
}

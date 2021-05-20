import 'dart:typed_data';
import 'dart:ui';

import 'texture.dart';
import 'sprite.dart';

class SpriteBatch {
  static const maxSprites = 4000;

  int index = 0;

  final Paint paint = Paint();

  Texture? texture;

  final _rawTransforms = Float32List(maxSprites * 4);
  final _rawSources = Float32List(maxSprites * 4);

  void render(Canvas canvas, Sprite sprite) {
    if (sprite.texture != texture || index >= maxSprites) {
      flush(canvas);
    }

    texture = sprite.texture;

    final rect = sprite.rect;

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

  void flush(Canvas canvas) {
    if (texture == null) return;

    canvas.drawRawAtlas(texture!.image, _rawTransforms, _rawSources, null, null, null, paint);

    _rawTransforms.fillRange(0, _rawTransforms.length, 0.0);
    _rawSources.fillRange(0, _rawSources.length, 0.0);

    index = 0;
  }
}

import 'dart:ui';

import 'texture.dart';
import 'sprite.dart';

class SpriteBatch {
  final maxSprites = 5000;

  int index = 0;

  final Paint paint = Paint();

  Texture? texture;

  final _transforms = <RSTransform>[];
  final _sources = <Rect>[];

  void render(Canvas canvas, Sprite sprite) {
    if (sprite.texture != texture || index >= maxSprites) {
      flush(canvas);
    }

    texture = sprite.texture;

    _transforms.add(sprite.transform);
    _sources.add(sprite.rect);

    index++;
  }

  void flush(Canvas canvas) {
    if (texture == null) return;

    canvas.drawAtlas(texture!.image, _transforms, _sources, null, null, null, paint);

    _transforms.clear();
    _sources.clear();

    index = 0;
  }
}

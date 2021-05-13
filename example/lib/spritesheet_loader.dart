import 'dart:collection';
import 'dart:ui';

import 'package:fluttershy/math.dart';
import 'package:fluttershy/fluttershy.dart';

class SpriteSheetLoader {
  static Map<String, Sprite> loadSpriteSheet(Image spriteSheetImage, Map<String, dynamic> spriteSheetData) {
    final frames = spriteSheetData['frames'] as List<dynamic>;

    final spriteMap = HashMap<String, Sprite>();

    final texture = Texture.fromImage(spriteSheetImage);

    frames.forEach((frame) {
      spriteMap[frame['filename'] as String] = Sprite(
        texture: texture,
        srcPosition: Vector2(
          (frame['frame']['x'] as int).toDouble(),
          (frame['frame']['y'] as int).toDouble(),
        ),
        srcSize: Vector2(
          (frame['sourceSize']['w'] as int).toDouble(),
          (frame['sourceSize']['h'] as int).toDouble(),
        ),
        spriteSrcSize: Vector2(
          (frame['spriteSourceSize']['w'] as int).toDouble(),
          (frame['spriteSourceSize']['h'] as int).toDouble(),
        ),
        spriteSrcSizeOffset: Vector2(
          (frame['spriteSourceSize']['x'] as int).toDouble(),
          (frame['spriteSourceSize']['y'] as int).toDouble(),
        ),
      );
    });

    return spriteMap;
  }
}

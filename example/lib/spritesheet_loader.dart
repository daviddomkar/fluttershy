import 'dart:collection';
import 'dart:ui';

import 'package:fluttershy/math.dart';
import 'package:fluttershy/fluttershy.dart';

class SpriteSheetLoader {
  static Map<String, Texture> loadSpriteSheet(Image spriteSheetImage, Map<String, dynamic> spriteSheetData) {
    final frames = spriteSheetData['frames'] as List<dynamic>;

    final spriteMap = HashMap<String, Texture>();

    frames.forEach((frame) {
      spriteMap[frame['filename'] as String] = Texture.fromImage(
        spriteSheetImage,
        position: Vector2(
          (frame['frame']['x'] as int).toDouble(),
          (frame['frame']['y'] as int).toDouble(),
        ),
        size: Vector2(
          (frame['sourceSize']['w'] as int).toDouble(),
          (frame['sourceSize']['h'] as int).toDouble(),
        ),
        trimOffset: Vector2(
          (frame['spriteSourceSize']['x'] as int).toDouble(),
          (frame['spriteSourceSize']['y'] as int).toDouble(),
        ),
        trimSize: Vector2(
          (frame['spriteSourceSize']['w'] as int).toDouble(),
          (frame['spriteSourceSize']['h'] as int).toDouble(),
        ),
      );
    });

    return spriteMap;
  }
}

import 'dart:collection';
import 'dart:ui';

import 'package:fluttershy/math.dart';
import 'package:fluttershy/fluttershy.dart';

class TextureAtlasLoader {
  static Map<String, Texture> loadTextureAtlas(Image textureAtlasImage, Map<String, dynamic> textureAtlasData) {
    final frames = textureAtlasData['frames'] as List<dynamic>;

    final textureMap = HashMap<String, Texture>();

    frames.forEach((frame) {
      textureMap[frame['filename'] as String] = Texture.fromImage(
        textureAtlasImage,
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

    return textureMap;
  }
}

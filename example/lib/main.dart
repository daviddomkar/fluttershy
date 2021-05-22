import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart' hide State, Transform, Size, PointerMoveEvent, Image;
import 'package:flutter/services.dart';
import 'package:fluttershy/fluttershy.dart';
import 'package:fluttershy/math.dart';
import 'package:fluttershy_example/spritesheet_loader.dart';

Future<Image> _loadTilesSpriteSheetImage() async {
  final data = await rootBundle.load('assets/tiles.png');
  final bytes = Uint8List.view(data.buffer);

  return decodeImageFromList(bytes);
}

Future<Map<String, dynamic>> _loadTilesSpriteSheetData() async {
  final data = await rootBundle.loadString('assets/tiles.json');
  return jsonDecode(data) as Map<String, dynamic>;
}

enum TileType { water, grass }
enum TilePiece { topLeft, top, topRight, centerLeft, center, centerRight, bottomLeft, bottom, bottomRight }

class TileManager {
  final List<Sprite> _sprites;

  final SpriteBatch _spriteBatch;

  TileManager.fromSpriteSheet(Image spriteSheetImage, Map<String, dynamic> spriteSheetData)
      : _sprites = [],
        _spriteBatch = SpriteBatch() {
    final sprites = SpriteSheetLoader.loadSpriteSheet(spriteSheetImage, spriteSheetData);

    final sprite = sprites.values.toList()[2];

    for (var i = 0; i < 20; i++) {
      for (var j = 0; j < 9 * 16; j++) {
        _sprites.add(Sprite(
          texture: sprite,
          rotation: 0.0,
          scalingMode: ScalingMode.containY,
          position: Vector2(j * 1.0, i * 1.0),
          size: Vector2(1.0, 0.5),
        ));
      }
    }
  }

  void update(double deltaTime) {
    _sprites.forEach((sprite) => sprite.rotation += deltaTime * 2.0);
  }

  void render(Canvas canvas) {
    _sprites.forEach((sprite) => sprite.render(canvas));
  }

  void renderSpriteBatch(Canvas canvas) {
    _sprites.forEach((sprite) => _spriteBatch.render(canvas, sprite));
    _spriteBatch.flush(canvas);
  }

  void getTileCenterSprite() {}
  void getTileEdgeSprite() {}
  void getTileCornerSprite() {}
  void getTileInnerSprite() {}
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final tilesData = await _loadTilesSpriteSheetData();
  final tilesImage = await _loadTilesSpriteSheetImage();

  final tileManager = TileManager.fromSpriteSheet(tilesImage, tilesData);

  runApp(MyApp(tileManager: tileManager));
}

class MyApp extends StatelessWidget {
  final TileManager tileManager;

  MyApp({Key? key, required this.tileManager}) : super(key: key);

  @override
  Widget build(BuildContext _context) {
    return MaterialApp(
      showPerformanceOverlay: true,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Container(
          child: Fluttershy(
            update: (deltaTime) {
              tileManager.update(deltaTime);
            },
            render: (canvas) {
              tileManager.render(canvas);
            },
          ),
        ),
      ),
    );
  }
}

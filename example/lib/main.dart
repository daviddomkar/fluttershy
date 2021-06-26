import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart' hide State, Transform, Size, PointerMoveEvent, Image, Texture;
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
enum TilePiece { center, edge, corner, inner }
enum TileEdge { top, bottom, left, right }
enum TileCorner { topLeft, topRight, bottomLeft, bottomRight }
enum TileInner { topLeft, topRight, bottomLeft, bottomRight }

class TileAtlas {
  final List<Sprite> _sprites;

  final Renderer _spriteBatch;

  final HashMap<TileType, List<Texture>> _tileCenterPiecesTextures;
  final HashMap<TileType, HashMap<TileType, HashMap<TileEdge, List<Texture>>>> _tileEdgePiecesTextures;
  final HashMap<TileType, HashMap<TileType, HashMap<TileCorner, List<Texture>>>> _tileCornerPiecesTextures;
  final HashMap<TileType, HashMap<TileType, HashMap<TileInner, List<Texture>>>> _tileInnerPiecesTextures;

  TileAtlas.fromTextureAtlas(Image textureAtlasImage, Map<String, dynamic> textureAtlasData)
      : _tileCenterPiecesTextures = HashMap(),
        _tileEdgePiecesTextures = HashMap(),
        _tileCornerPiecesTextures = HashMap(),
        _tileInnerPiecesTextures = HashMap(),
        _sprites = [],
        _spriteBatch = Renderer() {
    final textureEntries = TextureAtlasLoader.loadTextureAtlas(textureAtlasImage, textureAtlasData).entries.toList();

    for (var i = 0; i < textureEntries.length; i++) {
      final textureEntry = textureEntries[i];

      final name = textureEntry.key;
      final texture = textureEntry.value;

      final parts = name.split('_');

      final tileType = _getTileType(parts[0]);

      if (tileType == null) continue;

      final tilePiece = _getTilePiece(parts[1]);

      if (tilePiece == null) continue;

      switch (tilePiece) {
        case TilePiece.center:
          if (!_tileCenterPiecesTextures.containsKey(tileType)) {
            _tileCenterPiecesTextures[tileType] = [];
          }

          _tileCenterPiecesTextures[tileType]!.add(texture);

          break;
        case TilePiece.edge:
          final opossingTileType = _getTileType(parts[2]);

          if (opossingTileType == null) continue;

          final edge = _getTileEdge(parts[3]);

          if (edge == null) continue;

          if (!_tileEdgePiecesTextures.containsKey(tileType)) {
            _tileEdgePiecesTextures[tileType] = HashMap();
          }

          if (!_tileEdgePiecesTextures[tileType]!.containsKey(opossingTileType)) {
            _tileEdgePiecesTextures[tileType]![opossingTileType] = HashMap();
          }

          if (!_tileEdgePiecesTextures[tileType]![opossingTileType]!.containsKey(edge)) {
            _tileEdgePiecesTextures[tileType]![opossingTileType]![edge] = [];
          }

          _tileEdgePiecesTextures[tileType]![opossingTileType]![edge]!.add(texture);

          break;
        case TilePiece.corner:
          final opossingTileType = _getTileType(parts[2]);

          if (opossingTileType == null) continue;

          final corner = _getTileCorner(parts[3]);

          if (corner == null) continue;

          if (!_tileCornerPiecesTextures.containsKey(tileType)) {
            _tileCornerPiecesTextures[tileType] = HashMap();
          }

          if (!_tileCornerPiecesTextures[tileType]!.containsKey(opossingTileType)) {
            _tileCornerPiecesTextures[tileType]![opossingTileType] = HashMap();
          }

          if (!_tileCornerPiecesTextures[tileType]![opossingTileType]!.containsKey(corner)) {
            _tileCornerPiecesTextures[tileType]![opossingTileType]![corner] = [];
          }

          _tileCornerPiecesTextures[tileType]![opossingTileType]![corner]!.add(texture);

          break;
        case TilePiece.inner:
          final opossingTileType = _getTileType(parts[2]);

          if (opossingTileType == null) continue;

          final inner = _getTileInner(parts[3]);

          if (inner == null) continue;

          if (!_tileInnerPiecesTextures.containsKey(tileType)) {
            _tileInnerPiecesTextures[tileType] = HashMap();
          }

          if (!_tileInnerPiecesTextures[tileType]!.containsKey(opossingTileType)) {
            _tileInnerPiecesTextures[tileType]![opossingTileType] = HashMap();
          }

          if (!_tileInnerPiecesTextures[tileType]![opossingTileType]!.containsKey(inner)) {
            _tileInnerPiecesTextures[tileType]![opossingTileType]![inner] = [];
          }

          _tileInnerPiecesTextures[tileType]![opossingTileType]![inner]!.add(texture);

          break;
      }
    }

    for (var i = 0; i < 20; i++) {
      for (var j = 0; j < 9 * 16; j++) {
        _sprites.add(Sprite(
          texture: _tileCenterPiecesTextures[TileType.water]![0],
          position: Vector2(j * 3.0, i * 3.0),
          scale: 1.0,
          size: Vector2(1.0, 1.0),
        ));
      }
    }
  }

  TileType? _getTileType(String? type) {
    switch (type) {
      case 'grass':
        return TileType.grass;
      case 'water':
        return TileType.water;
    }
  }

  TilePiece? _getTilePiece(String? piece) {
    switch (piece) {
      case 'center':
        return TilePiece.center;
      case 'edge':
        return TilePiece.edge;
      case 'corner':
        return TilePiece.corner;
      case 'inner':
        return TilePiece.inner;
    }
  }

  TileEdge? _getTileEdge(String? edge) {
    switch (edge) {
      case 'top':
        return TileEdge.top;
      case 'bottom':
        return TileEdge.bottom;
      case 'left':
        return TileEdge.left;
      case 'right':
        return TileEdge.right;
    }
  }

  TileCorner? _getTileCorner(String? corner) {
    switch (corner) {
      case 'top-left':
        return TileCorner.topLeft;
      case 'top-right':
        return TileCorner.topRight;
      case 'bottom-left':
        return TileCorner.bottomLeft;
      case 'bottom-right':
        return TileCorner.bottomRight;
    }
  }

  TileInner? _getTileInner(String? inner) {
    switch (inner) {
      case 'top-left':
        return TileInner.topLeft;
      case 'top-right':
        return TileInner.topRight;
      case 'bottom-left':
        return TileInner.bottomLeft;
      case 'bottom-right':
        return TileInner.bottomRight;
    }
  }

  void update(double deltaTime) {
    _sprites.forEach((sprite) => sprite.rotation += deltaTime * 2.0);
  }

  void render(Canvas canvas) {
    _sprites.forEach((sprite) => sprite.render(canvas));
  }

  void renderSpriteBatch(Canvas canvas) {
    _spriteBatch.begin(canvas);
    _sprites.forEach((sprite) => _spriteBatch.renderSprite(sprite));
    _spriteBatch.end();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final tilesData = await _loadTilesSpriteSheetData();
  final tilesImage = await _loadTilesSpriteSheetImage();

  final tileManager = TileAtlas.fromTextureAtlas(tilesImage, tilesData);

  runApp(MyApp(tileManager: tileManager));
}

class MyApp extends StatelessWidget {
  final TileAtlas tileManager;

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
            camera: Camera(
              position: Vector2(0.0, 0.0),
              scale: 1.0,
            ),
            update: (deltaTime) {
              tileManager.update(deltaTime);
            },
            render: (canvas) {
              tileManager.renderSpriteBatch(canvas);
            },
          ),
        ),
      ),
    );
  }
}

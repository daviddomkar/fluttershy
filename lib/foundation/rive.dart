import 'dart:ui';

import 'package:flare_flutter/flare.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttershy/foundation/anchor.dart';
import 'package:fluttershy/foundation/asset_bundle.dart';
import 'package:fluttershy/foundation/node.dart';
import 'package:fluttershy/foundation/size.dart';

class Rive extends Node with Sizable, Anchorable {
  final String fileName;

  AssetBundle assetBundle;

  FlutterActorArtboard artboard;
  Picture picture;

  bool loading;
  bool loaded;

  Rive({this.fileName, Size size, Anchor anchor})
      : loading = false,
        loaded = false {
    this.size = size;
    this.anchor = anchor;
  }

  @override
  void onAttach() {
    assetBundle = root.getResource<AssetBundle>();

    load();
  }

  Future<void> load() async {
    if (loading || loaded) {
      return;
    }

    loading = true;

    final actor = FlutterActor();
    await actor.loadFromBundle(assetBundle.bundle, fileName);
    await actor.loadImages();

    artboard = actor.artboard.makeInstance();
    artboard.makeInstance();
    artboard.initializeGraphics();
    artboard.advance(0.0);

    loading = false;
    loaded = true;
  }

  @override
  void onUpdate(double deltaTime) {
    if (loaded && picture == null) {
      final translation = worldTransform.getTranslation();

      final r = PictureRecorder();
      final c = Canvas(r);

      final scaleX = size.width / artboard.width * worldTransform.getRow(0).x;
      final scaleY = size.height / artboard.height * worldTransform.getRow(1).y;

      c.scale(scaleX, scaleY);

      switch (anchor) {
        case Anchor.topLeft:
          c.translate(
            1 / scaleX * translation.x,
            1 / scaleY * translation.y,
          );
          break;
        case Anchor.topCenter:
          c.translate(
            1 / scaleX * translation.x - artboard.width / 2,
            1 / scaleY * translation.y,
          );
          break;
        case Anchor.topRight:
          c.translate(
            1 / scaleX * translation.x - artboard.width,
            1 / scaleY * translation.y,
          );
          break;
        case Anchor.centerLeft:
          c.translate(
            1 / scaleX * translation.x,
            1 / scaleY * translation.y - artboard.height / 2,
          );
          break;
        case Anchor.center:
          c.translate(
            1 / scaleX * translation.x - artboard.width / 2,
            1 / scaleY * translation.y - artboard.height / 2,
          );
          break;
        case Anchor.centerRight:
          c.translate(
            1 / scaleX * translation.x - artboard.width,
            1 / scaleY * translation.y - artboard.height / 2,
          );
          break;
        case Anchor.bottomLeft:
          c.translate(
            1 / scaleX * translation.x,
            1 / scaleY * translation.y - artboard.height,
          );
          break;
        case Anchor.bottomCenter:
          c.translate(
            1 / scaleX * translation.x - artboard.width / 2,
            1 / scaleY * translation.y - artboard.height,
          );
          break;
        case Anchor.bottomRight:
          c.translate(
            1 / scaleX * translation.x - artboard.width,
            1 / scaleY * translation.y - artboard.height,
          );
          break;
      }

      artboard.draw(c);

      picture = r.endRecording();
    }
  }

  @override
  void onRender(Canvas canvas) {
    if (picture != null) {
      canvas.drawPicture(picture);
    }
  }
}

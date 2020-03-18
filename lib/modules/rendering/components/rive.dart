import 'dart:ui' hide Size;

import 'package:dartex/dartex.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:fluttershy/foundation/size.dart';

class Rive with Component<Rive> {
  final String fileName;
  final Size size;

  FlutterActorArtboard artboard;
  Picture picture;

  bool loading;
  bool loaded;

  Rive({@required this.fileName, @required this.size})
      : loaded = false,
        loading = false;

  Future<void> load(AssetBundle bundle) async {
    if (loading || loaded) {
      return;
    }

    loading = true;

    final actor = FlutterActor();
    await actor.loadFromBundle(bundle, fileName);
    await actor.loadImages();

    artboard = actor.artboard.makeInstance();
    artboard.makeInstance();
    artboard.initializeGraphics();
    artboard.advance(0.0);

    loading = false;
    loaded = true;
  }

  @override
  Rive copy() {
    return Rive(fileName: this.fileName, size: this.size);
  }
}

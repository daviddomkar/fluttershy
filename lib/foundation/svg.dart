import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:fluttershy/foundation/anchor.dart';
import 'package:fluttershy/foundation/node.dart';
import 'package:fluttershy/foundation/size.dart';
import 'package:flutter/services.dart' show rootBundle;

class Svg extends Node with Sizable, Anchorable {
  final String fileName;

  DrawableRoot svgRoot;

  bool loading;
  bool loaded;

  Svg({this.fileName, Size size, Anchor anchor})
      : loading = false,
        loaded = false {
    this.size = size;
    this.anchor = anchor;
  }

  @override
  void onAttach() {
    load();
  }

  Future<void> load() async {
    if (loading || loaded) {
      return;
    }

    loading = true;

    final string = await rootBundle.loadString(fileName);
    svgRoot = await svg.fromSvgString(string, string);

    loading = false;
    loaded = true;
  }

  @override
  void onRender(Canvas canvas) {
    if (loaded) {
      final translation = worldTransform.getTranslation();

      canvas.save();
      canvas.translate(translation.x, translation.y);
      svgRoot.scaleCanvasToViewBox(
          canvas, flutter.Size(size.width, size.height));
      svgRoot.draw(canvas, null);
      canvas.restore();
    }
  }
}

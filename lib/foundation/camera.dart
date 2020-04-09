import 'package:flutter/rendering.dart';
import 'package:fluttershy/foundation/anchor.dart';
import 'package:fluttershy/foundation/node.dart';
import 'package:fluttershy/foundation/screen_dimensions.dart';
import 'package:fluttershy/foundation/size.dart';

class Camera extends Node with Sizable, Anchorable {
  ScreenDimensions screenDimensions;

  Camera({Size size, Anchor anchor}) {
    this.size = size;
    this.anchor = anchor;
  }

  @override
  void onAttach() {
    screenDimensions = root.getResource<ScreenDimensions>();
  }

  @override
  void onRender(Canvas canvas) {
    final transform = this.worldTransform.clone();
    final screenSize = screenDimensions.size;
    final size = this.size.copy();

    transform.invert();

    var scaleX = 1.0;
    var scaleY = 1.0;

    if (size.width == double.infinity && size.height != double.infinity) {
      scaleX = screenSize.height / size.height;
      scaleY = screenSize.height / size.height;
      size.width = screenSize.width * (1 / scaleX);
    } else if (size.width != double.infinity &&
        size.height == double.infinity) {
      scaleX = screenSize.width / size.width;
      scaleY = screenSize.width / size.width;
      size.height = screenSize.height * (1 / scaleY);
    } else if (size.width != double.infinity &&
        size.height != double.infinity) {
      scaleX = screenSize.width / size.width;
      scaleY = screenSize.height / size.height;
    } else {
      size.width = screenSize.width;
      size.height = screenSize.height;
    }

    transform.scale(scaleX, scaleY);

    final translation = transform.getTranslation();
    final anchor = this.anchor ?? Anchor.bottomLeft;

    switch (anchor) {
      case Anchor.topLeft:
        transform.setTranslationRaw(
          scaleX * translation.x,
          scaleY * translation.y,
          translation.z,
        );
        break;
      case Anchor.topCenter:
        transform.setTranslationRaw(
          scaleX * translation.x + screenSize.width / 2,
          scaleY * translation.y,
          translation.z,
        );
        break;
      case Anchor.topRight:
        transform.setTranslationRaw(
          scaleX * translation.x + screenSize.width,
          scaleY * translation.y,
          translation.z,
        );
        break;
      case Anchor.centerLeft:
        transform.setTranslationRaw(
          scaleX * translation.x,
          scaleY * translation.y + screenSize.height / 2,
          translation.z,
        );
        break;
      case Anchor.center:
        transform.setTranslationRaw(
          scaleX * translation.x + screenSize.width / 2,
          scaleY * translation.y + screenSize.height / 2,
          translation.z,
        );
        break;
      case Anchor.centerRight:
        transform.setTranslationRaw(
          scaleX * translation.x + screenSize.width,
          scaleY * translation.y + screenSize.height / 2,
          translation.z,
        );
        break;
      case Anchor.bottomLeft:
        transform.setTranslationRaw(
          scaleX * translation.x,
          scaleY * translation.y + screenSize.height,
          translation.z,
        );
        break;
      case Anchor.bottomCenter:
        transform.setTranslationRaw(
          scaleX * translation.x + screenSize.width / 2,
          scaleY * translation.y + screenSize.height,
          translation.z,
        );
        break;
      case Anchor.bottomRight:
        transform.setTranslationRaw(
          scaleX * translation.x + screenSize.width,
          scaleY * translation.y + screenSize.height,
          translation.z,
        );
        break;
    }

    canvas.transform(transform.storage);
  }
}

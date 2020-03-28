import 'package:flutter/rendering.dart';
import 'package:fluttershy/foundation/anchor.dart';
import 'package:fluttershy/foundation/colorable.dart';
import 'package:fluttershy/foundation/node.dart';
import 'package:fluttershy/foundation/size.dart';

class Rectangle extends Node with Colorable, Sizable, Anchorable {
  Rectangle({Color color, Size size, Anchor anchor}) {
    this.color = color;
    this.size = size;
    this.anchor = anchor;
  }

  @override
  void onRender(Canvas canvas) {
    final translation = worldTransform.getTranslation();
    final anchor = this.anchor ?? Anchor.center;
    final ltrb = Anchor.computeLTRBfromLTWH(
      anchor,
      translation.x,
      translation.y,
      size.width * worldTransform.getRow(0).x,
      size.height * worldTransform.getRow(1).y,
    );

    canvas.drawRect(Rect.fromLTRB(ltrb.left, ltrb.top, ltrb.right, ltrb.bottom),
        Paint()..color = color);
  }
}

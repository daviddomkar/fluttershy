import 'package:dartex/world.dart';
import 'package:flutter/material.dart';
import 'package:fluttershy/foundation/bundle.dart';

class RenderingBundle extends Bundle {
  final Size _size;
  final Color _backgroundColor;

  RenderingBundle({Color backgroundColor, Size size})
      : _size = size ?? null,
        _backgroundColor = backgroundColor ?? Colors.black,
        super([], []);

  @override
  Widget buildMiddleware(BuildContext context, Widget child, World world) {
    return LayoutBuilder();
  }
}

import 'package:dartex/world.dart';
import 'package:flutter/material.dart';
import 'package:fluttershy/foundation/event.dart';
import 'package:fluttershy/foundation/module.dart';

class RenderingModule extends Module {
  final Size _size;
  final Color _backgroundColor;

  RenderingModule({Color backgroundColor, Size size})
      : _size = size ?? null,
        _backgroundColor = backgroundColor ?? Colors.black,
        super([], []);

  @override
  Widget buildMiddleware(BuildContext context, Widget child, World world) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          color: _backgroundColor,
          child: child,
        );
      },
    );
  }

  void onEvent(Event event) {}
}

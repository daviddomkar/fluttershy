import 'package:flutter/rendering.dart';

abstract class RenderCommand {
  final double priority;

  RenderCommand({double priority}) : priority = priority ?? 0;

  void render(Canvas canvas);
}

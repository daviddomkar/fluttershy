import 'package:flutter/rendering.dart' hide Size;

abstract class RenderCommand {
  final double priority;

  RenderCommand({double priority}) : priority = priority ?? 0;

  void render(Canvas canvas);
}

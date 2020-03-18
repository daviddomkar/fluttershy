import 'dart:ui';

import 'package:dartex/dartex.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttershy/foundation/size.dart';

abstract class State {
  void onStart(BuildContext context, World world) {}

  void onStop(World world) {}

  void onPause(World world) {}

  void onResume(World world) {}

  void onUpdate(World world, double deltaTime) {}

  void onResize(World world, Size size) {}

  void onRender(World world, Canvas canvas) {}
}

import 'dart:ui';

import 'package:dartex/dartex.dart';
import 'package:fluttershy/foundation/components/size.dart';

abstract class State {
  void onStart(World world) {}

  void onStop(World world) {}

  void onPause(World world) {}

  void onResume(World world) {}

  void onUpdate(World world, double deltaTime) {}

  void onResize(World world, Size size) {}

  void onRender(World world, Canvas canvas) {}
}

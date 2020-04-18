import 'package:flutter/widgets.dart';
import 'package:fluttershy/event.dart';

abstract class Backend {
  void setup(BuildContext context) {}

  void update(double deltaTime) {}

  void event(Type type, Event event) {}

  void render(Canvas canvas) {}

  void destroy(BuildContext context) {}
}

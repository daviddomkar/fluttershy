import 'package:flutter/widgets.dart';
import 'package:fluttershy/event.dart';

abstract class Game {
  void setup(BuildContext context) {}

  void update(double deltaTime) {}

  void event(Event event) {}

  void render(Canvas canvas) {}

  void destroy(BuildContext context) {}
}
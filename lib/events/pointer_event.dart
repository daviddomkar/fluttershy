import 'package:flutter/gestures.dart' as flutter;
import 'package:fluttershy/event.dart';

class PointerDownEvent extends Event {
  final flutter.PointerDownEvent rawEvent;

  final double screenX;
  final double screenY;

  PointerDownEvent(this.rawEvent)
      : screenX = rawEvent.localPosition.dx,
        screenY = rawEvent.localPosition.dy;
}

class PointerMoveEvent extends Event {
  final flutter.PointerMoveEvent rawEvent;

  final double screenX;
  final double screenY;

  PointerMoveEvent(this.rawEvent)
      : screenX = rawEvent.localPosition.dx,
        screenY = rawEvent.localPosition.dy;
}

class PointerUpEvent extends Event {
  final flutter.PointerUpEvent rawEvent;

  final double screenX;
  final double screenY;

  PointerUpEvent(this.rawEvent)
      : screenX = rawEvent.localPosition.dx,
        screenY = rawEvent.localPosition.dy;
}

class PointerSignalEvent extends Event {
  final flutter.PointerSignalEvent rawEvent;

  final double screenX;
  final double screenY;

  PointerSignalEvent(this.rawEvent)
      : screenX = rawEvent.localPosition.dx,
        screenY = rawEvent.localPosition.dy;
}

class PointerCancelEvent extends Event {
  final flutter.PointerCancelEvent rawEvent;

  final double screenX;
  final double screenY;

  PointerCancelEvent(this.rawEvent)
      : screenX = rawEvent.localPosition.dx,
        screenY = rawEvent.localPosition.dy;
}

import 'package:flutter/gestures.dart' as flutter;
import 'package:fluttershy/events/event.dart';
import 'package:vector_math/vector_math_64.dart';

class PointerDownEvent with Event<PointerDownEvent> {
  final flutter.PointerDownEvent rawEvent;

  final Vector2 position;

  PointerDownEvent(this.rawEvent)
      : position =
            Vector2(rawEvent.localPosition.dx, rawEvent.localPosition.dy);
}

class PointerMoveEvent with Event<PointerMoveEvent> {
  final flutter.PointerMoveEvent rawEvent;

  final Vector2 position;

  PointerMoveEvent(this.rawEvent)
      : position =
            Vector2(rawEvent.localPosition.dx, rawEvent.localPosition.dy);
}

class PointerUpEvent with Event<PointerUpEvent> {
  final flutter.PointerUpEvent rawEvent;

  final Vector2 position;

  PointerUpEvent(this.rawEvent)
      : position =
            Vector2(rawEvent.localPosition.dx, rawEvent.localPosition.dy);
}

class PointerSignalEvent with Event<PointerSignalEvent> {
  final flutter.PointerSignalEvent rawEvent;

  final Vector2 position;

  PointerSignalEvent(this.rawEvent)
      : position =
            Vector2(rawEvent.localPosition.dx, rawEvent.localPosition.dy);
}

class PointerCancelEvent with Event<PointerCancelEvent> {
  final flutter.PointerCancelEvent rawEvent;

  final Vector2 position;

  PointerCancelEvent(this.rawEvent)
      : position =
            Vector2(rawEvent.localPosition.dx, rawEvent.localPosition.dy);
}

import 'package:flutter/gestures.dart';
import 'package:fluttershy/event.dart';

class GestureEvent extends Event {}

// Taps
class TapDownEvent extends GestureEvent {
  final TapDownDetails details;

  TapDownEvent(this.details);
}

class TapUpEvent extends GestureEvent {
  final TapUpDetails details;

  TapUpEvent(this.details);
}

class TapEvent extends GestureEvent {}

class TapCancelEvent extends GestureEvent {}

// Secondary taps
class SecondaryTapDownEvent extends GestureEvent {
  final TapDownDetails details;

  SecondaryTapDownEvent(this.details);
}

class SecondaryTapUpEvent extends GestureEvent {
  final TapUpDetails details;

  SecondaryTapUpEvent(this.details);
}

class SecondaryTapEvent extends GestureEvent {}

class SecondaryTapCancelEvent extends GestureEvent {}

// Double tap
class DoubleTapEvent extends GestureEvent {}

// TODO: Long presses

// Vertical drags
class VerticalDragDownEvent extends GestureEvent {
  final DragDownDetails details;

  VerticalDragDownEvent(this.details);
}

class VerticalDragStartEvent extends GestureEvent {
  final DragStartDetails details;

  VerticalDragStartEvent(this.details);
}

class VerticalDragUpdateEvent extends GestureEvent {
  final DragUpdateDetails details;

  VerticalDragUpdateEvent(this.details);
}

class VerticalDragEndEvent extends GestureEvent {
  final DragEndDetails details;

  VerticalDragEndEvent(this.details);
}

class VerticalDragCancelEvent extends GestureEvent {}

// Horizontal drags
class HorizontalDragDownEvent extends GestureEvent {
  final DragDownDetails details;

  HorizontalDragDownEvent(this.details);
}

class HorizontalDragStartEvent extends GestureEvent {
  final DragStartDetails details;

  HorizontalDragStartEvent(this.details);
}

class HorizontalDragUpdateEvent extends GestureEvent {
  final DragUpdateDetails details;

  HorizontalDragUpdateEvent(this.details);
}

class HorizontalDragEndEvent extends GestureEvent {
  final DragEndDetails details;

  HorizontalDragEndEvent(this.details);
}

class HorizontalDragCancelEvent extends GestureEvent {}

// TODO: Force presses

// TODO: Pans

// TODO: Scales

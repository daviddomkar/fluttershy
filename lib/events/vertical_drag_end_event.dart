import 'package:flutter/gestures.dart';

import 'event.dart';

class VerticalDragEndEvent extends Event {
  final DragEndDetails details;

  VerticalDragEndEvent({required this.details});
}

import 'package:flutter/gestures.dart';

import 'event.dart';

class HorizontalDragEndEvent extends Event {
  final DragEndDetails details;

  HorizontalDragEndEvent({required this.details});
}

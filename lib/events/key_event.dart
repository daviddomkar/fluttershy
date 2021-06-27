import 'package:flutter/services.dart';

import 'event.dart';

class KeyEvent extends Event {
  final RawKeyEvent rawEvent;

  KeyEvent({required this.rawEvent});
}

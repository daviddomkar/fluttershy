import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttershy/foundation/event.dart';
import 'package:fluttershy/foundation/size.dart';

class LifecycleStateChangeEvent with Event {
  AppLifecycleState _state;

  LifecycleStateChangeEvent({@required AppLifecycleState state})
      : _state = state;

  AppLifecycleState get state => _state;
}

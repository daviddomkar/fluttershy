import 'package:flutter/foundation.dart';
import 'package:fluttershy/foundation/event.dart';

class UpdateEvent with Event {
  double _deltaTime;

  UpdateEvent({@required double deltaTime}) : _deltaTime = deltaTime;

  double get deltaTime => _deltaTime;
}

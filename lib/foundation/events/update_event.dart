import 'package:flutter/foundation.dart';
import 'package:fluttershy/foundation/event.dart';

class UpdateEvent with Event {
  double _dt;

  UpdateEvent({@required double dt}) : _dt = dt;

  double get dt => _dt;
}

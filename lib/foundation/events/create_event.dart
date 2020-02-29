import 'package:flutter/foundation.dart';
import 'package:fluttershy/foundation/event.dart';
import 'package:fluttershy/foundation/size.dart';

class CreateEvent with Event {
  Size _size;

  CreateEvent({@required Size size}) : _size = size;

  Size get size => _size;
}

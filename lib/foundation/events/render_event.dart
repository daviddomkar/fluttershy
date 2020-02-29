import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttershy/foundation/event.dart';

class RenderEvent with Event {
  Canvas _canvas;

  RenderEvent({@required Canvas canvas}) : _canvas = canvas;

  Canvas get canvas => _canvas;
}

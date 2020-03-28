import 'dart:collection';

import 'package:fluttershy/foundation/event.dart';
import 'package:fluttershy/foundation/resource.dart';

class EventDispatcher with Resource {
  Queue<Event> _queue;

  EventDispatcher() : _queue = Queue();

  void dispatchEvent(Event event) {
    _queue.add(event);
  }

  Queue<Event> get queue => _queue;
}

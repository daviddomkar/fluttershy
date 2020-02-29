import 'dart:collection';

import 'package:dartex/resource.dart';
import 'package:fluttershy/foundation/event.dart';

class EventDispatcher with Resource {
  Queue<Event> _queue;

  EventDispatcher() : _queue = Queue();

  void dispatchEvent(Event event) {
    _queue.add(event);
  }

  Queue<Event> get queue => _queue;
}

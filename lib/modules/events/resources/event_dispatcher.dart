import 'dart:collection';

import 'package:dartex/dartex.dart';
import 'package:fluttershy/modules/events/event.dart';

class EventDispatcher with Resource {
  Queue<Event> _queue;

  EventDispatcher() : _queue = Queue();

  void dispatchEvent(Event event) {
    _queue.add(event);
  }

  Queue<Event> get queue => _queue;
}

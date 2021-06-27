import 'package:flutter/scheduler.dart';
import 'package:fluttershy/events/event.dart';

class AppLifecycleEvent with Event {
  final AppLifecycleState state;

  AppLifecycleEvent({required this.state});
}

import 'package:flutter/scheduler.dart';
import 'package:fluttershy/foundation/event.dart';
import 'package:fluttershy/foundation/size.dart';

class AppLifecycleEvent with Event {
  final AppLifecycleState state;

  AppLifecycleEvent({this.state});
}

import 'package:dartex/world.dart';
import 'package:fluttershy/foundation/event.dart';
import 'package:fluttershy/foundation/events/create_event.dart';
import 'package:fluttershy/foundation/events/update_event.dart';
import 'package:fluttershy/foundation/module.dart';
import 'package:fluttershy/modules/time/resources/time_resource.dart';

class TimeModule extends Module {
  TimeModule() : super([], []);

  @override
  void onEvent(Event event, World world) {
    if (event is CreateEvent) {
      world.insertResource(TimeResource());
    } else if (event is UpdateEvent) {
      world.getResource<TimeResource>().deltaTime = event.deltaTime;
    }
  }
}

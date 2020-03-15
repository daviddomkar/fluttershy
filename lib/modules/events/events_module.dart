import 'package:dartex/dartex.dart';
import 'package:fluttershy/foundation/module.dart';
import 'package:fluttershy/modules/events/resources/event_dispatcher.dart';

class EventsModule extends Module {
  EventsModule() : super(priority: ExecutionPriority.before, systems: []);

  @override
  void onStart(World world) {
    world.insertResource(EventDispatcher());
  }
}

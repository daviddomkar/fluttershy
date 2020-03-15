import 'package:dartex/dartex.dart';
import 'package:fluttershy/foundation/module.dart';
import 'package:fluttershy/modules/time/resources/timer.dart';

class TimeModule extends Module {
  TimeModule()
      : super(
          priority: ExecutionPriority.before,
          systems: [],
        );

  @override
  void onStart(World world) {
    world.insertResource(Timer());
  }

  @override
  void onUpdate(World world, double deltaTime) {
    world.getResource<Timer>().deltaTime = deltaTime;
  }
}

import 'package:dartex/system.dart';
import 'package:dartex/world.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttershy/foundation/event.dart';

class Module {
  List<Type> _components;
  List<System> _systems;

  Module(List<Type> components, List<System> systems)
      : _components = components,
        _systems = systems;

  Widget buildMiddleware(BuildContext context, Widget child, World world) {
    return child;
  }

  void onEvent(Event event, World world) {}

  List<Type> get components => _components;
  List<System> get systems => _systems;
}

import 'package:dartex/system.dart';
import 'package:dartex/world.dart';
import 'package:flutter/widgets.dart';

class Bundle {
  List<Type> _components;
  List<System> _systems;

  Bundle(List<Type> components, List<System> systems)
      : _components = components,
        _systems = systems;

  Widget buildMiddleware(BuildContext context, Widget child, World world) {
    return child;
  }
}

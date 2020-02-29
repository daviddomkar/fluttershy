import 'package:dartex/system.dart';
import 'package:flutter/widgets.dart';

class Bundle {
  List<Type> _components;
  List<System> _systems;

  Bundle(List<System> systems, List<Type> components)
      : _components = components,
        _systems = systems;

  Widget buildMiddleware(BuildContext context, Widget child) {
    return child;
  }
}

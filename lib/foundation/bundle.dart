import 'package:dartex/system.dart';

class Bundle {
  List<Type> _components;
  List<System> _systems;

  Bundle(List<System> systems, List<Type> components)
      : _components = components,
        _systems = systems;
}

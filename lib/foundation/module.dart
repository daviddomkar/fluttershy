import 'package:dartex/dartex.dart';
import 'package:flutter/widgets.dart' hide State;
import 'package:fluttershy/foundation/state.dart';

enum ExecutionPriority { before, after }

abstract class Module extends State {
  final ExecutionPriority priority;
  final List<System> systems;

  Module({@required this.priority, @required this.systems});

  Widget buildMiddleware(BuildContext context, Widget child, World world) {
    return child;
  }
}

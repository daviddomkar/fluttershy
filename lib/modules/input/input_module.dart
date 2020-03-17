import 'package:dartex/dartex.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttershy/foundation/module.dart';

class InputModule extends Module {
  InputModule() : super(priority: ExecutionPriority.before, systems: []);

  @override
  Widget buildMiddleware(BuildContext context, Widget child, World world) {
    return GestureDetector(
      child: child,
    );
  }
}

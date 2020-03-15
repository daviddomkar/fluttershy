import 'package:dartex/dartex.dart';
import 'package:fluttershy/modules/rendering/render_command.dart';
import 'package:ordered_set/comparing.dart';
import 'package:ordered_set/ordered_set.dart';

class RenderCommandBuffer with Resource<RenderCommandBuffer> {
  final OrderedSet<RenderCommand> commands;

  RenderCommandBuffer()
      : commands = OrderedSet(Comparing.on((command) => command.priority));

  void submitCommand(RenderCommand command) {
    commands.add(command);
  }
}

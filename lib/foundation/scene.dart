import 'package:flutter/widgets.dart' hide Size;
import 'package:fluttershy/foundation/asset_bundle.dart';
import 'package:fluttershy/foundation/event.dart';
import 'package:fluttershy/foundation/event_dispatcher.dart';
import 'package:fluttershy/foundation/events/resize_event.dart';
import 'package:fluttershy/foundation/node.dart';
import 'package:fluttershy/foundation/screen_dimensions.dart';

abstract class Scene {
  final RootNode root;

  Scene() : root = RootNode();

  void setup(BuildContext context) {
    root.addResource(ScreenDimensions());
    root.addResource(EventDispatcher());
    root.addResource(AssetBundle(DefaultAssetBundle.of(context)));
  }

  void update(double deltaTime) {
    final eventQueue = root.getResource<EventDispatcher>().queue;

    while (eventQueue.isNotEmpty) {
      root.onEvent(eventQueue.removeLast());
    }

    root.onUpdate(deltaTime);
  }

  void event(Event event) {
    if (event is ResizeEvent) {
      root.getResource<ScreenDimensions>().size = event.size;
    }

    root.onEvent(event);
  }

  void destroy(BuildContext context) {
    root.detachChildren();
    root.removeResource<ScreenDimensions>();
  }
}

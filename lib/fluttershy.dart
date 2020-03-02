library fluttershy;

import 'package:dartex/system.dart';
import 'package:dartex/world.dart';
import 'package:flutter/rendering.dart' hide Size;
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart' hide Size;
import 'package:fluttershy/foundation/event.dart';
import 'package:fluttershy/foundation/event_dispatcher.dart';
import 'package:fluttershy/foundation/events/create_event.dart';
import 'package:fluttershy/foundation/events/destroy_event.dart';
import 'package:fluttershy/foundation/events/lifecycle_state_change_event.dart';
import 'package:fluttershy/foundation/events/render_event.dart';
import 'package:fluttershy/foundation/events/resize_event.dart';
import 'package:fluttershy/foundation/events/update_event.dart';
import 'package:fluttershy/foundation/module.dart';
import 'package:fluttershy/foundation/size.dart';

class Fluttershy extends StatefulWidget {
  final List<Module> modules;

  const Fluttershy({Key key, this.modules}) : super(key: key);

  @override
  _FluttershyState createState() => _FluttershyState();
}

class _FluttershyState extends State<Fluttershy> {
  World _world;

  @override
  void initState() {
    super.initState();

    _world = World(
        systems: widget.modules.fold<List<System>>([], (systems, bundle) {
      systems.addAll(bundle.systems);
      return systems;
    }));

    widget.modules.forEach((bundle) => bundle.components
        .forEach((component) => _world.registerComponent(component)));
  }

  @override
  Widget build(BuildContext context) {
    return widget.modules.fold(
      _FluttershyWidget(widget.modules, _world),
      (widget, bundle) => bundle.buildMiddleware(
        context,
        widget,
        _world,
      ),
    );
  }
}

class _FluttershyWidget extends LeafRenderObjectWidget {
  final List<Module> modules;
  final World world;

  _FluttershyWidget(this.modules, this.world);

  @override
  RenderBox createRenderObject(BuildContext context) {
    return RenderConstrainedBox(
        child: _FluttershyRenderBox(context, modules, world),
        additionalConstraints: BoxConstraints.expand());
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderConstrainedBox renderBox) {
    renderBox
      ..child = _FluttershyRenderBox(context, modules, world)
      ..additionalConstraints = BoxConstraints.expand();
  }
}

class _FluttershyRenderBox extends RenderBox with WidgetsBindingObserver {
  final BuildContext context;
  final List<Module> modules;
  final World world;

  int _frameCallbackId;
  bool _created = false;

  Duration previous = Duration.zero;

  _FluttershyRenderBox(this.context, this.modules, this.world);

  @override
  bool get sizedByParent => true;

  @override
  void performResize() {
    super.performResize();

    modules.forEach((module) {
      module.onEvent(
          ResizeEvent(
            size: Size(constraints.biggest.width, constraints.biggest.height),
          ),
          world);
    });

    // Update on first frame
    if (!_created) {
      modules.forEach((module) {
        module.onEvent(UpdateEvent(deltaTime: 0), world);
      });

      world.run();
      _created = true;
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);

    world.insertResource(EventDispatcher());

    modules.forEach((module) {
      module.onEvent(CreateEvent(), world);
    });

    _scheduleTick();
    _bindLifecycleListener();
  }

  @override
  void detach() {
    super.detach();

    world.destroyEntities();
    world.destroyResources();

    modules.forEach((module) {
      module.onEvent(DestroyEvent(), world);
    });

    _unscheduleTick();
    _unbindLifecycleListener();
  }

  void _scheduleTick() {
    _frameCallbackId = SchedulerBinding.instance.scheduleFrameCallback(_tick);
  }

  void _unscheduleTick() {
    SchedulerBinding.instance.cancelFrameCallbackWithId(_frameCallbackId);
  }

  void _tick(Duration timestamp) {
    if (!attached) {
      return;
    }
    _scheduleTick();
    _update(timestamp);
    markNeedsPaint();
  }

  void _update(Duration now) {
    final double dt = _computeDeltaT(now);

    EventDispatcher dispatcher = world.getResource<EventDispatcher>();

    while (dispatcher.queue.isNotEmpty) {
      Event event = dispatcher.queue.removeFirst();

      modules.forEach((module) {
        module.onEvent(event, world);
      });
    }

    modules.forEach((module) {
      module.onEvent(UpdateEvent(deltaTime: dt), world);
    });

    world.run();
  }

  double _computeDeltaT(Duration now) {
    Duration delta = now - previous;
    if (previous == Duration.zero) {
      delta = Duration.zero;
    }
    previous = now;
    return delta.inMicroseconds / Duration.microsecondsPerSecond;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.canvas.save();
    context.canvas.translate(offset.dx, offset.dy);
    modules.forEach((module) {
      module.onEvent(RenderEvent(canvas: context.canvas), world);
      context.canvas.restore();
      context.canvas.save();
    });
    context.canvas.restore();
  }

  void _bindLifecycleListener() {
    WidgetsBinding.instance.addObserver(this);
  }

  void _unbindLifecycleListener() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    modules.forEach((module) {
      module.onEvent(
          LifecycleStateChangeEvent(
            state: state,
          ),
          world);
    });
  }
}

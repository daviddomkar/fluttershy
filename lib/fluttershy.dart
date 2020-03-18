library fluttershy;

import 'package:dartex/dartex.dart';
import 'package:flutter/rendering.dart' hide Size;
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart' hide Size;
import 'package:fluttershy/foundation/size.dart';
import 'package:fluttershy/foundation/module.dart';
import 'package:fluttershy/foundation/state.dart' as fluttershy;

class Fluttershy extends StatefulWidget {
  final fluttershy.State defaultState;
  final List<Module> modules;
  final List<System> systems;

  const Fluttershy({Key key, this.defaultState, this.modules, this.systems})
      : super(key: key);

  @override
  _FluttershyState createState() => _FluttershyState();
}

class _FluttershyState extends State<Fluttershy> {
  World world;

  @override
  void initState() {
    super.initState();

    final List<System> systems = [
      ...widget.modules
          .where((m) => m.priority == ExecutionPriority.before)
          .fold<List<System>>(List<System>(), (systems, module) {
        systems.addAll(module.systems);
        return systems;
      }),
      ...widget.systems,
      ...widget.modules
          .where((m) => m.priority == ExecutionPriority.after)
          .fold<List<System>>(List<System>(), (systems, module) {
        systems.addAll(module.systems);
        return systems;
      }),
    ];

    world = World(systems: systems);
  }

  @override
  Widget build(BuildContext context) {
    return widget.modules.fold(
      _FluttershyWidget(widget.defaultState, widget.modules, world),
      (widget, bundle) => bundle.buildMiddleware(
        context,
        widget,
        world,
      ),
    );
  }
}

class _FluttershyWidget extends LeafRenderObjectWidget {
  final fluttershy.State defaultState;
  final List<Module> modules;
  final World world;

  _FluttershyWidget(this.defaultState, this.modules, this.world);

  @override
  RenderBox createRenderObject(BuildContext context) {
    return RenderConstrainedBox(
        child: _FluttershyRenderBox(context, defaultState, modules, world),
        additionalConstraints: BoxConstraints.expand());
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderConstrainedBox renderBox) {
    renderBox
      ..child = _FluttershyRenderBox(context, defaultState, modules, world)
      ..additionalConstraints = BoxConstraints.expand();
  }
}

class _FluttershyRenderBox extends RenderBox with WidgetsBindingObserver {
  final BuildContext context;
  final fluttershy.State defaultState;
  final List<Module> modules;
  final World world;

  int _frameCallbackId;
  bool _created;

  Duration _previous;

  _FluttershyRenderBox(
      this.context, this.defaultState, this.modules, this.world)
      : _created = false,
        _previous = Duration.zero;

  @override
  bool get sizedByParent => true;

  @override
  void performResize() {
    super.performResize();

    final size = Size(constraints.biggest.width, constraints.biggest.height);

    modules.forEach((module) => module.onResize(world, size.copy()));
    defaultState.onResize(world, size.copy());

    // Update on first frame
    if (!_created) {
      modules.forEach((module) => module.onUpdate(world, 0));
      defaultState.onUpdate(world, 0);

      world.run();
      _created = true;
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);

    modules.forEach((module) => module.onStart(context, world));
    defaultState.onStart(context, world);

    _scheduleTick();
    _bindLifecycleListener();
  }

  @override
  void detach() {
    super.detach();

    modules.forEach((module) => module.onStop(world));
    defaultState.onStop(world);

    world.destroyEntities();
    world.destroyResources();

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
    final double deltaTime = _computeDeltaT(now);

    modules.forEach((module) => module.onUpdate(world, deltaTime));
    defaultState.onUpdate(world, deltaTime);

    world.run();
  }

  double _computeDeltaT(Duration now) {
    Duration delta = now - _previous;
    if (_previous == Duration.zero) {
      delta = Duration.zero;
    }
    _previous = now;
    return delta.inMicroseconds / Duration.microsecondsPerSecond;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.canvas.save();
    context.canvas.translate(offset.dx, offset.dy);
    modules.forEach((module) {
      module.onRender(world, context.canvas);
      context.canvas.restore();
      context.canvas.save();
    });
    defaultState.onRender(world, context.canvas);
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
    switch (state) {
      case AppLifecycleState.resumed:
        modules.forEach((module) => module.onResume(world));
        defaultState.onResume(world);
        break;
      case AppLifecycleState.paused:
        modules.forEach((module) => module.onPause(world));
        defaultState.onPause(world);
        break;
      default:
        break;
    }
  }
}

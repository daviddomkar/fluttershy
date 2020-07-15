import 'package:flutter/material.dart'
    hide
        Size,
        PointerDownEvent,
        PointerMoveEvent,
        PointerUpEvent,
        PointerCancelEvent;
import 'package:flutter/rendering.dart'
    hide
        Size,
        PointerDownEvent,
        PointerMoveEvent,
        PointerUpEvent,
        PointerCancelEvent;
import 'package:flutter/scheduler.dart';

import 'fluttershy.dart';

abstract class Context {
  BuildContext _buildContext;

  void _assignBuildContext(BuildContext context) {
    _buildContext = context;
  }

  BuildContext get buildContext => _buildContext;
}

class _Fluttershy<C extends Context> {
  C _context;

  final C Function() _contextBuilder;

  final void Function(C context) _setup;
  final void Function(C context, Event event) _event;
  final void Function(C context, double deltaTime) _update;
  final void Function(C context, Canvas canvas) _render;
  final void Function(C context) _destroy;

  final Color _backgroundColor;

  _Fluttershy(
    C Function() contextBuilder,
    void Function(C context) setup,
    void Function(C context, Event event) event,
    void Function(C context, double deltaTime) update,
    void Function(C context, Canvas canvas) render,
    void Function(C context) destroy,
    Color backgroundColor,
  )   : _contextBuilder = contextBuilder,
        _setup = setup,
        _event = event,
        _update = update,
        _render = render,
        _destroy = destroy,
        _backgroundColor = backgroundColor;

  void setup(BuildContext buildContext) {
    _context = _contextBuilder();
    _context._assignBuildContext(buildContext);
    _setup?.call(_context);
  }

  void event(Event event) {
    _event?.call(_context, event);
  }

  void update(double deltaTime) {
    _update?.call(_context, deltaTime);
  }

  void render(Canvas canvas, Offset offset, double width, double height) {
    canvas.drawColor(_backgroundColor, BlendMode.color);
    canvas.translate(offset.dx, offset.dy);
    canvas.clipRect(Rect.fromLTWH(
      0,
      0,
      width,
      height,
    ));

    _render?.call(_context, canvas);
  }

  void destroy() {
    _destroy?.call(_context);
    _context = null;
  }
}

class FluttershyWidget<C extends Context> extends StatelessWidget {
  final _Fluttershy<C> _fluttershy;

  FluttershyWidget({
    Key key,
    C Function() contextBuilder,
    void Function(C context) setup,
    void Function(C context, Event event) event,
    void Function(C context, double deltaTime) update,
    void Function(C context, Canvas canvas) render,
    void Function(C context) destroy,
    Color backgroundColor,
  })  : _fluttershy = _Fluttershy<C>(
          contextBuilder,
          setup,
          event,
          update,
          render,
          destroy,
          backgroundColor,
        ),
        super(key: key);

  @override
  Widget build(BuildContext buildContext) {
    return Listener(
      onPointerDown: (rawEvent) => _fluttershy.event(
        PointerDownEvent(rawEvent),
      ),
      onPointerMove: (rawEvent) => _fluttershy.event(
        PointerMoveEvent(rawEvent),
      ),
      onPointerUp: (rawEvent) => _fluttershy.event(
        PointerUpEvent(rawEvent),
      ),
      onPointerSignal: (rawEvent) => _fluttershy.event(
        PointerSignalEvent(rawEvent),
      ),
      onPointerCancel: (rawEvent) => _fluttershy.event(
        PointerCancelEvent(rawEvent),
      ),
      child: LayoutBuilder(
        builder: (buildContext, constraints) {
          return Container(
            color: _fluttershy._backgroundColor ?? Colors.black,
            child: _RenderObjectWidget<C>(_fluttershy),
          );
        },
      ),
    );
  }
}

class _RenderObjectWidget<C extends Context> extends LeafRenderObjectWidget {
  final _Fluttershy<C> fluttershy;

  _RenderObjectWidget(this.fluttershy);

  @override
  RenderBox createRenderObject(BuildContext buildContext) {
    return RenderConstrainedBox(
        child: _RenderBox<C>(buildContext, fluttershy),
        additionalConstraints: BoxConstraints.expand());
  }

  @override
  void updateRenderObject(
      BuildContext buildContext, RenderConstrainedBox renderBox) {
    renderBox
      ..child = _RenderBox<C>(buildContext, fluttershy)
      ..additionalConstraints = BoxConstraints.expand();
  }
}

class _RenderBox<C extends Context> extends RenderBox
    with WidgetsBindingObserver {
  final BuildContext buildContext;
  final _Fluttershy<C> fluttershy;

  int _frameCallbackId;
  bool _created;

  Duration _previous;

  _RenderBox(
    this.buildContext,
    this.fluttershy,
  )   : _created = false,
        _previous = Duration.zero;

  @override
  bool get sizedByParent => true;

  @override
  void performResize() {
    super.performResize();

    fluttershy.event(
      ResizeEvent(
        size: Size(constraints.biggest.width, constraints.biggest.height),
      ),
    );

    // Update on first frame
    if (!_created) {
      fluttershy.update(0);
      _created = true;
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);

    _scheduleTick();
    _bindLifecycleListener();

    fluttershy.setup(buildContext);
  }

  @override
  void detach() {
    super.detach();

    fluttershy.destroy();

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

    fluttershy.update(deltaTime);
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
  void paint(PaintingContext paintingContext, Offset offset) {
    final canvas = paintingContext.canvas;

    canvas.save();

    fluttershy.render(
        canvas, offset, constraints.biggest.width, constraints.biggest.height);

    canvas.restore();
  }

  void _bindLifecycleListener() {
    WidgetsBinding.instance.addObserver(this);
  }

  void _unbindLifecycleListener() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    fluttershy.event(AppLifecycleEvent(state: state));
  }
}

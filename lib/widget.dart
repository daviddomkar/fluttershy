import 'dart:ui';

import 'package:flutter/material.dart' hide Size, PointerDownEvent, PointerMoveEvent, PointerUpEvent, PointerCancelEvent;
import 'package:flutter/rendering.dart' hide Size, PointerDownEvent, PointerMoveEvent, PointerUpEvent, PointerCancelEvent;
import 'package:flutter/scheduler.dart';

import 'fluttershy.dart';
import 'math.dart';

class _Fluttershy {
  final void Function()? _setup;
  final void Function(Event event)? _event;
  final void Function(double deltaTime)? _update;
  final void Function(Canvas canvas)? _render;
  final void Function()? _destroy;

  _Fluttershy(
    void Function()? setup,
    void Function(Event event)? event,
    void Function(double deltaTime)? update,
    void Function(Canvas canvas)? render,
    void Function()? destroy,
  )   : _setup = setup,
        _event = event,
        _update = update,
        _render = render,
        _destroy = destroy;

  void setup(BuildContext buildContext) {
    _setup?.call();
  }

  void event(Event event) {
    _event?.call(event);
  }

  void update(double deltaTime) {
    _update?.call(deltaTime);
  }

  void render(Canvas canvas, Offset offset, double width, double height) {
    canvas.drawColor(Colors.black, BlendMode.color);
    canvas.translate(offset.dx, offset.dy);
    canvas.clipRect(Rect.fromLTWH(
      0,
      0,
      width,
      height,
    ));

    _render?.call(canvas);
  }

  void destroy() {
    _destroy?.call();
  }
}

class _FluttershyRenderObjectWidget extends LeafRenderObjectWidget {
  final _Fluttershy fluttershy;

  _FluttershyRenderObjectWidget(this.fluttershy);

  @override
  RenderBox createRenderObject(BuildContext buildContext) {
    return RenderConstrainedBox(child: _FluttershyRenderBox(buildContext, fluttershy), additionalConstraints: BoxConstraints.expand());
  }

  @override
  void updateRenderObject(BuildContext buildContext, RenderConstrainedBox renderBox) {
    renderBox
      ..child = _FluttershyRenderBox(buildContext, fluttershy)
      ..additionalConstraints = BoxConstraints.expand();
  }
}

class _FluttershyRenderBox extends RenderBox with WidgetsBindingObserver {
  final BuildContext buildContext;
  final _Fluttershy fluttershy;

  int? _frameCallbackId;
  bool _created;

  Duration _previous;

  _FluttershyRenderBox(
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
        size: Vector2(constraints.biggest.width, constraints.biggest.height),
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
    fluttershy.destroy();

    _unscheduleTick();
    _unbindLifecycleListener();

    super.detach();
  }

  void _scheduleTick() {
    _frameCallbackId = SchedulerBinding.instance?.scheduleFrameCallback(_tick);
  }

  void _unscheduleTick() {
    if (_frameCallbackId != null) {
      SchedulerBinding.instance?.cancelFrameCallbackWithId(_frameCallbackId!);
    }
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

    fluttershy.render(canvas, offset, constraints.biggest.width, constraints.biggest.height);

    canvas.restore();
  }

  void _bindLifecycleListener() {
    WidgetsBinding.instance?.addObserver(this);
  }

  void _unbindLifecycleListener() {
    WidgetsBinding.instance?.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    fluttershy.event(AppLifecycleEvent(state: state));
  }
}

class Fluttershy extends StatelessWidget {
  final _Fluttershy _fluttershy;

  Fluttershy({
    void Function()? setup,
    void Function(Event event)? event,
    void Function(double deltaTime)? update,
    void Function(Canvas canvas)? render,
    void Function()? destroy,
    Key? key,
  })  : _fluttershy = _Fluttershy(
          setup,
          event,
          update,
          render,
          destroy,
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
            child: _FluttershyRenderObjectWidget(_fluttershy),
          );
        },
      ),
    );
  }
}

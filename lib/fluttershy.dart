library fluttershy;

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
import 'package:fluttershy/backend.dart';
import 'package:fluttershy/events/app_lifecycle_event.dart';
import 'package:fluttershy/events/pointer_event.dart';
import 'package:fluttershy/events/resize_event.dart';
import 'package:fluttershy/size.dart';

class Fluttershy extends StatefulWidget {
  final Backend backend;
  final Color backgroundColor;

  const Fluttershy({
    Key key,
    this.backend,
    this.backgroundColor,
  }) : super(key: key);

  @override
  _FluttershyState createState() => _FluttershyState();
}

class _FluttershyState extends State<Fluttershy> {
  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (rawEvent) => widget.backend.event(
        PointerDownEvent,
        PointerDownEvent(rawEvent),
      ),
      onPointerMove: (rawEvent) => widget.backend.event(
        PointerMoveEvent,
        PointerMoveEvent(rawEvent),
      ),
      onPointerUp: (rawEvent) => widget.backend.event(
        PointerUpEvent,
        PointerUpEvent(rawEvent),
      ),
      onPointerSignal: (rawEvent) => widget.backend.event(
        PointerSignalEvent,
        PointerSignalEvent(rawEvent),
      ),
      onPointerCancel: (rawEvent) => widget.backend.event(
        PointerCancelEvent,
        PointerCancelEvent(rawEvent),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            color: widget.backgroundColor ?? Colors.black,
            child: _FluttershyWidget(
                widget.backend, widget.backgroundColor ?? Colors.black),
          );
        },
      ),
    );
  }
}

class _FluttershyWidget extends LeafRenderObjectWidget {
  final Backend backend;
  final Color backgroundColor;

  _FluttershyWidget(this.backend, this.backgroundColor);

  @override
  RenderBox createRenderObject(BuildContext context) {
    return RenderConstrainedBox(
        child: _FluttershyRenderBox(context, backend, backgroundColor),
        additionalConstraints: BoxConstraints.expand());
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderConstrainedBox renderBox) {
    renderBox
      ..child = _FluttershyRenderBox(context, backend, backgroundColor)
      ..additionalConstraints = BoxConstraints.expand();
  }
}

class _FluttershyRenderBox extends RenderBox with WidgetsBindingObserver {
  final BuildContext context;
  final Backend backend;
  final Color backgroundColor;

  int _frameCallbackId;
  bool _created;

  Duration _previous;

  _FluttershyRenderBox(this.context, this.backend, this.backgroundColor)
      : _created = false,
        _previous = Duration.zero;

  @override
  bool get sizedByParent => true;

  @override
  void performResize() {
    super.performResize();

    backend.event(
      ResizeEvent,
      ResizeEvent(
        size: Size(constraints.biggest.width, constraints.biggest.height),
      ),
    );

    // Update on first frame
    if (!_created) {
      backend.update(0);
      _created = true;
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);

    _scheduleTick();
    _bindLifecycleListener();

    backend.setup(context);
  }

  @override
  void detach() {
    super.detach();

    backend.destroy(context);

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

    backend.update(deltaTime);
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
    context.canvas.drawColor(backgroundColor, BlendMode.color);
    context.canvas.translate(offset.dx, offset.dy);
    context.canvas.clipRect(Rect.fromLTWH(
        0, 0, constraints.biggest.width, constraints.biggest.height));

    backend.render(context.canvas);

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
    backend.event(
      AppLifecycleEvent,
      AppLifecycleEvent(state: state),
    );
  }
}

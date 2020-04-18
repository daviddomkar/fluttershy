library fluttershy;

import 'package:flutter/material.dart' hide Size;
import 'package:flutter/rendering.dart' hide Size;
import 'package:flutter/scheduler.dart';
import 'package:fluttershy/backend.dart';
import 'package:fluttershy/events/app_lifecycle_event.dart';
import 'package:fluttershy/events/gesture_event.dart';
import 'package:fluttershy/events/resize_event.dart';
import 'package:fluttershy/size.dart';

class Fluttershy extends StatefulWidget {
  final Backend backend;
  final Color backgroundColor;
  final bool listenForTapEvents;
  final bool listenForSecondaryTapEvents;
  final bool listenForDoubleTapEvents;
  final bool listenForLongPressEvents;
  final bool listenForVerticalDragEvents;
  final bool listenForHorizontalDragEvents;
  final bool listenForForcePressEvents;
  final bool listenForPanEvents;
  final bool listenForScaleEvents;

  const Fluttershy({
    Key key,
    this.backend,
    this.backgroundColor,
    bool listenForTapEvents = false,
    bool listenForSecondaryTapEvents = false,
    bool listenForDoubleTapEvents = false,
    bool listenForLongPressEvents = false,
    bool listenForVerticalDragEvents = false,
    bool listenForHorizontalDragEvents = false,
    bool listenForForcePressEvents = false,
    bool listenForPanEvents = false,
    bool listenForScaleEvents = false,
  })  : listenForTapEvents = listenForTapEvents,
        listenForSecondaryTapEvents = listenForSecondaryTapEvents,
        listenForDoubleTapEvents = listenForDoubleTapEvents,
        listenForLongPressEvents = listenForLongPressEvents,
        listenForVerticalDragEvents = listenForVerticalDragEvents,
        listenForHorizontalDragEvents = listenForHorizontalDragEvents,
        listenForForcePressEvents = listenForForcePressEvents,
        listenForPanEvents = listenForPanEvents,
        listenForScaleEvents = listenForScaleEvents,
        super(key: key);

  @override
  _FluttershyState createState() => _FluttershyState();
}

class _FluttershyState extends State<Fluttershy> {
  @override
  void initState() {
    super.initState();
    widget.backend.setup(context);
  }

  @override
  void reassemble() {
    super.reassemble();
    widget.backend.destroy(context);
    widget.backend.setup(context);
  }

  @override
  void dispose() {
    super.dispose();
    widget.backend.destroy(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.listenForTapEvents
          ? (details) =>
              widget.backend.event(TapDownEvent, TapDownEvent(details))
          : null,
      onTapUp: widget.listenForTapEvents
          ? (details) => widget.backend.event(TapUpEvent, TapUpEvent(details))
          : null,
      onTap: widget.listenForTapEvents
          ? () => widget.backend.event(TapEvent, TapEvent())
          : null,
      onTapCancel: widget.listenForTapEvents
          ? () => widget.backend.event(TapCancelEvent, TapCancelEvent())
          : null,
      onSecondaryTapDown: widget.listenForSecondaryTapEvents
          ? (details) => widget.backend
              .event(SecondaryTapDownEvent, SecondaryTapDownEvent(details))
          : null,
      onSecondaryTapUp: widget.listenForSecondaryTapEvents
          ? (details) => widget.backend
              .event(SecondaryTapUpEvent, SecondaryTapUpEvent(details))
          : null,
      onSecondaryTapCancel: widget.listenForSecondaryTapEvents
          ? () => widget.backend
              .event(SecondaryTapCancelEvent, SecondaryTapCancelEvent())
          : null,
      onDoubleTap: widget.listenForDoubleTapEvents
          ? () => widget.backend.event(DoubleTapEvent, DoubleTapEvent())
          : null,
      /*onLongPress: () => {},
      onLongPressStart: (details) => {},
      onLongPressMoveUpdate: (details) => {},
      onLongPressUp: () => {},
      onLongPressEnd: (details) => {},*/
      onVerticalDragDown: widget.listenForVerticalDragEvents
          ? (details) => widget.backend
              .event(VerticalDragDownEvent, VerticalDragDownEvent(details))
          : null,
      onVerticalDragStart: widget.listenForVerticalDragEvents
          ? (details) => widget.backend
              .event(VerticalDragStartEvent, VerticalDragStartEvent(details))
          : null,
      onVerticalDragUpdate: widget.listenForVerticalDragEvents
          ? (details) => widget.backend
              .event(VerticalDragUpdateEvent, VerticalDragUpdateEvent(details))
          : null,
      onVerticalDragEnd: widget.listenForVerticalDragEvents
          ? (details) => widget.backend
              .event(VerticalDragEndEvent, VerticalDragEndEvent(details))
          : null,
      onVerticalDragCancel: widget.listenForVerticalDragEvents
          ? () => widget.backend
              .event(VerticalDragCancelEvent, VerticalDragCancelEvent())
          : null,
      onHorizontalDragDown: widget.listenForHorizontalDragEvents
          ? (details) => widget.backend
              .event(HorizontalDragDownEvent, HorizontalDragDownEvent(details))
          : null,
      onHorizontalDragStart: widget.listenForHorizontalDragEvents
          ? (details) => widget.backend.event(
              HorizontalDragStartEvent, HorizontalDragStartEvent(details))
          : null,
      onHorizontalDragUpdate: widget.listenForHorizontalDragEvents
          ? (details) => widget.backend.event(
              HorizontalDragUpdateEvent, HorizontalDragUpdateEvent(details))
          : null,
      onHorizontalDragEnd: widget.listenForHorizontalDragEvents
          ? (details) => widget.backend
              .event(HorizontalDragEndEvent, HorizontalDragEndEvent(details))
          : null,
      onHorizontalDragCancel: widget.listenForHorizontalDragEvents
          ? () => widget.backend
              .event(HorizontalDragCancelEvent, HorizontalDragCancelEvent())
          : null,
      /*onForcePressStart: (details) => {},
      onForcePressPeak: (details) => {},
      onForcePressUpdate: (details) => {},
      onForcePressEnd: (details) => {},
      onPanDown: (details) => {},
      onPanStart: (details) => {},
      onPanUpdate: (details) => {},
      onPanEnd: (details) => {},
      onPanCancel: () => {},
      onScaleStart: (details) => {},
      onScaleUpdate: (details) => {},
      onScaleEnd: (details) => {},*/
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
  }

  @override
  void detach() {
    super.detach();

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

import 'dart:collection';

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
/*
  final List<SetupListener> _setupListeners;
  final List<EventListener> _eventListeners;
  final List<UpdateListener> _updateListeners;
  final List<RenderListener> _renderListeners;
  final List<DestroyListener> _destroyListeners;

  Context()
      : _setupListeners = List(),
        _eventListeners = List(),
        _updateListeners = List(),
        _renderListeners = List(),
        _destroyListeners = List();
*/
  void _assignBuildContext(BuildContext context) {
    _buildContext = context;
  }

/*
  void addSetupListener(SetupListener listener) {
    _setupListeners.add(listener);
  }

  void removeSetupListener(SetupListener listener) {
    _setupListeners.remove(listener);
  }

  void addEventListener(EventListener listener) {
    _eventListeners.add(listener);
  }

  void removeEventListener(EventListener listener) {
    _eventListeners.remove(listener);
  }

  void addUpdateListener(UpdateListener listener) {
    _updateListeners.add(listener);
  }

  void addRenderListener(RenderListener listener) {
    _renderListeners.add(listener);
  }

  void addDestoyListener(DestroyListener listener) {
    _destroyListeners.add(listener);
  }

  void addLifecycleListener(LifecycleListener listener) {
    addSetupListener(listener);
    addEventListener(listener);
    addUpdateListener(listener);
    addRenderListener(listener);
    addDestoyListener(listener);
  }
*/
  BuildContext get buildContext => _buildContext;
}

class FluttershyWidget<C extends Context> extends StatelessWidget {
  final C context;

  final void Function(C context) setup;
  final void Function(C context, Event event) event;
  final void Function(C context, double deltaTime) update;
  final void Function(C context, Canvas canvas) render;
  final void Function(C context) destroy;

  final Color backgroundColor;

  const FluttershyWidget({
    Key key,
    @required this.context,
    this.setup,
    this.event,
    this.update,
    this.render,
    this.destroy,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext buildContext) {
    return Listener(
      onPointerDown: (rawEvent) => event(
        context,
        PointerDownEvent(rawEvent),
      ),
      onPointerMove: (rawEvent) => event(
        context,
        PointerMoveEvent(rawEvent),
      ),
      onPointerUp: (rawEvent) => event(
        context,
        PointerUpEvent(rawEvent),
      ),
      onPointerSignal: (rawEvent) => event(
        context,
        PointerSignalEvent(rawEvent),
      ),
      onPointerCancel: (rawEvent) => event(
        context,
        PointerCancelEvent(rawEvent),
      ),
      child: LayoutBuilder(
        builder: (buildContext, constraints) {
          return Container(
            color: backgroundColor ?? Colors.black,
            child: _RenderObjectWidget<C>(
              context,
              setup,
              event,
              update,
              render,
              destroy,
              backgroundColor ?? Colors.black,
            ),
          );
        },
      ),
    );
  }
}

class _RenderObjectWidget<C extends Context> extends LeafRenderObjectWidget {
  final C context;

  final void Function(C context) setup;
  final void Function(C context, Event event) event;
  final void Function(C context, double deltaTime) update;
  final void Function(C context, Canvas canvas) render;
  final void Function(C context) destroy;

  final Color backgroundColor;

  _RenderObjectWidget(
    this.context,
    this.setup,
    this.event,
    this.update,
    this.render,
    this.destroy,
    this.backgroundColor,
  );

  @override
  RenderBox createRenderObject(BuildContext buildContext) {
    return RenderConstrainedBox(
        child: _RenderBox<C>(
          buildContext,
          context,
          setup,
          event,
          update,
          render,
          destroy,
          backgroundColor,
        ),
        additionalConstraints: BoxConstraints.expand());
  }

  @override
  void updateRenderObject(
      BuildContext buildContext, RenderConstrainedBox renderBox) {
    renderBox
      ..child = _RenderBox<C>(
        buildContext,
        context,
        setup,
        event,
        update,
        render,
        destroy,
        backgroundColor,
      )
      ..additionalConstraints = BoxConstraints.expand();
  }
}

class _RenderBox<C extends Context> extends RenderBox
    with WidgetsBindingObserver {
  final C context;

  final void Function(C context) setup;
  final void Function(C context, Event event) event;
  final void Function(C context, double deltaTime) update;
  final void Function(C context, Canvas canvas) render;
  final void Function(C context) destroy;

  final Color backgroundColor;

  int _frameCallbackId;
  bool _created;

  Duration _previous;

  _RenderBox(
    BuildContext buildContext,
    this.context,
    this.setup,
    this.event,
    this.update,
    this.render,
    this.destroy,
    this.backgroundColor,
  )   : _created = false,
        _previous = Duration.zero {
    context._assignBuildContext(buildContext);
  }

  @override
  bool get sizedByParent => true;

  @override
  void performResize() {
    super.performResize();

    event(
      context,
      ResizeEvent(
        size: Size(constraints.biggest.width, constraints.biggest.height),
      ),
    );

    // Update on first frame
    if (!_created) {
      update(context, 0);
      _created = true;
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);

    _scheduleTick();
    _bindLifecycleListener();

    setup(context);
  }

  @override
  void detach() {
    super.detach();

    destroy(context);

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

    update(context, deltaTime);
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
    canvas.drawColor(backgroundColor, BlendMode.color);
    canvas.translate(offset.dx, offset.dy);
    canvas.clipRect(Rect.fromLTWH(
      0,
      0,
      constraints.biggest.width,
      constraints.biggest.height,
    ));

    render(context, canvas);

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
    event(
      context,
      AppLifecycleEvent(state: state),
    );
  }
}

import 'dart:ui';

import 'package:flutter/material.dart' hide KeyEvent;
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart' hide KeyEvent;

import 'fluttershy.dart';
import 'math.dart';

class _Fluttershy {
  final Camera camera;

  final void Function()? _setup;
  final void Function(Event event)? _event;
  final void Function(double deltaTime)? _update;
  final void Function(Canvas canvas)? _render;
  final void Function()? _destroy;

  _Fluttershy(
    this.camera,
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
    if (event is ResizeEvent) {
      final size = event.size;

      if (camera.originalSize.x == double.infinity &&
          camera.originalSize.y == double.infinity) {
        camera.size = size;
      } else if (camera.originalSize.x == double.infinity &&
          camera.originalSize.y != double.infinity) {
        camera.size.x = size.x * (camera.size.y / size.y);
      } else if (camera.originalSize.x != double.infinity &&
          camera.originalSize.y == double.infinity) {
        camera.size.y = size.y * (camera.size.x / size.x);
      }
    }

    _event?.call(event);
  }

  void update(double deltaTime) {
    _update?.call(deltaTime);
  }

  void render(PaintingContext paintingContext, Offset offset,
      BoxConstraints constraints) {
    camera.render(
      paintingContext.canvas,
      Vector2(offset.dx, offset.dy),
      Vector2.zero(),
      1.0,
      Vector2(constraints.biggest.width, constraints.biggest.height),
      (canvas) => _render?.call(canvas),
    );
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
    return RenderConstrainedBox(
        child: _FluttershyRenderBox(buildContext, fluttershy),
        additionalConstraints: BoxConstraints.expand());
  }
}

class _FluttershyRenderBox extends RenderBox with WidgetsBindingObserver {
  final BuildContext buildContext;
  final _Fluttershy fluttershy;

  int? _frameCallbackId;

  Duration _previous;

  _FluttershyRenderBox(
    this.buildContext,
    this.fluttershy,
  ) : _previous = Duration.zero;

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
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);

    _scheduleTick();
    _bindLifecycleListener();

    RawKeyboard.instance.addListener(_rawKeyboardListener);

    fluttershy.setup(buildContext);
  }

  @override
  void detach() {
    fluttershy.destroy();

    RawKeyboard.instance.removeListener(_rawKeyboardListener);

    _unscheduleTick();
    _unbindLifecycleListener();

    super.detach();
  }

  void _scheduleTick() {
    _frameCallbackId = SchedulerBinding.instance.scheduleFrameCallback(_tick);
  }

  void _unscheduleTick() {
    if (_frameCallbackId != null) {
      SchedulerBinding.instance.cancelFrameCallbackWithId(_frameCallbackId!);
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

  void _rawKeyboardListener(RawKeyEvent event) {
    fluttershy.event(KeyEvent(rawEvent: event));
  }

  @override
  void paint(PaintingContext paintingContext, Offset offset) {
    fluttershy.render(paintingContext, offset, constraints);
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

  @override
  Size computeDryLayout(BoxConstraints constraints) => constraints.biggest;
}

class Fluttershy extends StatelessWidget {
  final _Fluttershy _fluttershy;

  Fluttershy({
    Camera? camera,
    void Function()? setup,
    void Function(Event event)? event,
    void Function(double deltaTime)? update,
    void Function(Canvas canvas)? render,
    void Function()? destroy,
    Key? key,
  })  : _fluttershy = _Fluttershy(
          camera ??
              Camera(
                size: Vector2(double.infinity, 5.0),
              ),
          setup,
          event,
          update,
          render,
          destroy,
        ),
        super(key: key);

  @override
  Widget build(BuildContext buildContext) {
    return Container(
      child: LayoutBuilder(builder: (context, constraints) {
        _fluttershy.event(
          ResizeEvent(
            size:
                Vector2(constraints.biggest.width, constraints.biggest.height),
          ),
        );

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => _fluttershy.event(TapEvent()),
          onHorizontalDragEnd: (details) =>
              _fluttershy.event(HorizontalDragEndEvent(details: details)),
          onVerticalDragEnd: (details) =>
              _fluttershy.event(VerticalDragEndEvent(details: details)),
          child: _FluttershyRenderObjectWidget(_fluttershy),
        );
      }),
    );
  }
}

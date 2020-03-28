library fluttershy;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' hide Size;
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart' hide Size;
import 'package:fluttershy/foundation/events/app_lifecycle_event.dart';
import 'package:fluttershy/foundation/events/resize_event.dart';
import 'package:fluttershy/foundation/size.dart';
import 'package:fluttershy/foundation/scene.dart';

class Fluttershy extends StatefulWidget {
  final Scene defaultScene;
  final Color backgroundColor;

  const Fluttershy({Key key, this.defaultScene, this.backgroundColor})
      : super(key: key);

  @override
  _FluttershyState createState() => _FluttershyState();
}

class _FluttershyState extends State<Fluttershy> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            color: widget.backgroundColor ?? Colors.black,
            child: _FluttershyWidget(
                widget.defaultScene, widget.backgroundColor ?? Colors.black),
          );
        },
      ),
    );
  }
}

class _FluttershyWidget extends LeafRenderObjectWidget {
  final Scene defaultScene;
  final Color backgroundColor;

  _FluttershyWidget(this.defaultScene, this.backgroundColor);

  @override
  RenderBox createRenderObject(BuildContext context) {
    return RenderConstrainedBox(
        child: _FluttershyRenderBox(context, defaultScene, backgroundColor),
        additionalConstraints: BoxConstraints.expand());
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderConstrainedBox renderBox) {
    renderBox
      ..child = _FluttershyRenderBox(context, defaultScene, backgroundColor)
      ..additionalConstraints = BoxConstraints.expand();
  }
}

class _FluttershyRenderBox extends RenderBox with WidgetsBindingObserver {
  final BuildContext context;
  final Scene defaultScene;
  final Color backgroundColor;

  int _frameCallbackId;
  bool _created;

  Duration _previous;

  _FluttershyRenderBox(this.context, this.defaultScene, this.backgroundColor)
      : _created = false,
        _previous = Duration.zero;

  @override
  bool get sizedByParent => true;

  @override
  void performResize() {
    super.performResize();

    final size = Size(constraints.biggest.width, constraints.biggest.height);

    defaultScene.event(ResizeEvent(size: size));

    // Update on first frame
    if (!_created) {
      defaultScene.update(0);
      _created = true;
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);

    defaultScene.setup(context);

    _scheduleTick();
    _bindLifecycleListener();
  }

  @override
  void detach() {
    super.detach();

    _unscheduleTick();
    _unbindLifecycleListener();

    defaultScene.destroy(context);
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

    defaultScene.update(deltaTime);
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

    if (defaultScene.root.hasCamera) {
      defaultScene.root.camera.onRender(context.canvas);
    }

    defaultScene.root.orderedNodes.forEach((node) {
      node.onRender(context.canvas);
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
    defaultScene.event(AppLifecycleEvent(state: state));
  }
}

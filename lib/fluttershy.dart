library fluttershy;

import 'package:flutter/widgets.dart' hide Size;

import 'package:fluttershy/foundation/size.dart';
import 'package:fluttershy/foundation/config.dart';

class Fluttershy extends StatelessWidget {
  final Config config;

  const Fluttershy({Key key, this.config}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return config.bundles.map((bundle) =>
        bundle.buildMiddleware(context, _FluttershyWidget(config: config)));
/*
    return LayoutBuilder(
      builder: (context, constraints) {
        return RawKeyboardListener(
          focusNode: _focusNode,
          onKey: _onRawKeyEvent,
          autofocus: true,
          child: GestureDetector(
            onTapUp: _onTapUp,
            onHorizontalDragEnd: _onHorizontalDragEnd,
            onVerticalDragEnd: _onVerticalDragEnd,
            child: Container(
              color: backgroudColor,
              child: ,
            ),
          ),
        );
      },
    );*/
  }
}

class _FluttershyWidget extends LeafRenderObjectWidget {
  final Config _config;
  final Size _size;

  _FluttershyWidget({@required Config config, Size size})
      : _size = size,
        _config = config;

  @override
  RenderObject createRenderObject(BuildContext context) {
    // TODO: implement createRenderObject
    throw UnimplementedError();
  }
}

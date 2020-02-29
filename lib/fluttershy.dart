library fluttershy;

import 'package:flutter/widgets.dart' hide Size;

import 'package:fluttershy/foundation/size.dart';
import 'package:fluttershy/foundation/config.dart';

class Fluttershy extends LeafRenderObjectWidget {
  final Config Function() _config;
  final Size _size;

  Fluttershy({@required Config Function() config, Size size})
      : _size = size,
        _config = config;

  @override
  RenderObject createRenderObject(BuildContext context) {
    throw UnimplementedError();
  }
}

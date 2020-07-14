import 'package:flutter/cupertino.dart';

import 'fluttershy.dart';

class FluttershyWidget<E extends Engine, C extends Context> extends StatelessWidget {
  final E engine;

  final C Function()

  final Color backgroundColor;

  const Fluttershy({
    Key key,
    this.game,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

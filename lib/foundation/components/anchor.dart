import 'package:dartex/dartex.dart';

class Anchor with Component<Anchor> {
  final String name;
  const Anchor._(this.name);

  @override
  Anchor copy() {
    return this;
  }

  @override
  String toString() {
    return name;
  }

  static const Anchor topLeft = const Anchor._('TopLeft');
  static const Anchor topCenter = const Anchor._('TopCenter');
  static const Anchor topRight = const Anchor._('TopRight');
  static const Anchor centerLeft = const Anchor._('CenterLeft');
  static const Anchor center = const Anchor._('Center');
  static const Anchor centerRight = const Anchor._('CenterRight');
  static const Anchor bottomLeft = const Anchor._('BottomLeft');
  static const Anchor bottomCenter = const Anchor._('BottomCenter');
  static const Anchor bottomRight = const Anchor._('BottomRight');
}

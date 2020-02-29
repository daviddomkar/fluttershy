import 'package:dartex/resource.dart';
import 'package:fluttershy/foundation/size.dart';

class RendererResource with Resource {
  Size screenSize;

  RendererResource({Size screenSize = const Size()});
}

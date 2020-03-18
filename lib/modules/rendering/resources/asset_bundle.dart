import 'package:dartex/dartex.dart';
import 'package:flutter/services.dart' as flutter;

class AssetBundle with Resource<AssetBundle> {
  flutter.AssetBundle bundle;

  AssetBundle(this.bundle);
}

import 'package:dartex/dartex.dart';

abstract class Dirty<T> with Component<Dirty<T>> {
  bool _isDirty;

  Dirty() : _isDirty = true;

  void markDirty() {
    _isDirty = true;
  }

  void makeClean() {
    _isDirty = false;
  }

  bool get isDirty => _isDirty;
}

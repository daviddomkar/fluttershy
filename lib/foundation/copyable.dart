import 'package:flutter/foundation.dart';

mixin Copyable<T> {
  @required
  T copy();

  T copyWith() {
    return copy();
  }
}

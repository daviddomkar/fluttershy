import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'position.freezed.dart';

@freezed
abstract class Position with _$Position {
  const factory Position(
      [@Default(0) double x,
      @Default(0) double y,
      @Default(0) double z]) = _Position;

  Offset toOffset() {
    return Offset(x, y);
  }
}

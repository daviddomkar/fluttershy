import 'package:freezed_annotation/freezed_annotation.dart';

part 'scale.freezed.dart';

@freezed
abstract class Scale with _$Scale {
  const factory Scale(
      [@Default(0) double x,
      @Default(0) double y,
      @Default(0) double z]) = _Scale;
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'scale.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

mixin _$Scale {
  double get x;
  double get y;
  double get z;

  Scale copyWith({double x, double y, double z});
}

class _$ScaleTearOff {
  const _$ScaleTearOff();

  _Scale call([double x = 0, double y = 0, double z = 0]) {
    return _Scale(
      x,
      y,
      z,
    );
  }
}

const $Scale = _$ScaleTearOff();

class _$_Scale implements _Scale {
  const _$_Scale([this.x = 0, this.y = 0, this.z = 0]);

  @JsonKey(defaultValue: 0)
  @override
  final double x;
  @JsonKey(defaultValue: 0)
  @override
  final double y;
  @JsonKey(defaultValue: 0)
  @override
  final double z;

  @override
  String toString() {
    return 'Scale(x: $x, y: $y, z: $z)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Scale &&
            (identical(other.x, x) ||
                const DeepCollectionEquality().equals(other.x, x)) &&
            (identical(other.y, y) ||
                const DeepCollectionEquality().equals(other.y, y)) &&
            (identical(other.z, z) ||
                const DeepCollectionEquality().equals(other.z, z)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(x) ^
      const DeepCollectionEquality().hash(y) ^
      const DeepCollectionEquality().hash(z);

  @override
  _$_Scale copyWith({
    Object x = freezed,
    Object y = freezed,
    Object z = freezed,
  }) {
    return _$_Scale(
      x == freezed ? this.x : x as double,
      y == freezed ? this.y : y as double,
      z == freezed ? this.z : z as double,
    );
  }
}

abstract class _Scale implements Scale {
  const factory _Scale([double x, double y, double z]) = _$_Scale;

  @override
  double get x;
  @override
  double get y;
  @override
  double get z;

  @override
  _Scale copyWith({double x, double y, double z});
}

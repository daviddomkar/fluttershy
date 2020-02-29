// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'position.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

mixin _$Position {
  double get x;
  double get y;
  double get z;

  Position copyWith({double x, double y, double z});
}

class _$PositionTearOff {
  const _$PositionTearOff();

  _Position call([double x = 0, double y = 0, double z = 0]) {
    return _Position(
      x,
      y,
      z,
    );
  }
}

const $Position = _$PositionTearOff();

class _$_Position with DiagnosticableTreeMixin implements _Position {
  const _$_Position([this.x = 0, this.y = 0, this.z = 0]);

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
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Position(x: $x, y: $y, z: $z)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Position'))
      ..add(DiagnosticsProperty('x', x))
      ..add(DiagnosticsProperty('y', y))
      ..add(DiagnosticsProperty('z', z));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Position &&
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
  _$_Position copyWith({
    Object x = freezed,
    Object y = freezed,
    Object z = freezed,
  }) {
    return _$_Position(
      x == freezed ? this.x : x as double,
      y == freezed ? this.y : y as double,
      z == freezed ? this.z : z as double,
    );
  }
}

abstract class _Position implements Position {
  const factory _Position([double x, double y, double z]) = _$_Position;

  @override
  double get x;
  @override
  double get y;
  @override
  double get z;

  @override
  _Position copyWith({double x, double y, double z});
}

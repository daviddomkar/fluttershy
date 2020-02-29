// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'size.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

mixin _$Size {
  double get width;
  double get height;

  Size copyWith({double width, double height});
}

class _$SizeTearOff {
  const _$SizeTearOff();

  _Size call([double width = 0, double height = 0]) {
    return _Size(
      width,
      height,
    );
  }
}

const $Size = _$SizeTearOff();

class _$_Size implements _Size {
  const _$_Size([this.width = 0, this.height = 0]);

  @JsonKey(defaultValue: 0)
  @override
  final double width;
  @JsonKey(defaultValue: 0)
  @override
  final double height;

  @override
  String toString() {
    return 'Size(width: $width, height: $height)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Size &&
            (identical(other.width, width) ||
                const DeepCollectionEquality().equals(other.width, width)) &&
            (identical(other.height, height) ||
                const DeepCollectionEquality().equals(other.height, height)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(width) ^
      const DeepCollectionEquality().hash(height);

  @override
  _$_Size copyWith({
    Object width = freezed,
    Object height = freezed,
  }) {
    return _$_Size(
      width == freezed ? this.width : width as double,
      height == freezed ? this.height : height as double,
    );
  }
}

abstract class _Size implements Size {
  const factory _Size([double width, double height]) = _$_Size;

  @override
  double get width;
  @override
  double get height;

  @override
  _Size copyWith({double width, double height});
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'size.freezed.dart';

@freezed
abstract class Size with _$Size {
  const factory Size([@Default(0) double width, @Default(0) double height]) =
      _Size;
}

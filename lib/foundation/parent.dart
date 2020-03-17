import 'package:dartex/dartex.dart';
import 'package:flutter/foundation.dart';

class Parent with Component<Parent> {
  final Entity entity;

  Parent({@required this.entity});

  @override
  Parent copy() {
    return Parent(entity: entity);
  }

  @override
  Parent copyWith({Entity entity}) {
    return Parent(entity: entity ?? this.entity);
  }
}

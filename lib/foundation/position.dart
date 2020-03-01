class Position {
  double x;
  double y;
  double z;

  Position(this.x, this.y, this.z);

  factory Position.zero() => Position(0, 0, 0);

  Position copyWith({double x, double y, double z}) {
    return new Position(x ?? this.x, y ?? this.y, z ?? this.z);
  }

  Position add(Position position) {
    x += position.x;
    y += position.y;
    z += position.z;
    return this;
  }
}

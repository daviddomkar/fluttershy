class Scale {
  double x;
  double y;

  Scale(this.x, this.y);

  factory Scale.zero() => Scale(0, 0);

  Scale copyWith({double x, double y}) {
    return new Scale(x ?? this.x, y ?? this.y);
  }
}

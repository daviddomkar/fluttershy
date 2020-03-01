class Scale {
  double x;
  double y;

  Scale(this.x, this.y);

  factory Scale.normal() => Scale(1, 1);

  Scale copyWith({double x, double y}) {
    return new Scale(x ?? this.x, y ?? this.y);
  }
}

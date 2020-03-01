class Size {
  double width;
  double height;

  Size(this.width, this.height);

  factory Size.zero() => Size(0, 0);

  Size copyWith({double width, double height}) {
    return new Size(width ?? this.width, height ?? this.height);
  }
}

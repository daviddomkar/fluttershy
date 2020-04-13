class Size {
  double width;
  double height;

  Size(this.width, [double height]) : height = height ?? width;

  Size copy() {
    return Size(width, height);
  }

  Size copyWith({double width, double height}) {
    return Size(width ?? this.width, height ?? this.height);
  }
}

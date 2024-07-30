class PointerPrototype {
  static const int textureWidth = 320;
  static const int textureHeight = 640;

  int id;
  double x;
  double y;
  double dx;
  double dy;
  bool down;
  bool moved;
  bool pressed;

  PointerPrototype({
    this.id = -1,
    double? x,
    double? y,
    this.dx = 0,
    this.dy = 0,
    this.down = false,
    this.moved = false,
    this.pressed = false,
    int? innerWidth,
    int? innerHeight,
  })  : x = x ?? (innerWidth ?? textureWidth) / 2,
        y = y ?? (innerHeight ?? textureHeight) / 2;
}

mixin LifecycleListener<C extends Context> {
  void setup(BuildContext context) {}

  void update(double deltaTime) {}

  void event(Event event) {}

  void render(Canvas canvas) {}

  void destroy(BuildContext context) {}
}

import 'package:flutter/cupertino.dart';

import 'fluttershy.dart';

mixin SetupListener<C extends Context> {
  void setup(Context context);
}

mixin EventListener<C extends Context> {
  void event(Context context, Event canvas);
}

mixin UpdateListener<C extends Context> {
  void update(Context context, double deltaTime);
}

mixin RenderListener<C extends Context> {
  void render(Context context, Canvas canvas);
}

mixin DestroyListener<C extends Context> {
  void destoy(Context context);
}

mixin LifecycleListener<C extends Context>
    implements
        SetupListener<C>,
        EventListener<C>,
        UpdateListener<C>,
        RenderListener<C>,
        DestroyListener<C> {}

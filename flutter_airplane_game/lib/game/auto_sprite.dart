import 'dart:ui';

import 'sprite.dart';

///自动下落
abstract class AutoSprite extends Sprite {
  AutoSprite({
    required super.themeController,
  });

  @override
  void update(Size size) {
    super.update(size);
    if (!destroyed) {
      move(0, getSpeed());
    }
  }

  double getSpeed() {
    if (destroyed) {
      return 0;
    }
    return 2;
  }
}

import 'sprite.dart';

///自动下落
abstract class AutoSprite extends Sprite {
  AutoSprite({
    required super.themeController,
  });

  @override
  void update() {
    super.update();
    if (!destroyed) {
      move(0, getSpeed());
    } else {}
  }

  double getSpeed() {
    if (destroyed) {
      return 0;
    }
    return 2;
  }
}

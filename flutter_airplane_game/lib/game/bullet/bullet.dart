import '../auto_sprite.dart';

///子弹
abstract class Bullet extends AutoSprite {
  Bullet({
    required super.themeController,
  });

  ///伤害值
  int getDamage();
}

import '../auto_sprite.dart';

import '../bullet/bullet.dart';
import '../explosion/explosion.dart';
import '../game.dart';

///敌机
abstract class EnemyPlane extends AutoSprite {
  /// 敌机的抗打击能力
  int power = 1;

  EnemyPlane({
    required super.themeController,
  });

  ///被子弹攻击
  void attacked(Bullet bullet) {
    if (power > 0) {
      power -= bullet.getDamage();
      if (power <= 0) {
        //死亡
        destroyed = true;
      }
    }
  }

  @override
  double getSpeed() {
    return 2;
  }

  ///分
  int getValue();

  ///爆炸效果图片
  List<String> getExplosionImageList();

  @override
  void onDestroy(Game game) {
    Explosion explosion = Explosion(
      images: getExplosionImageList(),
      size: getSize(),
      speed: 0.5,
      themeController: themeController,
    );
    explosion.moveTo(x, y);
    game.addExplosion(explosion);
  }
}

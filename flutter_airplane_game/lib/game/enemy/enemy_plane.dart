import 'dart:ui';

import '../auto_sprite.dart';

import '../explosion/explosion.dart';
import '../game.dart';

///敌机
abstract class EnemyPlane extends AutoSprite {
  /// 敌机的抗打击能力
  int power = 1;

  /// 打一个敌机的得分
  int value = 0;

  EnemyPlane({
    required super.themeController,
  });

  ///被攻击 damage 伤害
  void attacked(int damage, Game game) {
    if (power > 0) {
      power -= damage;
      if (power <= 0) {
        //死亡
        destroyed = true;
        game.addScore(value);
        //死亡爆炸
        hit(game);
      }
    }
  }

  @override
  double getSpeed() {
    return 2;
  }

  ///爆炸效果图片
  List<String> getExplosionImageList();

  @override
  void hit(Game game) {
    Explosion explosion = Explosion(
      imgs: getExplosionImageList(),
      size: getSize(),
      speed: 0.5,
      themeController: themeController,
    );
    explosion.moveTo(x, y);
    game.addExplosion(explosion);
  }
}

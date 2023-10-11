import 'package:flutter/cupertino.dart';
import '../bullet/bullet.dart';
import '../bullet/default_bullet.dart';
import '../explosion/explosion.dart';
import '../sprite.dart';

import '../game.dart';

///主角
abstract class CombatAircraft extends Sprite {
  ///子弹等级
  int bulletsLevel = 1;
  //奖励时间
  var awardTime = 180;
  var bullets = <Bullet>[];

  CombatAircraft({
    required super.themeController,
  });

  void reset() {
    bulletsLevel = 1;
    destroyed = false;
  }

  @override
  void update(Size size) {
    if (awardTime > 0) {
      awardTime--;
    }
    if (awardTime <= 0) {
      bulletsLevel = 1;
    }
    super.update(size);

    ///子弹
    if (!destroyed && flame % 7 == 0) {
      int c = bulletsLevel ~/ 2;
      String bulletsImage = themeController.bullet1;
      if (bulletsLevel > 1) {
        bulletsImage = themeController.bullet2;
      }
      for (int i = 0; i < bulletsLevel; i++) {
        var bullet = DefaultBullet(image: bulletsImage, themeController: themeController);
        bullet.centerTo(x + getSize().width / 2 - (c - i) * 20, y);
        bullets.add(bullet);
      }
    }
  }

  ///获取发射的子弹列表
  List<Bullet> getBullets() {
    var list = bullets;
    bullets = <Bullet>[];
    return list;
  }

  ///添加物品奖励
  void addAward() {
    bulletsLevel++;
    awardTime = 300;
  }

  ///爆炸效果图片
  List<String> getExplosionImageList();

  @override
  void hit(Game game) {
    Explosion explosion = Explosion(
      images: getExplosionImageList(),
      themeController: themeController,
      size: getSize(),
      speed: 0.5,
    );
    explosion.moveTo(x, y);
    if (!destroyed) {
      game.addExplosion(explosion);
      destroyed = true;
    }
  }
}

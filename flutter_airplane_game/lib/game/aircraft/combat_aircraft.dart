import 'dart:math';

import 'package:flutter/cupertino.dart';
import '../bullet/bullet.dart';
import '../explosion/explosion.dart';
import '../sprite.dart';

import '../game.dart';

///主角
class CombatAircraft extends Sprite {
  /// 是否为单发子弹
  bool single = true;
  var awardTime = 180;
  var bullets = <Bullet>[];

  CombatAircraft({
    required super.themeController,
  }) {
    collideOffset = 20;
  }

  @override
  Size getSize() {
    return const Size(100, 124);
  }

  @override
  void update() {
    if (awardTime > 0) {
      awardTime--;
    }
    if (awardTime <= 0) {
      single = true;
    }
    super.update();

    ///子弹
    if (!destroyed && flame % 7 == 0) {
      if (single) {
        var bullet = Bullet(image: themeController.bullet1, themeController: themeController);
        bullet.centerTo(x + getSize().width / 2, y);
        bullets.add(bullet);
      } else {
        var bullet = Bullet(image: themeController.bullet2, themeController: themeController);
        bullet.centerTo(x + getSize().width / 2 - 10, y);
        bullets.add(bullet);

        var bullet2 = Bullet(image: themeController.bullet2, themeController: themeController);
        bullet2.centerTo(x + getSize().width / 2 + 10, y);
        bullets.add(bullet2);
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
    single = false;
    awardTime = 300;
  }

  @override
  void hit(Game game) {
    Explosion explosion = Explosion(
      imgs: [
        'assets/imgs/hero_blowup_n1.png',
        'assets/imgs/hero_blowup_n2.png',
        'assets/imgs/hero_blowup_n3.png',
        'assets/imgs/hero_blowup_n4.png',
      ],
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

  @override
  String getImage() {
    return (flame % 10) < 5 ? themeController.hero1 : themeController.hero2;
  }
}

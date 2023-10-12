import 'package:flame/game.dart';
import 'package:flame/timer.dart';
import 'package:flutter_tank_game/data/data_manager.dart';

import '../../component/tank/default_tank.dart';
import '../../utils/extension.dart';

import '../../component/tank/tank_factory.dart';
import '../../controller/controller_listener.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';

import 'computer_tank_theater.dart';
import 'decoration_theater.dart';
import 'player_tank_theater.dart';

///游戏裁判
/// * 用于观测[Sprite]之间的交互，并触发衍生交互，
/// * 如：是否击中、[OrangeExplosion]的触发等.
mixin GameJudge on FlameGame, PlayerTankTheater, ComputerTankTheater, DecorationTheater {
  @override
  void update(double dt) {
    super.update(dt);
    if (computers.length < 4) {
      randomSpanTank();
    }

    ///check hit
    checkHit();
  }

  ///命中距离
  /// * 车身位置和炮弹位置小于10 算命中
  final double hitDistance = 10;

  ///检查是否有tank被击中
  void checkHit() {
    player?.bullets.forEach((bullet) {
      for (var c in computers) {
        final Offset hitZone = c.position - bullet.position;
        if (hitZone.distance < hitDistance) {
          c.isDead = true;
          bullet.hit();
          DataManager.instance.score += c.getScore();
          addExplosions(c.position);
        }
      }
    });
    //todo 玩家无敌
    //computerBullets.forEach((element) { });
  }
}

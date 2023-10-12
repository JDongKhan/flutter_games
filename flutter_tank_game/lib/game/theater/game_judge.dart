import 'package:flame/components.dart';
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
  final List<ComputerTank> aliveComputers = [];

  @override
  void update(double dt) {
    super.update(dt);
    if (aliveComputers.length < (4 + DataManager.instance.level)) {
      randomSpanTank();
    }

    ///check hit
    _checkHit();
  }

  @override
  void onChildrenChanged(Component child, ChildrenChangeType type) {
    super.onChildrenChanged(child, type);
    if (type == ChildrenChangeType.removed) {
      aliveComputers.remove(child);
    } else if (type == ChildrenChangeType.added && child is ComputerTank) {
      aliveComputers.add(child);
    }
  }

  ///检查是否有tank被击中
  void _checkHit() {
    player?.bullets.forEach((bullet) {
      for (var c in aliveComputers) {
        Rect rect = bullet.rect.intersect(c.position & c.bodySize);
        //碰撞检测
        bool isCollide = rect.width >= 0 && rect.height >= 0;
        if (isCollide) {
          bullet.hit();
          c.removeFromParent();
          DataManager.instance.score += c.getScore();
          addExplosions(c.position);
        }
      }
    });
    //todo 玩家无敌
    //computerBullets.forEach((element) { });
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';
import 'enemy_plane.dart';

import '../explosion/explosion.dart';
import '../game.dart';

///小型敌机
class SmallEnemyPlane extends EnemyPlane {
  SmallEnemyPlane({
    required super.themeController,
  }) {
    power = 2;
    value = 1000;
    collideOffset = 5;
  }

  @override
  List<String> getExplosionImageList() {
    return [
      'assets/images/enemy1_down1.png',
      'assets/images/enemy1_down2.png',
      'assets/images/enemy1_down3.png',
      'assets/images/enemy1_down4.png',
    ];
  }

  @override
  String getImage() {
    return themeController.enemy4;
  }

  @override
  double getSpeed() {
    return 5;
  }

  @override
  Size getSize() {
    return const Size(51, 39);
  }
}

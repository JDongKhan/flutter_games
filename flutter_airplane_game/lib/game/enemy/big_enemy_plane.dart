import 'dart:ui';
import 'package:flutter/material.dart';
import 'enemy_plane.dart';

///大型敌机
class BigEnemyPlane extends EnemyPlane {
  BigEnemyPlane({
    required super.themeController,
  }) {
    power = 10;
    collideOffset = 10;
  }

  @override
  Size getSize() {
    return const Size(165, 255);
  }

  @override
  String getImage() {
    var img = (flame % 20) < 10 ? themeController.enemy1 : themeController.enemy2;
    return img;
  }

  @override
  double getSpeed() {
    return 2;
  }

  @override
  List<String> getExplosionImageList() {
    return [
      'assets/images/enemy3_down1.png',
      'assets/images/enemy3_down2.png',
      'assets/images/enemy3_down3.png',
      'assets/images/enemy3_down4.png',
      'assets/images/enemy3_down5.png',
      'assets/images/enemy3_down6.png',
    ];
  }

  @override
  int getValue() {
    return 2500;
  }
}

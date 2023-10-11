import 'package:flutter/cupertino.dart';
import 'enemy_plane.dart';

///中型敌机
class MiddleEnemyPlane extends EnemyPlane {
  MiddleEnemyPlane({
    required super.themeController,
  }) {
    power = 4;
    collideOffset = 5;
  }

  @override
  Size getSize() {
    return const Size(69, 89);
  }

  @override
  double getSpeed() {
    return 4;
  }

  @override
  List<String> getExplosionImageList() {
    return [
      'assets/images/enemy2_down1.png',
      'assets/images/enemy2_down2.png',
      'assets/images/enemy2_down3.png',
      'assets/images/enemy2_down4.png',
    ];
  }

  @override
  String getImage() {
    return themeController.enemy3;
  }

  @override
  int getValue() {
    return 500;
  }
}

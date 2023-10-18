import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flame_ext/flame_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/game/component/wall/wall.dart';

mixin MapScene on FlameGame {
  final Random _random = Random();
  final List<Wall> _walls = [];
  @override
  FutureOr onLoad() {
    //先移除旧的
    for (var element in _walls) {
      element.removeFromParent();
    }

    const String src2 = 'adventurer/ember.png';
    var image = images.fromCache(src2);
    SpriteSheet stoneSheet = SpriteSheet.fromColumnsAndRows(image: image, columns: 4, rows: 1);
    List<Sprite> sprites = stoneSheet.getRowSprites(row: 0, start: 0, count: 4);
    SpriteAnimation animation = SpriteAnimation.spriteList(sprites, stepTime: 1 / 10, loop: true);

    for (int i = 0; i < 3; i++) {
      double dx = _random.nextRange(0, size.x.toInt()).toDouble();
      double dy = _random.nextRange(0, size.y.toInt()).toDouble();
      Wall wall = Wall(spriteAnimation: animation, size: Vector2(28, 25), position: Vector2(dx, dy));
      _walls.add(wall);
      world.add(wall);
    }

    //地图背景边框
    final borderComponent = RectangleComponent.fromRect(
      Rect.fromLTRB(0, 0, size.x, size.y),
      paint: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.25
        ..color = const Color(0xaaffff00),
    );
    world.add(borderComponent);
    return super.onLoad();
  }
}

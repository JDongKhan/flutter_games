import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flame_ext/flame_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/game/component/wall/wall.dart';

mixin MapScene on FlameGame {
  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    const String src2 = 'adventurer/ember.png';
    var image = images.fromCache(src2);
    SpriteSheet stoneSheet = SpriteSheet.fromColumnsAndRows(image: image, columns: 4, rows: 1);
    List<Sprite> sprites = stoneSheet.getRowSprites(row: 0, start: 0, count: 4);
    SpriteAnimation animation = SpriteAnimation.spriteList(sprites, stepTime: 1 / 10, loop: true);
    world.add(Wall(spriteAnimation: animation, size: Vector2(28, 25), position: Vector2(200, 200)));

    //地图背景
    final buttonComponent = ButtonComponent(
      button: RectangleComponent(
        size: size,
        paint: Paint()
          ..color = Colors.orange
          ..style = PaintingStyle.stroke,
      ),
      buttonDown: RectangleComponent(
        size: size,
        paint: Paint()
          ..color = Colors.orange
          ..style = PaintingStyle.stroke,
      ),
      position: Vector2(0, 0),
      onPressed: () {},
    );
    world.add(buttonComponent);
    return;
  }
}

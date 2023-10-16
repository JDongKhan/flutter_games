import 'dart:async';

import 'package:flame/game.dart';
import 'package:flame/camera.dart';
import 'package:flame/sprite.dart';
import 'package:flame_ext/flame_ext.dart';
import 'package:flutter_game/game/component/wall/wall.dart';

import 'player_scene.dart';

mixin MapScene on FlameGame {
  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    // camera.viewport = FixedSizeViewport(1500, 400);
    // camera.follow(player!);
    const String src2 = 'adventurer/ember.png';
    var image = images.fromCache(src2);
    SpriteSheet stoneSheet = SpriteSheet.fromColumnsAndRows(image: image, columns: 4, rows: 1);
    List<Sprite> sprites = stoneSheet.getRowSprites(row: 0, start: 0, count: 4);
    SpriteAnimation animation = SpriteAnimation.spriteList(sprites, stepTime: 1 / 10, loop: true);
    add(Wall(spriteAnimation: animation, size: Vector2(28, 25), position: Vector2(200, 200)));
    return;
  }
}

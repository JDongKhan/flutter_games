import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_tank_game/component/background/background.dart';
import 'package:flutter_tank_game/utils/extension.dart';
import 'package:vector_math/vector_math_64.dart';

import '../../component/explosion/orange_explosion.dart';

///负责装饰性场景及衍生的[Sprite]
/// *爆炸。
mixin DecorationTheater on FlameGame {
  final List<OrangeExplosion> explosions = [];

  ///在[pos]位置添加一个爆炸效果
  void addExplosions(Offset pos) {
    explosions.add(OrangeExplosion(pos));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    explosions.render(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);
    explosions.update(dt);
    explosions.removeWhere((element) => element.playDone);
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);
    explosions.onGameResize(canvasSize);
  }
}

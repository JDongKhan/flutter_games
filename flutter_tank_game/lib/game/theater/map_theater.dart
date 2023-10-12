import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_tank_game/component/background/background.dart';
import 'package:flutter_tank_game/utils/extension.dart';
import 'package:vector_math/vector_math_64.dart';

import '../../component/explosion/orange_explosion.dart';

///地图
mixin MapTheater on FlameGame {
  final BattleBackground _bg = BattleBackground();

  @override
  void render(Canvas canvas) {
    _bg.render(canvas);
    super.render(canvas);
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    _bg.onGameResize(canvasSize);
    super.onGameResize(canvasSize);
  }
}

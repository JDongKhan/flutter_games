import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/image_composition.dart';
import 'package:flame/sprite.dart';
import 'package:flutter_tank_game/component/background/background.dart';

import '../../component/obstacle/my_obstacle.dart';

///地图
mixin MapTheater on FlameGame {
  final BattleBackground _bg = BattleBackground();

  @override
  void onMount() {
    add(_bg);
    //添加障碍物
    add(MyObstacle(Vector2(100, 100)));
    super.onMount();
  }
}

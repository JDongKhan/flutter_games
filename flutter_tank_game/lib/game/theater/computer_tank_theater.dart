import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flame/timer.dart';
import 'package:flutter_tank_game/utils/extension.dart';

import '../../component/tank/default_tank.dart';
import '../../component/tank/tank_factory.dart';

///负责电脑坦克
mixin ComputerTankTheater on FlameGame {
  ///生成机器人坦克
  final ComputerTankSpawner _computerSpawner = ComputerTankSpawner();

  ///随机敌人
  void randomSpanTank() {
    ComputerTank tank = _computerSpawner.randomSpan();
    add(tank);
  }

  @override
  void onMount() {
    //初始化机器人管理器
    List<ComputerTank> list = _computerSpawner.init(canvasSize.toSize());
    for (var element in list) {
      add(element);
    }
    super.onMount();
  }
}

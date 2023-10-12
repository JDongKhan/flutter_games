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

  ///机器人坦克
  final List<ComputerTank> _computers = [];
  get computers => _computers;

  Timer? _timer;

  ///初始化敌军
  ///一般情况下是在游戏伊始时执行。
  void _initEnemyTank() {
    _computerSpawner.fastSpawn(_computers);
  }

  ///随机敌人
  void randomSpanTank() {
    _computerSpawner.randomSpan(_computers);
  }

  ///电脑开火
  void onFireTimerTrigger() {
    _computers.shuffle();
    for (var element in _computers) {
      element.fire();
    }
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    _timer ??= Timer(1, repeat: true, onTick: onFireTimerTrigger);
    if (_computers.isEmpty) {
      //初始化机器人管理器
      _computerSpawner.warmUp(canvasSize.toSize());
      _initEnemyTank();
      for (var element in _computers) {
        element.deposit();
      }
    }
    _computers.onGameResize(canvasSize);
    super.onGameResize(canvasSize);
  }

  @override
  void render(Canvas canvas) {
    _computers.render(canvas);
    super.render(canvas);
  }

  @override
  void update(double dt) {
    _timer?.update(dt);
    _computers.update(dt);
    super.update(dt);
    _computers.removeWhere((element) => element.isDead);
  }

  @override
  void onDetach() {
    _timer?.stop();
    super.onDetach();
  }
}

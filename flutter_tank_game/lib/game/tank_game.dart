import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_tank_game/component/explosion/decoration_theater.dart';
import 'package:flutter_tank_game/observer/game_observer.dart';
import 'package:flutter_tank_game/utils/computer_timer.dart';
import '../component/tank/base_tank.dart';
import '../component/tank/default_tank.dart';
import '../utils/extension.dart';

import '../component/tank/bullet/bullet.dart';
import '../component/tank/tank_factory.dart';
import '../controller/controller_listener.dart';

///游戏入口
/// * 继承于[FlameGame]
/// * 所混入的类 : [BulletTheater]、[TankTheater]、[ComputerTimer]、[DecorationTheater]、[GameObserver]
/// *           用于拓展[TankGame]的场景内容和[Sprite]交互行为，具体见各自的注释。
class TankGame extends FlameGame with BulletTheater, TankTheater, ComputerTimer, DecorationTheater, GameObserver {
  TankGame() {
    setTimerListener(this);
  }
}

///负责管理玩家和电脑tank
mixin TankTheater on FlameGame, BulletTheater implements TankController, ComputerTimerListener {
  ///生成机器人坦克
  final ComputerTankSpawner _computerSpawner = ComputerTankSpawner();

  PlayerTank? _player;

  ///机器人坦克
  final List<ComputerTank> _computers = [];
  get computers => _computers;

  ///初始化玩家
  void initPlayer(Vector2 canvasSize) {
    final Size bgSize = canvasSize.toSize();

    final TankModelBuilder playerBuilder =
        TankModelBuilder(id: DateTime.now().millisecondsSinceEpoch, bodySpritePath: 'tank/t_body_blue.webp', turretSpritePath: 'tank/t_turret_blue.webp', activeSize: bgSize);

    _player ??= TankFactory.buildPlayerTank(playerBuilder.build(), Offset(bgSize.width / 2, bgSize.height / 2));
    _player?.deposit();
  }

  ///初始化敌军
  /// * 一般情况下是在游戏伊始时执行。
  void _initEnemyTank() {
    _computerSpawner.fastSpawn(_computers);
  }

  void randomSpanTank() {
    _computerSpawner.randomSpan(_computers);
  }

  @override
  void onFireTimerTrigger() {
    _computers.shuffle();
    _computers.forEach(computerTankFire);
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    if (_player == null) {
      initPlayer(canvasSize);
    }
    if (_computers.isEmpty) {
      //初始化机器人管理器
      _computerSpawner.warmUp(canvasSize.toSize());
      _initEnemyTank();
      for (var element in _computers) {
        element.deposit();
      }
    }
    _player?.onGameResize(canvasSize);
    _computers.onGameResize(canvasSize);
    super.onGameResize(canvasSize);
  }

  @override
  void render(Canvas canvas) {
    _player?.render(canvas);
    _computers.render(canvas);
    super.render(canvas);
  }

  @override
  void update(double dt) {
    _player?.update(dt);
    _computers.update(dt);
    super.update(dt);
    _computers.removeWhere((element) => element.isDead);
  }

  @override
  void fireButtonTriggered() {
    if (_player != null) {
      playerTankFire(_player!);
    }
  }

  ///机器旋转
  @override
  void bodyAngleChanged(Offset newAngle) {
    if (newAngle == Offset.zero) {
      _player?.targetBodyAngle = null;
    } else {
      _player?.targetBodyAngle = newAngle.direction; //范围（pi,-pi）
    }
  }

  ///开火系统旋转
  @override
  void turretAngleChanged(Offset newAngle) {
    if (newAngle == Offset.zero) {
      _player?.targetTurretAngle = null;
    } else {
      _player?.targetTurretAngle = newAngle.direction;
    }
  }
}

///负责坦克的开火系统
mixin BulletTheater on FlameGame {
  ///电脑tank的开火器
  final BulletTrigger _trigger = BulletTrigger();

  ///玩家炮弹最大数量
  final int _maxPlayerBulletNum = 20;

  ///电脑的子弹
  final List<BaseBullet> _computerBullets = [];

  ///玩家的子弹
  final List<BaseBullet> _playerBullets = [];
  get playerBullets => _playerBullets;

  ///玩家开火
  void playerTankFire(BaseTank tank) {
    if (_playerBullets.length < _maxPlayerBulletNum) {
      _playerBullets.add(tank.getBullet());
    }
  }

  ///电脑开火
  void computerTankFire(BaseTank tank) {
    _trigger.chargeLoading(() {
      _computerBullets.add(tank.getBullet());
    });
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    _computerBullets.onGameResize(canvasSize);
    _playerBullets.onGameResize(canvasSize);
    super.onGameResize(canvasSize);
  }

  @override
  void render(Canvas canvas) {
    _computerBullets.render(canvas);
    _playerBullets.render(canvas);
    super.render(canvas);
  }

  @override
  void update(double dt) {
    _computerBullets.update(dt);
    _playerBullets.update(dt);
    super.update(dt);
    _computerBullets.removeWhere((element) => element.dismissible);
    _playerBullets.removeWhere((element) => element.dismissible);
  }
}

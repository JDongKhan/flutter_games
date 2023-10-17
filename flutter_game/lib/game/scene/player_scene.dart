import 'dart:async';
import 'dart:io';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../component/player/player.dart';

mixin PlayerScene on FlameGame {
  ///游戏玩家
  Player? _player;
  Player? get player => _player;

  @override
  FutureOr<void> onLoad() async {
    List<Sprite> sprites = [];
    //人物
    for (int i = 0; i <= 8; i++) {
      sprites.add(await loadSprite('adventurer/adventurer-bow-0$i.png'));
    }
    final PlayerAttr heroAttr = PlayerAttr(
      life: 3000,
      speed: 1000,
      bulletSpeed: 500,
      attackSpeed: 200,
      attackRange: 500,
      attack: 50,
      crit: 0.75,
      critDamage: 1.5,
    );
    SpriteAnimation animation = SpriteAnimation.spriteList(sprites, stepTime: 10 / heroAttr.attackSpeed, loop: false);
    //子弹
    Sprite bulletSprite = await loadSprite('adventurer/weapon_arrow.png');
    SpriteAnimation bulletAnimation = SpriteAnimation.spriteList([bulletSprite], stepTime: 0.1, loop: false);
    _player = Player(
      initPosition: size / 2,
      bulletAnimation: bulletAnimation,
      attr: heroAttr,
      spriteAnimation: animation,
      size: Vector2(50, 37),
    );
    world.add(_player!);
    //跟随玩家
    camera.follow(_player!);
    return super.onLoad();
  }
}

///操作杆
mixin JoystickScene on PlayerScene, TapDetector {
  ///操作杆
  JoystickComponent? joystick;

  ButtonComponent? fight;

  @override
  FutureOr<void> onLoad() {
    if (Platform.isIOS || Platform.isAndroid) {
      _addJoystick();
      _addFightButton();
    }
    return super.onLoad();
  }

  ///添加操作杆
  void _addJoystick() {
    final knobPaint = BasicPalette.white.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.white.withAlpha(100).paint();
    joystick = JoystickComponent(
      knob: CircleComponent(radius: 25, paint: knobPaint),
      background: CircleComponent(radius: 60, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );
    add(joystick!);
  }

  void _addFightButton() {
    fight = HudButtonComponent(
      button: CircleComponent(radius: 35, paint: BasicPalette.white.withAlpha(240).paint()),
      buttonDown: CircleComponent(radius: 35, paint: BasicPalette.white.withAlpha(100).paint()),
      margin: const EdgeInsets.only(right: 25, bottom: 50),
      onPressed: () {
        _player?.shoot();
      },
    );
    camera.viewport.add(fight!);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // print(dt);
    // print(joystick.delta.screenAngle()*180/pi);
    // print(joystick.relativeDelta);

    var joystick = this.joystick;
    var player = _player;
    // 角色移动
    if (joystick != null && player != null) {
      if (!joystick.delta.isZero()) {
        double step = (_player?.attr.speed ?? 200) * 10;
        step = step / 60;
        Vector2 ds = joystick.relativeDelta * step * dt;
        player.move(ds);
        if (joystick.delta.x < 0) {
          player.flipLeft();
        } else {
          player.flipRight();
        }
      }

      // 角色旋转
      // if (!joystick!.delta.isZero()) {
      //   _player.rotateTo(joystick!.delta.screenAngle());
      // } else {
      //   _player.rotateTo(0);
      // }
    }
  }

  @override
  void onTap() {
    //射击
    _player?.shoot();
    super.onTap();
  }
}

///处理键盘事件
mixin KeyboardScene on PlayerScene, KeyboardEvents {
  ///两种实现方式  这个麻烦
  final Map<LogicalKeyboardKey, double> _keyWeights = {
    LogicalKeyboardKey.keyW: 0,
    LogicalKeyboardKey.keyA: 0,
    LogicalKeyboardKey.keyS: 0,
    LogicalKeyboardKey.keyD: 0,
  };
  final Vector2 _direction = Vector2.zero();
  static const int _speed = 200;

  bool _handleKey(LogicalKeyboardKey key, bool isDown) {
    _keyWeights[key] = isDown ? 1 : 0;
    return true;
  }

  double get xInput => _keyWeights[LogicalKeyboardKey.keyD]! - _keyWeights[LogicalKeyboardKey.keyA]!;
  double get yInput => _keyWeights[LogicalKeyboardKey.keyS]! - _keyWeights[LogicalKeyboardKey.keyW]!;

  @override
  void onMount() {
    add(
      KeyboardListenerComponent(
        keyUp: {
          LogicalKeyboardKey.keyA: (keys) => _handleKey(LogicalKeyboardKey.keyA, false),
          LogicalKeyboardKey.keyD: (keys) => _handleKey(LogicalKeyboardKey.keyD, false),
          LogicalKeyboardKey.keyW: (keys) => _handleKey(LogicalKeyboardKey.keyW, false),
          LogicalKeyboardKey.keyS: (keys) => _handleKey(LogicalKeyboardKey.keyS, false),
        },
        keyDown: {
          LogicalKeyboardKey.keyA: (keys) => _handleKey(LogicalKeyboardKey.keyA, true),
          LogicalKeyboardKey.keyD: (keys) => _handleKey(LogicalKeyboardKey.keyD, true),
          LogicalKeyboardKey.keyW: (keys) => _handleKey(LogicalKeyboardKey.keyW, true),
          LogicalKeyboardKey.keyS: (keys) => _handleKey(LogicalKeyboardKey.keyS, true),
        },
      ),
    );
    super.onMount();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _direction
      ..setValues(xInput, yInput)
      ..normalize();
    final displacement = _direction * (_speed * dt);
    _player?.move(displacement);
  }

  ///两种实现方式  这个比较简单
  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isKeyDown = event is RawKeyDownEvent;
    var player = _player;
    if (event.logicalKey == LogicalKeyboardKey.keyY && isKeyDown) {
      player?.flip(y: true);
    }
    if (event.logicalKey == LogicalKeyboardKey.keyX && isKeyDown) {
      player?.flip(x: true);
    }

    double step = _player?.attr.speed ?? 200;
    step = step / 60;
    if ((event.logicalKey == LogicalKeyboardKey.arrowUp || event.logicalKey == LogicalKeyboardKey.keyW) && isKeyDown) {
      player?.move(Vector2(0, -step));
    }
    if ((event.logicalKey == LogicalKeyboardKey.arrowDown || event.logicalKey == LogicalKeyboardKey.keyS) && isKeyDown) {
      player?.move(Vector2(0, step));
    }
    if ((event.logicalKey == LogicalKeyboardKey.arrowLeft || event.logicalKey == LogicalKeyboardKey.keyA) && isKeyDown) {
      player?.move(Vector2(-step, 0));
      if (player?.isLeft ?? false) {
        player?.flip();
      }
    }
    if ((event.logicalKey == LogicalKeyboardKey.arrowRight || event.logicalKey == LogicalKeyboardKey.keyD) && isKeyDown) {
      player?.move(Vector2(step, 0));
      if (!(player?.isLeft ?? false)) {
        player?.flip();
      }
    }

    //攻击
    if (event.logicalKey == LogicalKeyboardKey.keyJ && isKeyDown) {
      _player?.shoot();
    }
    return super.onKeyEvent(event, keysPressed);
  }
}

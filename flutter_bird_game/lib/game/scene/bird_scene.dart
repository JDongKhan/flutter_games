import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter_bird_game/game/components/bird.dart';

mixin BirdScene on FlameGame {
  final Random _random = Random();
  Timer? _timer;
  @override
  FutureOr<void> onLoad() async {
    add(await _generateNewBird());
    _timer = Timer(1, repeat: true, onTick: _onTick);
    _timer?.start();
    return super.onLoad();
  }

  void _onTick() async {
    print('生成新的鸟');
    add(await _generateNewBird());
  }

  Future<Bird> _generateNewBird() async {
    SpriteAnimation animation = await _loadBirdSprite();
    Bird bird = Bird(animation: animation);
    bird.size = Vector2(50, 50);
    double dy = _random.nextInt(size.y.toInt()).toDouble();
    bird.position = Vector2(size.x, dy.toDouble());
    return bird;
  }

  Future<SpriteAnimation> _loadBirdSprite() async {
    List<Sprite> sprites = [];
    for (int i = 0; i <= 1; i++) {
      sprites.add(await loadSprite('bird-$i-left.png'));
    }
    SpriteAnimation animation = SpriteAnimation.spriteList(sprites, stepTime: 0.1);
    return animation;
  }

  @override
  void update(double dt) {
    _timer?.update(dt);
    super.update(dt);
  }
}

import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/sprite.dart';

import '../base_component.dart';

class OrangeExplosion extends SpriteAnimationGroupComponent {
  OrangeExplosion();

  @override
  FutureOr<void> onLoad() async {
    size = Vector2(30, 30);
    await init();
  }

  Future init() async {
    ///爆炸纹理
    final List<Sprite> sprites = [];
    sprites.add(await Sprite.load('explosion/explosion1.webp'));
    sprites.add(await Sprite.load('explosion/explosion2.webp'));
    sprites.add(await Sprite.load('explosion/explosion3.webp'));
    sprites.add(await Sprite.load('explosion/explosion4.webp'));
    sprites.add(await Sprite.load('explosion/explosion5.webp'));

    SpriteAnimation running = SpriteAnimation.spriteList(sprites, stepTime: 0.1, loop: false);
    animations = {
      'running': running,
    };
    //当前状态是running
    current = 'running';
    //完成
    animationTicker?.onComplete = () {
      removeFromParent();
    };

    super.onLoad();
  }
}

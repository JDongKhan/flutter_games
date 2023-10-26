import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'anim_bullet.dart';

class Player extends SpriteAnimationComponent with HasGameRef, CollisionCallbacks {
  final SpriteAnimation stoneBullet;
  Player({required SpriteAnimation spriteAnimation, required this.stoneBullet}) : super(animation: spriteAnimation, size: Vector2(200, 100), anchor: Anchor.center);

  ///得分
  int score = 0;

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox()..debugMode = false);
    return super.onLoad();
  }

  void shoot() {
    AnimBullet bullet = AnimBullet(animation: stoneBullet, maxRange: 200, speed: 200, size: Vector2(100, 30));
    bullet.angle = pi;
    bullet.priority = 1;
    bullet.anchor = Anchor.center;
    priority = 2;
    bullet.position = position + Vector2(60, 15);
    game.add(bullet);
  }

  void move(Vector2 offset) {
    position = position + offset;
    position = Vector2(position.x.clamp(0, game.size.x), position.y.clamp(0, game.size.y));
  }
}

import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter_bird_game/game/components/anim_bullet.dart';

class Bird extends SpriteAnimationComponent with CollisionCallbacks {
  Bird({
    required SpriteAnimation animation,
    required Vector2 size,
  }) : super(animation: animation, size: size);

  @override
  FutureOr<void> onLoad() {
    Vector2 hitSize = Vector2(10, size.y - 10);
    add(RectangleHitbox(size: hitSize)
      ..position = Vector2(size.x / 2 - hitSize.x / 2, size.y / 2 - hitSize.y / 2)
      ..debugMode = false);
    return super.onLoad();
  }

  double speed = 100;

  @override
  void update(double dt) {
    super.update(dt);
    Vector2 ds = Vector2(-1, 0) * speed * dt;
    position.add(ds);
    if (position.x < 0) {
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is AnimBullet) {
      print('鸟死亡');
      removeFromParent();
    }
    super.onCollision(intersectionPoints, other);
  }
}

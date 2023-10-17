import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter_bird_game/game/components/anim_bullet.dart';

class Bird extends SpriteAnimationComponent with CollisionCallbacks {
  Bird({
    required SpriteAnimation animation,
  }) : super(animation: animation);

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox()..debugMode = false);
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

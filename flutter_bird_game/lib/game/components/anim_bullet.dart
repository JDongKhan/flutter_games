import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

enum BulletType { hero, monster }

class AnimBullet extends SpriteAnimationComponent with CollisionCallbacks {
  double speed = 200;
  final double maxRange;

  AnimBullet({
    required SpriteAnimation animation,
    required this.maxRange,
    required this.speed,
  }) : super(animation: animation);

  double _length = 0;

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox()..debugMode = true);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    Vector2 ds = Vector2(1, 0) * speed * dt;
    _length += ds.length;
    position.add(ds);
    if (_length > maxRange) {
      _length = 0;
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    print('碰撞了子弹');
    super.onCollision(intersectionPoints, other);
  }
}

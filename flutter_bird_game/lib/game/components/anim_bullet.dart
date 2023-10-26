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
    required Vector2 size,
  }) : super(animation: animation, size: size);

  double _length = 0;

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox()..debugMode = false);
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
}

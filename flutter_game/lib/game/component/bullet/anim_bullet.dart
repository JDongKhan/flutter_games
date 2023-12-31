import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter_game/global/config.dart';

import '../monster/monster.dart';
import '../player/player.dart';
import '../wall/wall.dart';

enum BulletType { hero, monster }

class AnimBullet extends SpriteAnimationComponent with CollisionCallbacks {
  double speed = 200;
  final double maxRange;
  final BulletType type;
  final PlayerAttr attr;
  final bool isLeft;
  final int? playerId;

  AnimBullet({
    required SpriteAnimation animation,
    required this.maxRange,
    required this.type,
    required this.speed,
    required this.attr,
    this.isLeft = true,
    this.playerId,
  }) : super(animation: animation);

  @override
  Future<void> onLoad() async {
    switch (type) {
      case BulletType.hero:
        if (!isLeft) angle = pi;
        break;
      case BulletType.monster:
        if (isLeft) angle = pi;
        break;
    }
    addHitBox();
  }

  void addHitBox() {
    add(RectangleHitbox()..debugMode = Config.showOutline);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (type == BulletType.hero && other is Monster) {
      removeFromParent();
    }
    if (type == BulletType.monster && other is Player) {
      removeFromParent();
    }
    if (other is Wall && intersectionPoints.length == 2) {
      //检测障碍物
      removeFromParent();
    }
  }

  double _length = 0;

  @override
  void update(double dt) {
    super.update(dt);
    Vector2 ds = Vector2(isLeft ? 1 : -1, 0) * speed * dt;
    _length += ds.length;
    position.add(ds);
    if (_length > maxRange) {
      _length = 0;
      removeFromParent();
    }
  }
}

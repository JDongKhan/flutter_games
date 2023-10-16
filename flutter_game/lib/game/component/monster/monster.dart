import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_ext/flame_ext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_game/config/config.dart';
import '../bullet/anim_bullet.dart';
import '../life/liveable.dart';
import '../player/player.dart';

class Monster extends SpriteAnimationComponent with CollisionCallbacks, Liveable, HasGameRef {
  SpriteAnimation bulletSprite;
  PlayerAttr attr;
  bool isLeft = false;
  final Vector2 bulletSize;
  final Random _random = Random();
  late Timer _timer;

  Monster({
    required SpriteAnimation animation,
    required this.bulletSize,
    required Vector2 size,
    required Vector2 position,
    required this.bulletSprite,
    required this.attr,
  }) : super(
          animation: animation,
          size: size,
          position: position,
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    _timer = Timer(3, onTick: addBullet, repeat: true);
    initPaint(lifePoint: attr.life);
    addHitBox();
  }

  @override
  void onDied() {
    removeFromParent();
    debugPrint('怪物死亡了');
  }

  @override
  void onMount() {
    super.onMount();
    _timer.start();
  }

  int _step = 0;
  int _randomAngle = 180;
  @override
  void update(double dt) {
    super.update(dt);
    _timer.update(dt);
    //随机移动轨迹
    _step++;
    if (_step == 100) {
      _randomAngle = _random.nextRange(-360, 360);
      _step = 0;
    }
    position += Offset.fromDirection(_randomAngle.toDouble() * (pi / 180), attr.speed * dt).toVector2();
    if (position.x < size.x / 2) {
      position.x = size.x / 2;
    } else if (position.x > (game.size.x - size.x / 2)) {
      position.x = game.size.x - size.x / 2;
    }
    if (position.y < size.y / 2) {
      position.y = size.y / 2;
    } else if (position.y > (game.size.y - size.y / 2)) {
      position.y = game.size.y - size.y / 2;
    }
    isLeft = position.x < game.size.x / 2;
  }

  @override
  void onRemove() {
    super.onRemove();
    _timer.stop();
  }

  // 添加子弹
  void addBullet() {
    AnimBullet bullet = AnimBullet(
      attr: attr,
      type: BulletType.monster,
      animation: bulletSprite,
      maxRange: attr.attackRange,
      speed: attr.bulletSpeed,
      isLeft: isLeft,
    );
    bullet.size = bulletSize;
    bullet.anchor = Anchor.center;
    bullet.priority = 1;
    priority = 2;
    bullet.position = position - Vector2(0, size.y / 2);
    gameRef.add(bullet);
  }

  void addHitBox() {
    add(RectangleHitbox()..debugMode = Config.showOutline);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is AnimBullet && other.type == BulletType.hero) {
      loss(other.attr);
    }
  }

  void move(Vector2 ds) {
    position.add(ds);
  }

  Monster copyWith({
    SpriteAnimation? animation,
    Vector2? bulletSize,
    Vector2? size,
    Vector2? position,
    SpriteAnimation? bulletSprite,
    PlayerAttr? attr,
  }) {
    return Monster(
      animation: animation ?? this.animation!,
      bulletSize: bulletSize ?? this.bulletSize,
      size: size ?? this.size,
      position: position ?? this.position,
      bulletSprite: bulletSprite ?? this.bulletSprite,
      attr: attr ?? this.attr,
    );
  }
}

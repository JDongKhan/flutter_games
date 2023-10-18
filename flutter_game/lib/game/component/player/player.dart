import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/global/config.dart';

import '../body/body.dart';
import '../bullet/anim_bullet.dart';
import '../life/life.dart';
import '../wall/wall.dart';

class PlayerAttr {
  // 生命值
  double life;
  //速度  1s的速度  1帧走了多少像素
  double speed;
  // 攻击速度
  double attackSpeed;

  // 子弹飞行速度
  double bulletSpeed;
  // 射程
  double attackRange;
  // 攻击力
  double attack;
  // 暴击率
  double crit;
  // 暴击伤害
  double critDamage;

  ///价值分数
  int score;

  PlayerAttr({
    required this.life,
    required this.speed,
    required this.attackSpeed,
    required this.attackRange,
    required this.attack,
    required this.crit,
    required this.critDamage,
    required this.bulletSpeed,
    required this.score,
  });

  PlayerAttr copyWith({
    double? life,
    double? speed,
    double? bulletSpeed,
    double? attackSpeed,
    double? attackRange,
    double? attack,
    double? crit,
    double? critDamage,
    int? score,
  }) {
    return PlayerAttr(
      life: life ?? this.life,
      speed: speed ?? this.speed,
      bulletSpeed: bulletSpeed ?? this.bulletSpeed,
      attackSpeed: attackSpeed ?? this.attackSpeed,
      attackRange: attackRange ?? this.attackRange,
      attack: attack ?? this.attack,
      crit: crit ?? this.crit,
      critDamage: critDamage ?? this.critDamage,
      score: score ?? this.score,
    );
  }
}

class Player extends PositionComponent with HasGameRef, CollisionCallbacks {
  PlayerAttr attr;
  late Body adventurer;
  late LifeComponent lifeComponent;
  bool isLeft = true;

  ///任务
  late SpriteAnimation bulletAnimation;

  ///子弹
  final SpriteAnimation spriteAnimation;

  ///死亡回调
  final Function? onDead;

  ///玩家id
  late int playerId;

  Player({
    required initPosition,
    required this.attr,
    required this.spriteAnimation,
    required this.bulletAnimation,
    required Vector2 size,
    this.onDead,
  }) : super(size: size, anchor: Anchor.center, position: initPosition) {
    playerId = DateTime.now().millisecondsSinceEpoch;
  }

  @override
  Future<void> onLoad() async {
    adventurer = Body(size: size, spriteAnimation: spriteAnimation, onLastFrame: addBullet);
    adventurer.position = adventurer.size / 2;
    lifeComponent = LifeComponent(lifePoint: attr.life, lifeColor: Colors.blue, position: adventurer.position, size: adventurer.size);
    add(adventurer);
    add(lifeComponent);
    addHitBox();
  }

  void addHitBox() {
    add(RectangleHitbox()..debugMode = Config.showOutline);
  }

  ///碰撞检测
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is AnimBullet && other.type == BulletType.monster) {
      loss(other.attr);
    } else if (other is Wall && intersectionPoints.length == 2) {
      //检测障碍物
      var pointA = intersectionPoints.elementAt(0);
      var pointB = intersectionPoints.elementAt(1);
      final mid = (pointA + pointB) / 2;
      final collisionVector = absoluteCenter - mid;
      if (pointA.x == pointB.x || pointA.y == pointB.y) {
        // Hitting a side without touching a corner
        double penetrationDepth = (size.x / 2) - collisionVector.length;
        collisionVector.normalize();
        position += collisionVector.scaled(penetrationDepth);
      } else {
        position += cornerBumpDistance(collisionVector, pointA, pointB);
      }
    }
  }

  // 添加子弹
  void addBullet() {
    AnimBullet bullet = AnimBullet(
      animation: bulletAnimation,
      attr: attr,
      type: BulletType.hero,
      maxRange: attr.attackRange,
      speed: attr.bulletSpeed,
      isLeft: isLeft,
      playerId: playerId,
    );
    bullet.size = Vector2(32, 32);
    bullet.anchor = Anchor.center;
    bullet.priority = 1;
    priority = 2;
    bullet.position = position - Vector2(0, -3);
    gameRef.world.add(bullet);
  }

  void flipLeft() {
    if (!isLeft) {
      return;
    }
    flip(y: true);
    isLeft = false;
  }

  void flipRight() {
    if (isLeft) {
      return;
    }
    flip(y: true);
    isLeft = true;
  }

  void flip({
    bool x = false,
    bool y = true,
  }) {
    adventurer.flip(x: x, y: y);
    isLeft = !isLeft;
  }

  void shoot() {
    adventurer.shoot();
  }

  void move(Vector2 ds) {
    position.add(ds);
  }

  void rotateTo(double deg) {
    adventurer.angle = deg;
  }

  void _checkFlip(Vector2 target) {
    if (target.x < position.x) {
      if (isLeft) {
        flip();
      }
    }
    if (target.x > position.x) {
      if (!isLeft) {
        flip();
      }
    }
  }

  void moveTo(Vector2 target) {
    _checkFlip(target);
    removeAll(children.whereType<MoveEffect>());
    double timeMs = (target - position).length / attr.speed;
    add(
      MoveEffect.to(
        target,
        EffectController(
          duration: timeMs,
        ),
      ),
    );
  }

  void loss(
    PlayerAttr attr,
  ) {
    lifeComponent.loss(attr, onDied: () {
      debugPrint('玩家已死亡');
      onDead?.call();
      removeFromParent();
    });
  }

  @override
  void update(double dt) {
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
    super.update(dt);
  }
}

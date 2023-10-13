import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class MyObstacle extends SpriteComponent with CollisionCallbacks {
  final _collisionStartColor = Colors.yellow;
  final _defaultColor = Colors.black;
  late ShapeHitbox hitBox;

  MyObstacle(Vector2 position)
      : super(
          position: position,
          size: Vector2.all(50),
          anchor: Anchor.center,
        );

  late Sprite obstacleImage;

  @override
  Future<void> onLoad() async {
    obstacleImage = await Sprite.load('obstacle.png');
    sprite = obstacleImage;

    final defaultPaint = Paint()
      ..color = _defaultColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    hitBox = RectangleHitbox(size: size)
      ..paint = defaultPaint
      ..renderShape = true;
    add(hitBox);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    hitBox.paint.color = _collisionStartColor;
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (!isColliding) {
      hitBox.paint.color = _defaultColor;
    }
  }
}

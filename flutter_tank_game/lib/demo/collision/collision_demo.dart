import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/layout.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart' hide Image, Draggable;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.setLandscape();
  runApp(GameWidget(game: CollisionDetectionGame()));
}

class CollisionDetectionGame extends FlameGame with HasCollisionDetection {
  @override
  Future<void> onLoad() async {
    add(
      TextComponent(
        text: 'Hello, Flame',
        position: Vector2(16, 32),
      ),
    );

    add(
      AlignComponent(
        child: FpsTextComponent(),
        alignment: const Anchor(1.0, 0.1),
      ),
    );

    final emberPlayer = EmberPlayer(
      position: Vector2(10, (size.y / 2) - 20),
      onTap: (emberPlayer) {
        emberPlayer.add(
          MoveEffect.to(
            Vector2(size.x - 40, (size.y / 2) - 20),
            EffectController(
              duration: 5,
              reverseDuration: 5,
              repeatCount: 1,
              curve: Curves.easeOut,
            ),
          ),
        );
      },
    );
    add(emberPlayer);
    add(RectangleCollidable(canvasSize / 2));
  }
}

class RectangleCollidable extends PositionComponent with CollisionCallbacks {
  final _collisionStartColor = Colors.amber;
  final _defaultColor = Colors.white;
  late ShapeHitbox hitbox;

  RectangleCollidable(Vector2 position)
      : super(
          position: position,
          size: Vector2.all(50),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    final defaultPaint = Paint()
      ..color = _defaultColor
      ..style = PaintingStyle.stroke;
    hitbox = RectangleHitbox()
      ..paint = defaultPaint
      ..renderShape = true;
    add(hitbox);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    hitbox.paint.color = _collisionStartColor;
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (!isColliding) {
      hitbox.paint.color = _defaultColor;
    }
  }
}

class EmberPlayer extends PositionComponent with CollisionCallbacks, TapCallbacks {
  final Function? onTap;
  EmberPlayer({
    required Vector2 position,
    this.onTap,
  }) {
    super.position = position;
    super.size = Vector2.all(40);
  }

  late Sprite sprite;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('tank/t_body_sand.webp');

    final defaultPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke;
    RectangleHitbox hitbox = RectangleHitbox(size: size)
      ..paint = defaultPaint
      ..renderShape = true;
    add(hitbox);
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    sprite.renderRect(canvas, Rect.fromCenter(center: const Offset(20, 20), width: size.x, height: size.y));
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    // if (_isCollision(other)) {
    //   position = Vector2(other.x, position.y);
    // }
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (!isColliding) {}
  }

  bool _isCollision(PositionComponent other) {
    Rect width = (position & size).intersect(other.position & other.size);
    if (width.width > 0 && width.height > 0) {
      return true;
    }
    return false;
  }

  @override
  void onTapUp(TapUpEvent event) {
    onTap?.call(this);

    ///离子动画
    Random rnd = Random();
    Vector2 randomVector2() => (Vector2.random(rnd) - Vector2.random(rnd)) * 200;
    add(ParticleSystemComponent(
      position: Vector2(100, 100),
      size: Vector2(100, 100),
      particle: Particle.generate(
        count: 10,
        generator: (i) => AcceleratedParticle(
          lifespan: 100,
          acceleration: randomVector2(),
          child: CircleParticle(
            paint: Paint()..color = Colors.red,
          ),
        ),
      ),
    ));
    super.onTapUp(event);
  }
}

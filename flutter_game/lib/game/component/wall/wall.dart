import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../../global/config.dart';

///障碍物
class Wall extends SpriteAnimationComponent with CollisionCallbacks {
  final SpriteAnimation spriteAnimation;
  Wall({
    required this.spriteAnimation,
    required Vector2 size,
    required Vector2 position,
  }) : super(
          size: size,
          anchor: Anchor.center,
          playing: false,
          animation: spriteAnimation,
          position: position,
        );

  @override
  Future<void> onLoad() async {
    addHitBox();
  }

  void addHitBox() {
    add(RectangleHitbox()..debugMode = Config.showOutline);
  }

  ///碰撞检测
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
  }
}

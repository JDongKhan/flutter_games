import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter_bird_game/utils/sprite_sheet_ext.dart';

class Player extends SpriteAnimationComponent with HasGameRef, CollisionCallbacks {
  Player() : super(size: Vector2(320, 160), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    const String src = 'parallax/airplane.png';
    await gameRef.images.load(src);
    var image = gameRef.images.fromCache(src);
    SpriteSheet bossSheet = SpriteSheet.fromColumnsAndRows(
      image: image,
      columns: 4,
      rows: 1,
    );

    List<Sprite> sprites = bossSheet.getSprites();
    animation = SpriteAnimation.spriteList(
      sprites,
      stepTime: 1 / 10,
      loop: true,
    );
    position = gameRef.size / 2;
    add(RectangleHitbox()..debugMode = true);
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    print('碰撞了飞机');
    super.onCollision(intersectionPoints, other);
  }
}

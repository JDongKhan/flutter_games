import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';

class FixedResolutionExample extends FlameGame with ScrollDetector, ScaleDetector, PanDetector {
  static const description = '''
    This example shows how to create a viewport with a fixed resolution.
    It is useful when you want the visible part of the game to be the same on
    all devices no matter the actual screen size of the device.
    Resize the window or change device orientation to see the difference.
  ''';

  FixedResolutionExample({
    required Vector2 viewportResolution,
  }) : super(
          camera: CameraComponent.withFixedResolution(
            width: viewportResolution.x,
            height: viewportResolution.y,
          ),
        );

  @override
  Future<void> onLoad() async {
    final flameSprite = await loadSprite('layers/player.png');
    SpriteComponent spriteComponent = SpriteComponent(sprite: flameSprite, size: Vector2(149, 211))..anchor = Anchor.center;
    world.add(Background());
    world.add(spriteComponent);
    ButtonComponent buttonComponent = ButtonComponent(button: TextComponent(text: '2222'));
    world.add(buttonComponent);
    camera.follow(spriteComponent);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    camera.viewfinder.position = Vector2(camera.viewfinder.position.x - info.delta.global.x, camera.viewfinder.position.y);
    super.onPanUpdate(info);
  }
}

class Background extends PositionComponent with HasGameRef {
  @override
  int priority = -1;

  late Paint white;
  late final Rect hugeRect;

  Background() : super(size: Vector2.all(100000), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    white = BasicPalette.white.paint();
    hugeRect = size.toRect();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(hugeRect, white);
  }
}

import 'dart:async';
import 'package:flame/components.dart';
import '../base_sprite_component.dart';

///游戏背景
class BattleBackground extends BaseSpriteComponent {
  BattleBackground();

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load('new_map.webp');
  }

  @override
  void onGameResize(Vector2 size) {
    super.size = size;
    super.onGameResize(size);
  }
}

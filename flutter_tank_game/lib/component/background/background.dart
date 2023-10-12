import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:vector_math/vector_math_64.dart';

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

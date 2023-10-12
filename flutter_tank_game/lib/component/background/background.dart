import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:vector_math/vector_math_64.dart';

import '../base_component.dart';

///游戏背景
class BattleBackground extends WindowComponent {
  BattleBackground();
  Sprite? bgSprite;
  Rect? bgRect;

  @override
  void onLoad() async {
    bgSprite = await Sprite.load('new_map.webp');
    super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    bgSprite?.renderRect(canvas, bgRect ?? Rect.zero);
  }

  @override
  void onGameResize(Vector2 size) {
    bgRect = Rect.fromLTWH(0, 0, size.storage.first, size.storage.last);
    super.onGameResize(size);
  }
}

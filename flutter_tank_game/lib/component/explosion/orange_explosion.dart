import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flame/sprite.dart';

import '../base_component.dart';

class OrangeExplosion extends WindowComponent {
  OrangeExplosion(this.position) : exRect = Rect.fromCenter(center: position, width: 30, height: 30) {
    loadSprite();
  }

  ///爆炸位置
  final Offset position;

  ///爆炸纹理
  final List<Sprite> sprites = [];

  ///爆炸纹理尺寸
  final Rect exRect;

  int playIndex = 0;

  bool playDone = false;

  ///爆炸开始经过的时间
  /// * 用于调整[sprites]的fps
  double passedTime = 0;

  void loadSprite() async {
    sprites.add(await Sprite.load('explosion/explosion1.webp'));
    sprites.add(await Sprite.load('explosion/explosion2.webp'));
    sprites.add(await Sprite.load('explosion/explosion3.webp'));
    sprites.add(await Sprite.load('explosion/explosion4.webp'));
    sprites.add(await Sprite.load('explosion/explosion5.webp'));
  }

  @override
  void render(Canvas canvas) {
    if (playDone) return;
    if (sprites.length == 5 && playIndex < 5) {
      sprites[playIndex].renderRect(canvas, exRect);
    }
  }

  @override
  void update(double t) {
    if (playDone) return;
    if (playIndex < 5) {
      //1秒 5张图片
      passedTime += t;
      playIndex = passedTime ~/ 0.2;
    } else {
      playDone = true;
    }
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);
  }
}

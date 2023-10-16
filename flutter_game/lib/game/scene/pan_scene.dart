import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter_game/game/scene/player_scene.dart';

import '../component/event/touch_indicator.dart';

mixin PanScene on FlameGame, PanDetector, PlayerScene {
  @override
  void onPanEnd(DragEndInfo info) {
    if (_lastPointerPos != null) {
      player?.moveTo(_lastPointerPos!);
      _lastPointerPos = null;
    }
  }

  @override
  void onPanStart(DragStartInfo info) {
    _lastPointerPos = info.eventPosition.global;
  }

  @override
  void onPanDown(DragDownInfo info) {
    Vector2 target = info.eventPosition.global;
    add(TouchIndicator(position: target));
    player?.moveTo(target);
  }

  double ds = 0;
  Vector2? _lastPointerPos;

  @override
  void onPanUpdate(DragUpdateInfo info) {
    _lastPointerPos = info.eventPosition.global;
    ds += info.delta.global.length;
    if (ds > 10) {
      add(TouchIndicator(position: info.eventPosition.global));
      ds = 0;
    }
  }
}

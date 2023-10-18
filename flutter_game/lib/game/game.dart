import 'dart:async';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter_game/game/component/base_flame_game.dart';
import '../game_page.dart';
import 'scene/map_scene.dart';
import 'scene/monster_scene.dart';
import 'scene/player_scene.dart';

///游戏主入口
/// KeyboardEvents 键盘事件
class JDGame extends BaseFlameGame with HasCollisionDetection, PanDetector, TapDetector, KeyboardEvents, PlayerScene, KeyboardScene, JoystickScene, MonsterScene, MapScene {
  @override
  void resumeEngine() {
    super.resumeEngine();
    overlays.remove(PauseMenu.menuId);
  }

  @override
  void pauseEngine() {
    super.pauseEngine();
    overlays.add(PauseMenu.menuId);
  }

  @override
  void gameOver() {
    overlays.add(GameOverLayer.menuId);
  }

  @override
  FutureOr restart() {
    overlays.remove(GameOverLayer.menuId);
    return super.restart();
  }
}

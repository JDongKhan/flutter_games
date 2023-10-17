import 'package:flame/events.dart';
import 'package:flame/game.dart';

import '../game_page.dart';
import 'scene/map_scene.dart';
import 'scene/monster_scene.dart';
import 'scene/player_scene.dart';

///游戏主入口
/// KeyboardEvents 键盘事件
class JDGame extends FlameGame with HasCollisionDetection, PanDetector, TapDetector, KeyboardEvents, MapScene, PlayerScene, KeyboardScene, JoystickScene, MonsterScene {
  void resumeGameState() {
    resumeEngine();
    overlays.remove(PauseMenu.menuId);
  }

  void pausedGameState() {
    pauseEngine();
    overlays.add(PauseMenu.menuId);
  }
}

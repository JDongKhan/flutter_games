import 'package:flame/events.dart';
import 'package:flame/game.dart';

import 'scene/monster_scene.dart';
import 'scene/player_scene.dart';

///游戏主入口
/// KeyboardEvents 键盘事件
class JDGame extends FlameGame with HasCollisionDetection, PanDetector, TapDetector, KeyboardEvents, PlayerScene, KeyboardScene, JoystickScene, MonsterScene {}

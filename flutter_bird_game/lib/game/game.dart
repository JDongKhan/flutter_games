import 'package:flame/events.dart';
import 'package:flame/game.dart';

import 'scene/bird_scene.dart';
import 'scene/map_scene.dart';
import 'scene/player_scene.dart';

///游戏主入口
/// KeyboardEvents 键盘事件
class BirdGame extends FlameGame with HasCollisionDetection, PanDetector, TapDetector, KeyboardEvents, PlayerScene, JoystickScene, BirdScene, MapScene {}

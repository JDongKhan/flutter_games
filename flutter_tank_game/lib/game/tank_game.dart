import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter_tank_game/game/theater/game_judge.dart';
import 'theater/computer_tank_theater.dart';
import 'theater/decoration_theater.dart';
import 'theater/map_theater.dart';
import 'theater/player_tank_theater.dart';

///游戏入口
/// * 继承于[FlameGame]
/// * 所混入的类 : [ComputerTankTheater]、[PlayerTankTheater]、[DecorationTheater]、[GameJudge]、[MapTheater]
/// * 用于拓展[TankGame]的场景内容和[Sprite]交互行为，具体见各自的注释。
class TankGame extends FlameGame with ComputerTankTheater, PlayerTankTheater, DecorationTheater, GameJudge, MapTheater {}

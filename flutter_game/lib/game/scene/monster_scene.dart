import 'package:flame/game.dart';
import 'manager/monster_area.dart';

///怪兽
mixin MonsterScene on FlameGame {
  late MonsterArea monsterArea;

  @override
  Future<void> onLoad() async {
    monsterArea = MonsterArea();
    add(monsterArea);
    super.onLoad();
  }
}

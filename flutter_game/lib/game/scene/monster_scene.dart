import 'dart:async';

import 'package:flame/game.dart';
import 'manager/monster_area.dart';

///怪兽
mixin MonsterScene on FlameGame {
  late MonsterArea monsterArea;

  @override
  FutureOr<void> onLoad() async {
    monsterArea = MonsterArea();
    world.add(monsterArea);
    return super.onLoad();
  }
}

import 'dart:async';

import 'package:flame/game.dart';
import 'manager/monster_area.dart';

///怪兽
mixin MonsterScene on FlameGame {
  MonsterArea? _monsterArea;

  @override
  FutureOr<void> onLoad() async {
    if (_monsterArea != null) {
      _monsterArea?.removeFromParent();
    }
    _monsterArea = MonsterArea();
    world.add(_monsterArea!);
    return super.onLoad();
  }
}

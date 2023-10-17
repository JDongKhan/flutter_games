import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';

import '../components/anim_bullet.dart';
import '../components/background.dart';
import '../components/player.dart';

mixin MapScene on FlameGame {
  @override
  FutureOr<void> onLoad() async {
    Background background = Background();
    add(background);
    return super.onLoad();
  }
}

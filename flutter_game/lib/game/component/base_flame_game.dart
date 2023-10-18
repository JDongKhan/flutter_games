import 'dart:async';

import 'package:flame/game.dart';

abstract class BaseFlameGame extends FlameGame {
  ///重新开始
  FutureOr<void> restart() async {
    return await onLoad();
  }

  ///游戏结束
  void gameOver();
}

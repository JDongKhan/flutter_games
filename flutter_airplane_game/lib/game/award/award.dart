import '../auto_sprite.dart';

abstract class Award extends AutoSprite {
  Award({
    required super.themeController,
  });

  ///奖励等级
  int getLevel();

  ///奖励时间
  int getTime();
}

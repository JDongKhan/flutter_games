import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import '../../component/explosion/orange_explosion.dart';

///负责装饰性场景及衍生的[Sprite]
/// *爆炸。
mixin DecorationTheater on FlameGame {
  ///在[pos]位置添加一个爆炸效果
  void addExplosions(Offset pos) {
    add(OrangeExplosion()..position = pos.toVector2());
  }
}

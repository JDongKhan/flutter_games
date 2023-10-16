import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';

import '../component/life/line.dart';
import 'manager/monster_manager.dart';

///怪兽
mixin MonsterScene on FlameGame {
  late MonsterManager monsterManager;

  @override
  Future<void> onLoad() async {
    const String src = 'adventurer/animatronic.png';
    await images.load(src);
    var image = images.fromCache(src);
    SpriteSheet bossSheet = SpriteSheet.fromColumnsAndRows(
      image: image,
      columns: 13,
      rows: 6,
    );

    const String src2 = 'adventurer/Characters-part-2.png';
    await images.load(src2);
    var image2 = images.fromCache(src2);

    SpriteSheet stoneSheet = SpriteSheet.fromColumnsAndRows(
      image: image2,
      columns: 9,
      rows: 6,
    );

    List<Sprite> sprites = [];
    for (int i = 0; i <= 28; i++) {
      sprites.add(await loadSprite('adventurer/skill02/s$i.png'));
    }
    SpriteAnimation bossBullet = SpriteAnimation.spriteList(sprites, stepTime: 0.1);

    List<Sprite> sprites2 = [];
    for (int i = 1; i <= 4; i++) {
      sprites2.add(await loadSprite('adventurer/skill01/ef0$i.png'));
    }
    SpriteAnimation stoneBullet = SpriteAnimation.spriteList(sprites2, stepTime: 0.1);

    monsterManager = MonsterManager(bossBullet: bossBullet, stoneBullet: stoneBullet, bossSpriteSheet: bossSheet, stoneSpriteSheet: stoneSheet);
    add(monsterManager);
    super.onLoad();
  }
}

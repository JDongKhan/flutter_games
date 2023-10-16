import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flame_ext/flame_ext.dart';

import '../../component/monster/monster.dart';
import '../../component/player/player.dart';

class MonsterArea extends PositionComponent with HasGameRef {
  MonsterArea() : super(anchor: Anchor.center);

  static List<Monster> monsters = [];

  final Random _random = Random();

  static Future<List<Monster>> initMonsters(FlameGame game) async {
    monsters.add(await buildSoldier(game));
    monsters.add(await buildBoss(game));
    return monsters;
  }

  static Future<Monster> buildSoldier(FlameGame game) async {
    //普通怪物
    const String src2 = 'adventurer/Characters-part-2.png';
    var image = game.images.fromCache(src2);
    SpriteSheet stoneSheet = SpriteSheet.fromColumnsAndRows(image: image, columns: 9, rows: 6);
    List<Sprite> sprites = stoneSheet.getRowSprites(row: 0, start: 5, count: 4);
    SpriteAnimation animation = SpriteAnimation.spriteList(sprites, stepTime: 1 / 10, loop: true);
    Vector2 monsterSize = Vector2(32, 48);
    final PlayerAttr heroAttr = PlayerAttr(life: 200, speed: 0, attackSpeed: 200, attackRange: 400, attack: 20, crit: 0, critDamage: 1);

    List<Sprite> sprites2 = [];
    for (int i = 1; i <= 4; i++) {
      sprites2.add(await Sprite.load('adventurer/skill01/ef0$i.png'));
    }
    SpriteAnimation stoneBullet = SpriteAnimation.spriteList(sprites2, stepTime: 0.1);

    Monster monster =
        Monster(bulletSize: Vector2(470 / 15, 258 / 15), attr: heroAttr, bulletSprite: stoneBullet, animation: animation, size: monsterSize, position: Vector2.zero());
    return monster;
  }

  static Future<Monster> buildBoss(FlameGame game) async {
    const String src = 'adventurer/animatronic.png';
    var image = game.images.fromCache(src);
    SpriteSheet bossSheet = SpriteSheet.fromColumnsAndRows(image: image, columns: 13, rows: 6);

    List<Sprite> sprites = [];
    for (int i = 0; i <= 28; i++) {
      sprites.add(await Sprite.load('adventurer/skill02/s$i.png'));
    }
    SpriteAnimation bossBullet = SpriteAnimation.spriteList(sprites, stepTime: 0.1);

    SpriteAnimation animation = SpriteAnimation.spriteList(bossSheet.getSprites(), stepTime: 1 / 24, loop: true);
    Vector2 monsterSize = Vector2(64, 64);

    final PlayerAttr heroAttr = PlayerAttr(life: 4000, speed: 100, attackSpeed: 200, attackRange: 600, attack: 100, crit: 0.5, critDamage: 1.5);
    Monster monster = Monster(bulletSize: Vector2(720 / 4, 658 / 4), attr: heroAttr, bulletSprite: bossBullet, animation: animation, size: monsterSize, position: Vector2.zero());
    return monster;
  }

  Monster generateNewMonster() {
    double x = game.size.x;
    double y = _random.nextInt(game.size.y.toInt()).toDouble();
    double speed = _random.nextRange(100, 200).toDouble();
    Monster initMonster = monsters[0];
    Monster monster = initMonster.copyWith(attr: initMonster.attr.copyWith(speed: speed));
    monster.position = Vector2(x, y);
    _newSoldier++;
    return monster;
  }

  Monster generateNewBoss() {
    double x = game.size.x;
    double y = _random.nextInt(game.size.y.toInt()).toDouble();
    double speed = _random.nextRange(100, 200).toDouble();
    Monster initMonster = monsters[0];
    Monster monster = initMonster.copyWith(attr: initMonster.attr.copyWith(speed: speed));
    monster.position = Vector2(x, y);
    return monster;
  }

  int _newSoldier = 0;

  @override
  Future<void> onLoad() async {
    await MonsterArea.initMonsters(game);

    ///初始化
    for (int i = 0; i < 5; i++) {
      add(generateNewMonster());
    }
  }

  @override
  void update(double dt) {
    if (children.length < 4) {
      add(generateNewMonster());
    }
    if (_newSoldier == 40) {
      _newSoldier = 0;
      add(generateNewBoss());
    }
    super.update(dt);
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_airplane_game/theme/theme_controller.dart';
import 'award/award.dart';
import 'enemy/big_enemy_plane.dart';
import 'explosion/explosion.dart';
import 'enemy/small_enemy_plane.dart';

import 'bullet/bullet.dart';
import 'aircraft/combat_aircraft.dart';
import 'enemy/enemy_plane.dart';
import 'enemy/middle_enemy_plane.dart';
import 'sprite.dart';

class Game {
  final ThemeController themeController;
  Game(this.themeController);

  ///角色飞机
  late final CombatAircraft _combatAircraft = CombatAircraft(themeController: themeController);

  ///子弹
  final _bullets = <Bullet>[];

  ///敌人
  final _enemies = <EnemyPlane>[];

  ///爆炸效果
  final _explosions = <Explosion>[];

  ///奖励
  final _awards = <Award>[];

  ///尺寸
  var size = const Size(0, 0);

  ///随机
  var random = Random();

  /// 游戏是否暂停
  var pause = false;

  /// 游戏是否结束
  var _gameOver = false;

  ///帧
  var flame = 0;

  ///得分
  int score = 0;

  ///开始游戏
  void startGame() {
    score = 0;
    pause = false;
    _gameOver = false;
    _combatAircraft.destroyed = false;
    _combatAircraft.single = true;
    _combatAircraft.moveTo((size.width - _combatAircraft.getSize().width) / 2, size.height - _combatAircraft.getSize().height);
    _enemies.clear();
    _explosions.clear();
    _bullets.clear();
    _enemies.add(MiddleEnemyPlane(themeController: themeController));
  }

  ///停止游戏
  void stopGame() {
    _enemies.clear();
    _explosions.clear();
    _bullets.clear();
  }

  ///更新
  void update() {
    flame++;
    if (!pause) {
      _updateWorld();
    }
  }

  ///飞机移动
  void move(double dx, double dy) {
    if (!pause) {
      var x = _combatAircraft.centerX + dx;
      var y = _combatAircraft.centerY + dy;
      if (x < 0) {
        x = 0.0;
      } else if (x > size.width) {
        x = size.width;
      }
      if (y < 0) {
        y = 0.0;
      } else if (y > size.height) {
        y = size.height;
      }
      _combatAircraft.centerTo(x, y);
    }
  }

  ///更新页面
  void _updateWorld() {
    //更新飞机
    _combatAircraft.update();
    //更新敌人
    for (var enemyPlane in _enemies) {
      enemyPlane.update();
    }
    //更新子弹
    var list = _combatAircraft.getBullets();
    if (list.isNotEmpty) {
      _bullets.addAll(list);
    }
    //碰撞检测
    for (int i = 0; i < _enemies.length; i++) {
      EnemyPlane enemyPlane = _enemies[i];
      if (enemyPlane.destroyed || isOutScreen(enemyPlane)) {
        _enemies.removeAt(i);
        i--;
        continue;
      }
      for (int j = 0; j < _bullets.length; j++) {
        Bullet bullet = _bullets[j];
        if (enemyPlane.isCollide(bullet)) {
          enemyPlane.attacked(1, this);
          _bullets.removeAt(j);
          j--;
        }
      }
      if (_combatAircraft.isCollide(enemyPlane)) {
        //飞机爆炸
        _combatAircraft.hit(this);
        _gameOver = true;
      }
    }
    //奖励
    for (int i = 0; i < _awards.length; i++) {
      Award award = _awards[i];
      if (_combatAircraft.isCollide(award)) {
        _combatAircraft.addAward();
        _awards.removeAt(i);
        i--;
      } else if (isOutScreen(award)) {
        _awards.removeAt(i);
        i--;
      } else {
        award.update();
      }
    }
    //爆炸效果
    for (int i = 0; i < _explosions.length; i++) {
      _explosions[i].update();
      if (_explosions[i].destroyed) {
        _explosions.removeAt(i);
        i--;
      }
    }
    if ((flame % 600) == 0) {
      createAward();
    }
    //创建敌人
    createEnemy();
    for (int i = 0; i < _bullets.length; i++) {
      Bullet bullet = _bullets[i];
      bullet.update();
      if (isOutScreen(bullet)) {
        _bullets.removeAt(i);
        i--;
      }
    }
  }

  //创建敌人
  createEnemy() {
    if (_enemies.length < 3) {
      var category = random.nextInt(3);
      EnemyPlane? enemy;
      if (category == 0) {
        enemy = SmallEnemyPlane(themeController: themeController);
      } else if (category == 1) {
        enemy = MiddleEnemyPlane(themeController: themeController);
      } else if (category == 2) {
        enemy = BigEnemyPlane(themeController: themeController);
      }
      if (enemy != null) {
        enemy.moveTo(random.nextDouble() * size.width - enemy.getSize().width / 2, -enemy.getSize().height);
        _enemies.add(enemy);
      }
    }
  }

  ///创建奖励
  void createAward() {
    Award award = Award(themeController: themeController);
    award.moveTo(random.nextDouble() * size.width - award.getSize().width / 2, -award.getSize().height);
    _awards.add(award);
  }

  bool isOutScreen(Sprite sprite) {
    Rect rect1 = Rect.fromLTWH(0, 0, size.width, size.height);
    Rect rect2 = sprite.getRect();
    Rect rect = rect1.intersect(rect2);
    if (rect.width < 0 || rect.height < 0) {
      return true;
    }
    return false;
  }

  void addExplosion(Explosion explosion) {
    _explosions.add(explosion);
  }

  Widget getRenderWidget() {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        children: getWidgets(),
      ),
    );
  }

  addScore(int score) {
    this.score += score;
  }

  List<Widget> getWidgets() {
    var list = <Widget>[];
    //背景
    list.add(Image.asset(themeController.backgroundImage, fit: BoxFit.cover, width: size.width, height: size.height));
    //敌机
    for (var enemyPlane in _enemies) {
      list.add(enemyPlane.getRenderWidget());
    }
    //爆炸
    for (var explosion in _explosions) {
      list.add(explosion.getRenderWidget());
    }
    //奖励
    for (var award in _awards) {
      list.add(award.getRenderWidget());
    }
    //子弹
    for (var bullet in _bullets) {
      list.add(bullet.getRenderWidget());
    }
    //主角飞机
    if (!_combatAircraft.destroyed) {
      list.add(_combatAircraft.getRenderWidget());
    }
    //暂停和得分信息按钮
    list.add(_buildMenuAndInfoWidget());
    //弹框
    if (pause || _gameOver) {
      list.add(_buildDialogWidget());
    }
    return list;
  }

  ///菜单和得分信息
  Positioned _buildMenuAndInfoWidget() {
    return Positioned(
      top: 40,
      left: 20,
      child: Row(
        children: [
          GestureDetector(
            child: Image.asset(
              pause ? themeController.pauseBtnImage : themeController.runBtnImage,
              width: 30,
              height: 30,
            ),
            onPanDown: (detail) {
              pause = true;
            },
          ),
          const SizedBox(
            width: 12,
          ),
          Text(
            '$score',
            style: const TextStyle(fontSize: 22, color: Colors.black54, decoration: TextDecoration.none),
          ),
        ],
      ),
    );
  }

  ///得分对话框
  Widget _buildDialogWidget() {
    var top = (size.height - 260) / 2;
    return Positioned(
      top: top,
      left: 30,
      right: 30,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFD7DDDE),
          border: Border.all(color: Colors.black54, width: 2),
        ),
        child: Column(
          children: [
            Container(
              height: 70,
              alignment: Alignment.center,
              child: const Text(
                '飞机大战分数',
                style: TextStyle(fontSize: 24, color: Colors.black54, decoration: TextDecoration.none),
              ),
            ),
            const Divider(color: Colors.black54, height: 2, thickness: 2),
            Container(
              height: 120,
              alignment: Alignment.center,
              child: Text(
                '$score',
                style: const TextStyle(fontSize: 30, color: Colors.black54, decoration: TextDecoration.none),
              ),
            ),
            const Divider(color: Colors.black54, height: 2, thickness: 2),
            Container(
              height: 70,
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  if (pause) {
                    pause = false;
                  } else if (_gameOver) {
                    startGame();
                  }
                },
                child: Text(
                  _gameOver ? '重新开始' : '继续',
                  style: const TextStyle(fontSize: 24, color: Colors.black54, decoration: TextDecoration.none),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

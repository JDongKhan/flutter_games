import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_airplane_game/theme/theme_controller.dart';
import 'aircraft/default_combat_aircraft.dart';
import 'auto_sprite.dart';
import 'award/award.dart';
import 'award/default_award.dart';
import 'enemy/big_enemy_plane.dart';
import 'explosion/explosion.dart';
import 'enemy/small_enemy_plane.dart';

import 'bullet/bullet.dart';
import 'aircraft/combat_aircraft.dart';
import 'enemy/enemy_plane.dart';
import 'enemy/middle_enemy_plane.dart';

class Game {
  final ThemeController themeController;
  Game(this.themeController);

  ///角色飞机
  late final CombatAircraft _combatAircraft = DefaultCombatAircraft(themeController: themeController);

  ///子弹
  final _bullets = <Bullet>[];

  ///敌人或奖品
  final _enemiesOrAwards = <AutoSprite>[];

  ///爆炸效果
  final _explosions = <Explosion>[];

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

  ///游戏等级
  int level = 2;

  ///开始游戏
  void startGame() {
    score = 0;
    pause = false;
    _gameOver = false;
    _combatAircraft.reset();
    _combatAircraft.moveTo((size.width - _combatAircraft.getSize().width) / 2, size.height - _combatAircraft.getSize().height);
    _enemiesOrAwards.clear();
    _explosions.clear();
    _bullets.clear();
    _enemiesOrAwards.add(MiddleEnemyPlane(themeController: themeController));
  }

  ///停止游戏
  void stopGame() {
    _enemiesOrAwards.clear();
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
    level = score.toString().length;
    //更新飞机
    _combatAircraft.update(size);
    //更新敌人
    for (var enemyPlane in _enemiesOrAwards) {
      enemyPlane.update(size);
    }
    //更新子弹
    var list = _combatAircraft.getBullets();
    if (list.isNotEmpty) {
      _bullets.addAll(list);
    }
    //碰撞检测
    for (int i = 0; i < _enemiesOrAwards.length; i++) {
      AutoSprite enemiesOrAward = _enemiesOrAwards[i];
      //已经销毁了则移除
      if (enemiesOrAward.destroyed || enemiesOrAward.isOutScreen(size)) {
        _enemiesOrAwards.removeAt(i);
        i--;
        continue;
      }

      ///检测子弹与敌人的
      for (int j = 0; j < _bullets.length; j++) {
        Bullet bullet = _bullets[j];
        if (enemiesOrAward is EnemyPlane && enemiesOrAward.isCollide(bullet)) {
          enemiesOrAward.attacked(1, this);
          _bullets.removeAt(j);
          j--;
        }
      }

      ///检测主角飞机和敌人的碰撞
      if (_combatAircraft.isCollide(enemiesOrAward)) {
        if (enemiesOrAward is EnemyPlane) {
          //飞机爆炸
          _combatAircraft.hit(this);
          _gameOver = true;
        } else if (enemiesOrAward is Award) {
          //奖励
          _combatAircraft.addAward();
          _enemiesOrAwards.removeAt(i);
        }
      }
    }
    //爆炸效果
    for (int i = 0; i < _explosions.length; i++) {
      _explosions[i].update(size);
      if (_explosions[i].destroyed) {
        _explosions.removeAt(i);
        i--;
      }
    }
    //创建敌人和奖品
    _createEnemyAndAward();

    ///更新子弹
    for (int i = 0; i < _bullets.length; i++) {
      Bullet bullet = _bullets[i];
      bullet.update(size);
      if (bullet.isOutScreen(size)) {
        _bullets.removeAt(i);
        i--;
      }
    }
  }

  //创建敌人
  _createEnemyAndAward() {
    if (_enemiesOrAwards.length < level) {
      var category = random.nextInt(level);
      AutoSprite? sprite;
      if (category % 4 == 0) {
        sprite = SmallEnemyPlane(themeController: themeController);
      } else if (category % 4 == 1) {
        sprite = MiddleEnemyPlane(themeController: themeController);
      } else if (category % 4 == 2) {
        sprite = BigEnemyPlane(themeController: themeController);
      } else if (category % 4 == 3) {
        sprite = DefaultAward(themeController: themeController);
      }
      if (sprite != null) {
        sprite.moveTo(random.nextDouble() * size.width - sprite.getSize().width / 2, -sprite.getSize().height);
        _enemiesOrAwards.add(sprite);
      }
    }
  }

  void addExplosion(Explosion explosion) {
    _explosions.add(explosion);
  }

  Widget getRenderWidget() {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        children: _buildWidgets(),
      ),
    );
  }

  addScore(int score) {
    this.score += score;
  }

  List<Widget> _buildWidgets() {
    var list = <Widget>[];
    //背景
    list.add(Image.asset(themeController.backgroundImage, fit: BoxFit.cover, width: size.width, height: size.height));
    //敌机
    for (var enemyPlane in _enemiesOrAwards) {
      list.add(enemyPlane.getRenderWidget());
    }
    //爆炸
    for (var explosion in _explosions) {
      list.add(explosion.getRenderWidget());
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
              if (_gameOver) {
                return;
              }
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
                '得分',
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

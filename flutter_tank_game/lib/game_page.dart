import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter_tank_game/data/data_manager.dart';
import 'controller/control_panel_widget.dart';
import 'game/tank_game.dart';
import 'theme/theme_controller.dart';
import 'theme/theme_widget.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TankGame tankGame = TankGame();
    tankGame.pauseWhenBackgrounded = true;
    return Stack(
      children: [
        FutureBuilder<List<ui.Image>>(
          future: loadAssets(),
          initialData: [],
          builder: (ctx, snapShot) {
            if (snapShot.data?.isEmpty ?? true) {
              return const Center(
                child: LinearProgressIndicator(
                  color: Colors.blue,
                ),
              );
            }
            return GameWidget(game: tankGame);
          },
        ),
        ControlPanelWidget(
          tankController: tankGame,
        ),
        Menu(game: tankGame),
      ],
    );
  }

  Future<List<ui.Image>> loadAssets() {
    return Flame.images.loadAll([
      'new_map.webp',
      'tank/t_body_blue.webp',
      'tank/t_turret_blue.webp',
      'tank/t_body_green.webp',
      'tank/t_turret_green.webp',
      'tank/t_body_sand.webp',
      'tank/t_turret_sand.webp',
      'tank/bullet_blue.webp',
      'tank/bullet_green.webp',
      'tank/bullet_sand.webp',
      'explosion/explosion1.webp',
      'explosion/explosion2.webp',
      'explosion/explosion3.webp',
      'explosion/explosion4.webp',
      'explosion/explosion5.webp',
    ]);
  }
}

///菜单和得分信息
class Menu extends StatefulWidget {
  final TankGame game;
  const Menu({
    super.key,
    required this.game,
  });

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  void initState() {
    DataManager.instance.addListener(_updateInfo);
    super.initState();
  }

  void _updateInfo() {
    setState(() {});
  }

  @override
  void dispose() {
    DataManager.instance.removeListener(_updateInfo);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeController? themeController = ThemeNotifierProviderWidget.of(context);
    return Positioned(
      top: 10,
      left: 20,
      child: Row(
        children: [
          GestureDetector(
            child: Image.asset(
              DataManager.instance.pause ? themeController!.pauseBtnImage : themeController!.runBtnImage,
              width: 30,
              height: 30,
            ),
            onPanDown: (detail) {
              if (DataManager.instance.gameOver) {
                return;
              }
              DataManager.instance.pause = !DataManager.instance.pause;
              widget.game.paused = DataManager.instance.pause;
            },
          ),
          const SizedBox(
            width: 12,
          ),
          Text(
            '${DataManager.instance.score}',
            style: const TextStyle(fontSize: 22, color: Colors.black54, decoration: TextDecoration.none),
          ),
        ],
      ),
    );
  }
}

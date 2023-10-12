import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter_tank_game/data/data_manager.dart';
import 'component/tank/default_tank.dart';
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
    return FutureBuilder<List<ui.Image>>(
      future: loadAssets(),
      initialData: const [],
      builder: (ctx, snapShot) {
        if (snapShot.data?.isEmpty ?? true) {
          return _buildLoading();
        }
        return GameWidget(
          game: tankGame,
          initialActiveOverlays: const ['PauseMenu', 'Control'],
          loadingBuilder: (c) {
            return _buildLoading();
          },
          errorBuilder: (c, error) {
            return _buildError(error);
          },
          overlayBuilderMap: {
            'PauseMenu': (context, game) {
              return Menu(game: tankGame);
            },
            'Control': (c, game) {
              return ControlPanelWidget(
                tankController: tankGame,
              );
            }
          },
        );
      },
    );
  }

  Widget _buildLoading() {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '加载中...',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
              ),
              SizedBox(
                width: 80,
                child: LinearProgressIndicator(
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildError(Object error) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '额，出错了',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
              ),
              Text(
                error.toString(),
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
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
  int _score = 0;
  @override
  void initState() {
    DataManager.instance.addListener(_updateInfo);
    _listenerScore();
    super.initState();
  }

  void _listenerScore() {
    final ComponentsNotifier<PlayerTank> playerNotifier = widget.game.componentsNotifier<PlayerTank>();
    playerNotifier.addListener(() {
      PlayerTank? player = playerNotifier.single;
      _score = player?.score ?? 0;
      setState(() {});
    });
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
              widget.game.paused ? themeController!.pauseBtnImage : themeController!.runBtnImage,
              width: 30,
              height: 30,
            ),
            onPanDown: (detail) {
              if (DataManager.instance.gameOver) {
                return;
              }
              widget.game.paused = !widget.game.paused;
              setState(() {});
            },
          ),
          const SizedBox(
            width: 12,
          ),
          Text(
            '$_score',
            style: const TextStyle(fontSize: 22, color: Colors.black54, decoration: TextDecoration.none),
          ),
        ],
      ),
    );
  }
}

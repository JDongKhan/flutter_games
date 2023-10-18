import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter_game/game/component/base_flame_game.dart';
import 'package:flutter_game/game/game.dart';
import 'package:flutter_game/global/data_store.dart';
import 'theme/theme_controller.dart';
import 'theme/theme_widget.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final JDGame game = JDGame();
    game.pauseWhenBackgrounded = true;
    return FutureBuilder<List<ui.Image>>(
      future: _loadAssets(),
      initialData: const [],
      builder: (ctx, snapShot) {
        if (snapShot.data?.isEmpty ?? true) {
          return _buildLoading();
        }
        return GameWidget(
          game: game,
          initialActiveOverlays: const [Menu.menuId],
          loadingBuilder: (c) {
            return _buildLoading();
          },
          errorBuilder: (c, error) {
            return _buildError(error);
          },
          overlayBuilderMap: {
            Menu.menuId: (context, g) {
              return Menu(game: game);
            },
            PauseMenu.menuId: (context, g) {
              return GameOverLayer(game: game);
            },
            GameOverLayer.menuId: (context, g) {
              return GameOverLayer(
                game: game,
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

  Future<List<ui.Image>> _loadAssets() {
    return Flame.images.loadAllImages();
  }
}

///菜单和得分信息
class Menu extends StatefulWidget {
  static const String menuId = 'Menu';
  final JDGame game;
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
    DataStore.instance.addListener(_listenerScore);
    super.initState();
  }

  void _listenerScore() {
    int s = DataStore.instance.getScore(widget.game.player?.playerId);
    // final ComponentsNotifier<Player> playerNotifier = widget.game.componentsNotifier<Player>();
    // playerNotifier.addListener(() {
    //   Player? player = playerNotifier.single;
    //   _score = player?.score ?? 0;
    //   setState(() {});
    // });
    setState(() {
      _score = s;
    });
  }

  @override
  void dispose() {
    DataStore.instance.removeListener(_listenerScore);
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
              widget.game.paused = !widget.game.paused;
              setState(() {
                widget.game.pauseEngine();
              });
            },
          ),
          const SizedBox(
            width: 12,
          ),
          Text(
            '$_score',
            style: const TextStyle(fontSize: 22, color: Colors.white, decoration: TextDecoration.none),
          ),
        ],
      ),
    );
  }
}

///菜单和得分信息
class PauseMenu extends StatefulWidget {
  static const String menuId = 'PauseMenu';
  final JDGame game;
  const PauseMenu({
    super.key,
    required this.game,
  });

  @override
  State<PauseMenu> createState() => _PauseMenuState();
}

class _PauseMenuState extends State<PauseMenu> {
  @override
  void initState() {
    _listenerScore();
    super.initState();
  }

  void _listenerScore() {}

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          color: Colors.black54,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Wrap(
            spacing: 20,
            direction: Axis.vertical,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text('游戏暂停', style: TextStyle(color: Colors.white)),
              ElevatedButton(onPressed: _continue, child: const Text('继续游戏')),
              ElevatedButton(onPressed: _restart, child: const Text('重新开始')),
              ElevatedButton(onPressed: _exit, child: const Text('退出游戏'))
            ],
          ),
        ),
      ),
    );
  }

  void _restart() {}

  void _continue() {
    widget.game.resumeEngine();
  }

  void _exit() {
    exit(0);
  }
}

///游戏结束
class GameOverLayer extends StatefulWidget {
  static const String menuId = 'GameOver';
  final JDGame game;
  const GameOverLayer({
    super.key,
    required this.game,
  });

  @override
  State<GameOverLayer> createState() => _GameOverLayerState();
}

class _GameOverLayerState extends State<GameOverLayer> {
  @override
  void initState() {
    _listenerScore();
    super.initState();
  }

  void _listenerScore() {}

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          color: Colors.black54,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Wrap(
            spacing: 20,
            direction: Axis.vertical,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text('Game Over', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25)),
              Text('Score:${DataStore.instance.getScore(widget.game.player?.playerId)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              ElevatedButton(onPressed: _restart, child: const Text('重新开始')),
              ElevatedButton(onPressed: _exit, child: const Text('退出游戏'))
            ],
          ),
        ),
      ),
    );
  }

  void _restart() {
    widget.game.restart();
  }

  void _exit() {
    exit(0);
  }
}

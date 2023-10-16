import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter_game/game/game.dart';
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
          initialActiveOverlays: const ['PauseMenu'],
          loadingBuilder: (c) {
            return _buildLoading();
          },
          errorBuilder: (c, error) {
            return _buildError(error);
          },
          overlayBuilderMap: {
            'PauseMenu': (context, g) {
              return Menu(game: game);
            },
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
  final FlameGame game;
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
    _listenerScore();
    super.initState();
  }

  void _listenerScore() {
    // final ComponentsNotifier<Player> playerNotifier = widget.game.componentsNotifier<Player>();
    // playerNotifier.addListener(() {
    //   Player? player = playerNotifier.single;
    //   _score = player?.score ?? 0;
    //   setState(() {});
    // });
  }

  @override
  void dispose() {
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

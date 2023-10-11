import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'game/game.dart';
import 'game_over.dart';
import 'theme/theme_controller.dart';
import 'theme/theme_widget.dart';

enum Direction { left, right, up, down }

const int pieceSize = 10;

///游戏页面
class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with TickerProviderStateMixin, WidgetsBindingObserver {
  double top = 0;
  double left = 0;

  Timer? _timer;

  Game? _game;

  @override
  void initState() {
    startLoop();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    endLoop();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      startLoop();
    } else if (state == AppLifecycleState.paused) {
      endLoop();
      if (_game != null) {
        _game?.pause = true;
      }
    }
  }

  startLoop() {
    _timer ??= Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (_game != null) {
        _game?.update();
      }
      setState(() {});
    });
  }

  endLoop() {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeController? controller = ThemeNotifierProviderWidget.of(context);
    return LayoutBuilder(builder: (c, cs) {
      if (_game == null) {
        _game = Game(controller!);
        _game?.size = Size(cs.maxWidth, cs.maxHeight);
        _game?.startGame();
      }
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanUpdate: (details) {
          setState(() {
            _game?.move(details.delta.dx, details.delta.dy);
          });
        },
        child: SizedBox(
          child: _game?.getRenderWidget(),
        ),
      );
    });
  }
}

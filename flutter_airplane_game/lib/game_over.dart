import 'package:flutter/material.dart';

import 'game_page.dart';
import 'theme/theme_controller.dart';
import 'theme/theme_widget.dart';

///游戏结束
class GameOver extends StatelessWidget {
  final int score;

  const GameOver({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    ThemeController? controller = ThemeNotifierProviderWidget.of(context);
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: controller?.backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Game Over',
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 50.0,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                shadows: [
                  Shadow(
                      // bottomLeft
                      offset: Offset(-1.5, -1.5),
                      color: Colors.black),
                  Shadow(
                      // bottomRight
                      offset: Offset(1.5, -1.5),
                      color: Colors.black),
                  Shadow(
                      // topRight
                      offset: Offset(1.5, 1.5),
                      color: Colors.black),
                  Shadow(
                      // topLeft
                      offset: Offset(-1.5, 1.5),
                      color: Colors.black),
                ],
              ),
            ),
            const SizedBox(height: 50.0),
            Text('Your Score is: $score', style: const TextStyle(color: Colors.white, fontSize: 20.0)),
            const SizedBox(height: 50.0),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(foregroundColor: controller?.buttonTextColor, backgroundColor: controller?.buttonColor),
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const GamePage()));
              },
              icon: const Icon(Icons.refresh, color: Colors.white, size: 30.0),
              label: const Text("Try Again", style: TextStyle(color: Colors.white, fontSize: 20.0)),
            ),
          ],
        ),
      ),
    );
  }
}

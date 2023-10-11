import 'package:flutter/material.dart';
import 'package:flutter_snake_game/theme/theme_controller.dart';
import 'package:flutter_snake_game/theme/theme_widget.dart';

import 'game_page.dart';

///首页
class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
            const SizedBox(height: 50.0),
            const Text('Welcome to Snake Game',
                style: TextStyle(color: Colors.white, fontSize: 40.0, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 50.0),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const GamePage()));
              },
              style: ElevatedButton.styleFrom(foregroundColor: controller?.buttonTextColor, backgroundColor: controller?.buttonColor),
              icon: const Icon(Icons.play_circle_filled, color: Colors.white, size: 30.0),
              label: const Text("Ready Go...", style: TextStyle(color: Colors.white, fontSize: 20.0)),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_page.dart';
import 'theme/theme_controller.dart';
import 'theme/theme_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool isMobile = Platform.isAndroid || Platform.isIOS;

  if (isMobile) {
    ///设置横屏
    await SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);

    ///全面屏
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ThemeNotifierProviderWidget(
      data: ThemeController(),
      builder: (c, controller) {
        return MaterialApp(
          title: 'Snake Game',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const HomePage(),
        );
      },
    );
  }
}

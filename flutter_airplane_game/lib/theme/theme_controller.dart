import 'dart:math';
import 'package:flutter/material.dart';

/// @author jd
///主题控制器
class ThemeController extends ChangeNotifier {
  bool showPerformanceOverlay = false;
  bool checkerboardRasterCacheImages = false;
  bool checkerboardOffscreenLayers = false;
  bool debugPaintSizeEnabled = false;
  bool debugPaintPointersEnabled = false;
  bool debugPaintLayerBordersEnabled = false;
  bool debugRepaintRainbowEnabled = false;

  /// 当前主题颜色
  Color _themeColor = Colors.orangeAccent;
  Color backgroundColor = Colors.orangeAccent;

  Color buttonColor = Colors.purple;
  Color buttonTextColor = Colors.white;

  String backgroundImage = 'assets/images/bg.jpg.png';
  String pauseBtnImage = 'assets/images/game_pause_pressed.png';
  String runBtnImage = 'assets/images/game_pause_nor.png';
  String awardImage = 'assets/images/ufo1.png';
  String enemy1 = 'assets/images/enemy3_n1.png';
  String enemy2 = 'assets/images/enemy3_n2.png';
  String enemy3 = 'assets/images/enemy2.png';
  String enemy4 = 'assets/images/enemy1.png';
  String bullet1 = 'assets/images/bullet1.png';
  String bullet2 = 'assets/images/bullet2.png';
  String hero1 = 'assets/images/hero1.png';
  String hero2 = 'assets/images/hero2.png';

  void switchTheme({Color? color}) {
    _themeColor = color ?? _themeColor;
    backgroundColor = color ?? backgroundColor;
    notifyListeners();
  }

  void switchPerformanceOverlay(bool value) {
    showPerformanceOverlay = value;
    notifyListeners();
  }

  void switchCheckerboardRasterCacheImages(bool value) {
    checkerboardRasterCacheImages = value;
    notifyListeners();
  }

  void switchCheckerboardOffscreenLayers(bool value) {
    checkerboardOffscreenLayers = value;
    notifyListeners();
  }

  void switchDebugPaintSizeEnabled(bool value) {
    debugPaintSizeEnabled = value;
    notifyListeners();
  }

  void switchDebugPaintPointersEnabled(bool value) {
    debugPaintPointersEnabled = value;
    notifyListeners();
  }

  void switchDebugPaintLayerBordersEnabled(bool value) {
    debugPaintLayerBordersEnabled = value;
    notifyListeners();
  }

  void switchDebugRepaintRainbowEnabled(bool value) {
    debugRepaintRainbowEnabled = value;
    notifyListeners();
  }

  /// 随机一个主题色彩
  ///
  /// 可以指定明暗模式,不指定则保持不变
  void switchRandomTheme({Brightness? brightness}) {
    final int colorIndex = Random().nextInt(Colors.primaries.length - 1);
    switchTheme(
      color: Colors.primaries[colorIndex],
    );
  }
}

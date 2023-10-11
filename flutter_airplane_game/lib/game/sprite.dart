import 'package:flutter/material.dart';

import '../theme/theme_controller.dart';
import 'game.dart';

///精灵
abstract class Sprite {
  final ThemeController themeController;

  Sprite({
    required this.themeController,
  });

  //坐标
  double _x = 0;
  double _y = 0;
  double get x => _x;
  double get y => _y;

  ///是否已销毁
  bool destroyed = false;

  ///存活帧
  int flame = 0;

  ///碰撞偏移
  double collideOffset = 0;

  ///尺寸
  Size _size = Size.zero;

  ///图标
  String getImage();

  ///尺寸
  Size getSize();

  ///更新
  void update(Size size) {
    flame++;
  }

  ///获取渲染组件
  Widget getRenderWidget() {
    _size = getSize();
    return Positioned(
      left: x,
      top: y,
      child: Image.asset(
        getImage(),
        width: _size.width,
        height: _size.height,
      ),
    );
  }

  ///更改位置
  void move(double offsetX, double offsetY) {
    _x += offsetX;
    _y += offsetY;
  }

  ///更改位置
  void moveTo(double x, double y) {
    _x = x;
    _y = y;
  }

  get centerX => x + _size.width / 2;

  get centerY => y + _size.height / 2;

  void centerTo(double centerX, double centerY) {
    _x = centerX - _size.width / 2;
    _y = centerY - _size.height / 2;
  }

  ///控件区域
  Rect getRect() {
    return Rect.fromLTWH(
      x,
      y,
      _size.width,
      _size.height,
    );
  }

  /// 用于碰撞检测的Rect
  Rect getCollideRect() {
    Rect rect = getRect();
    return Rect.fromLTRB(
      rect.left + collideOffset,
      rect.top + collideOffset,
      rect.right - collideOffset,
      rect.bottom - collideOffset,
    );
  }

  /// 是否相交
  bool isIntersect(Sprite sprite) {
    Rect rect1 = getRect();
    Rect rect2 = sprite.getRect();
    Rect rect = rect1.intersect(rect2);
    return rect.width >= 0 && rect.height >= 0;
  }

  /// 是否碰撞
  bool isCollide(Sprite sprite) {
    Rect rect1 = getCollideRect();
    Rect rect2 = sprite.getCollideRect();
    Rect rect = rect1.intersect(rect2);
    return rect.width >= 0 && rect.height >= 0;
  }

  ///是否超出屏幕
  bool isOutScreen(Size size) {
    Rect rect1 = Rect.fromLTWH(0, 0, size.width, size.height);
    Rect rect2 = getRect();
    Rect rect = rect1.intersect(rect2);
    if (rect.width < 0 || rect.height < 0) {
      return true;
    }
    return false;
  }

  void hit(Game game) {}
}

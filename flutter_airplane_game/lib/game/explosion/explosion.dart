import '../auto_sprite.dart';
import 'package:flutter/material.dart';

///爆炸
class Explosion extends AutoSprite {
  List<String> imgs;
  final Size size;
  final double speed;
  Explosion({
    required this.imgs,
    required super.themeController,
    required this.size,
    this.speed = 2,
  });

  @override
  void update() {
    super.update();
    if (getImgIndex() >= imgs.length) {
      destroyed = true;
    }
  }

  int getImgIndex() {
    return flame ~/ 5;
  }

  @override
  String getImage() {
    return imgs[getImgIndex()];
  }

  @override
  Size getSize() {
    return size;
  }
}

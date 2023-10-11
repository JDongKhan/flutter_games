import '../auto_sprite.dart';
import 'package:flutter/material.dart';

///爆炸效果
class Explosion extends AutoSprite {
  List<String> images;
  final Size size;
  final double speed;
  Explosion({
    required this.images,
    required super.themeController,
    required this.size,
    this.speed = 2,
  });

  @override
  void update(Size size) {
    super.update(size);
    if (getImgIndex() >= images.length) {
      destroyed = true;
    }
  }

  int getImgIndex() {
    return flame ~/ images.length;
  }

  @override
  String getImage() {
    return images[getImgIndex()];
  }

  @override
  Size getSize() {
    return size;
  }
}

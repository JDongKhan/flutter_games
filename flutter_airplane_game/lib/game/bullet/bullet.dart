import 'package:flutter/cupertino.dart';
import '../auto_sprite.dart';

///子弹
class Bullet extends AutoSprite {
  final String image;
  Bullet({
    required this.image,
    required super.themeController,
  });

  @override
  double getSpeed() {
    return -8;
  }

  @override
  Size getSize() {
    return const Size(9, 21);
  }

  @override
  String getImage() {
    return image;
  }
}

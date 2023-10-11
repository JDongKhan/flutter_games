import 'dart:ui';

import 'bullet.dart';

class DefaultBullet extends Bullet {
  final String image;
  DefaultBullet({required this.image, required super.themeController});

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

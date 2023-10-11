import 'dart:ui';

import 'package:flutter/material.dart';
import '../auto_sprite.dart';

class Award extends AutoSprite {
  Award({
    required super.themeController,
  });

  @override
  String getImage() {
    return themeController.awardImage;
  }

  @override
  Size getSize() {
    return const Size(58, 88);
  }

  @override
  double getSpeed() {
    return 4;
  }
}

import 'dart:ui';

import 'award.dart';

class DefaultAward extends Award {
  DefaultAward({required super.themeController});

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

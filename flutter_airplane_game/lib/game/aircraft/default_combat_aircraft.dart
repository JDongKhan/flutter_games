import 'dart:ui';

import 'combat_aircraft.dart';

class DefaultCombatAircraft extends CombatAircraft {
  DefaultCombatAircraft({required super.themeController}) {
    collideOffset = 20;
  }

  @override
  Size getSize() {
    return const Size(100, 124);
  }

  @override
  String getImage() {
    return (flame % 10) < 5 ? themeController.hero1 : themeController.hero2;
  }

  @override
  List<String> getExplosionImageList() {
    return [
      'assets/images/hero_blowup_n1.png',
      'assets/images/hero_blowup_n2.png',
      'assets/images/hero_blowup_n3.png',
      'assets/images/hero_blowup_n4.png',
    ];
  }
}

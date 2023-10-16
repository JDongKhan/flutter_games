import 'dart:math';

extension RandomExt on Random {
  int nextRange(int min, int max) {
    return nextInt(max - min + 1) + min;
  }
}

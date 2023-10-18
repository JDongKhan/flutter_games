import 'package:dashbook/dashbook.dart';
import '../../../commons/commons.dart';
import 'lottie_animation_example.dart';
import 'package:flame/game.dart';

void addFlameLottieExample(Dashbook dashbook) {
  dashbook.storiesOf('FlameLottie').add(
        'Lottie Animation example',
        (_) => GameWidget(
          game: LottieAnimationExample(),
        ),
        codeLink: baseLink('flame_lottie/lottie_animation_example.dart'),
        info: LottieAnimationExample.description,
      );
}

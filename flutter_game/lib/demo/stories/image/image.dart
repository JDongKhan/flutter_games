import 'package:dashbook/dashbook.dart';

import '../../commons/commons.dart';
import 'resize.dart';
import 'package:flame/game.dart';

void addImageStories(Dashbook dashbook) {
  dashbook.storiesOf('Image')
    ..decorator(CenterDecorator())
    ..add(
      'resize',
      (context) => GameWidget(
        game: ImageResizeExample(
          Vector2(
            context.numberProperty('width', 200),
            context.numberProperty('height', 300),
          ),
        ),
      ),
      codeLink: baseLink('image/resize.dart'),
      info: ImageResizeExample.description,
    );
}

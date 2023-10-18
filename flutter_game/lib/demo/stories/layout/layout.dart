import 'package:dashbook/dashbook.dart';
import '../../commons/commons.dart';
import 'align_component.dart';
import 'package:flame/game.dart';

void addLayoutStories(Dashbook dashbook) {
  dashbook.storiesOf('Layout').add(
        'AlignComponent',
        (_) => GameWidget(game: AlignComponentExample()),
        codeLink: baseLink('layout/align_component.dart'),
        info: AlignComponentExample.description,
      );
}

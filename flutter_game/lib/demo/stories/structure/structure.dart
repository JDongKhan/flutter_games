import 'package:dashbook/dashbook.dart';
import '../../commons/commons.dart';
import 'levels.dart';
import 'package:flame/game.dart';

void addStructureStories(Dashbook dashbook) {
  dashbook.storiesOf('Structure').add(
        'Levels',
        (_) => GameWidget(game: LevelsExample()),
        info: LevelsExample.description,
        codeLink: baseLink('structure/levels.dart'),
      );
}

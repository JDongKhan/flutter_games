import 'package:dashbook/dashbook.dart';
import '../../commons/commons.dart';
import 'shapes.dart';
import 'package:flame/game.dart';

void addExperimentalStories(Dashbook dashbook) {
  dashbook.storiesOf('Experimental').add(
        'Shapes',
        (_) => GameWidget(game: ShapesExample()),
        codeLink: baseLink('experimental/shapes.dart'),
        info: ShapesExample.description,
      );
}

import 'package:dashbook/dashbook.dart';
import 'package:flame/game.dart';

import '../../../commons/commons.dart';
import 'basic_audio_example.dart';

void addAudioStories(Dashbook dashbook) {
  dashbook.storiesOf('Audio').add(
        'Basic Audio',
        (_) => GameWidget(game: BasicAudioExample()),
        codeLink: baseLink('bridge_libraries/audio/basic_audio_example.dart'),
        info: BasicAudioExample.description,
      );
}

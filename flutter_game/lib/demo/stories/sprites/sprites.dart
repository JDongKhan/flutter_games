import 'package:dashbook/dashbook.dart';
import '../../commons/commons.dart';
import 'base64_sprite_example.dart';
import 'basic_sprite_example.dart';
import 'sprite_batch_example.dart';
import 'sprite_batch_load_example.dart';
import 'sprite_group_example.dart';
import 'sprite_sheet_example.dart';
import 'package:flame/game.dart';

void addSpritesStories(Dashbook dashbook) {
  dashbook.storiesOf('Sprites')
    ..add(
      'Basic Sprite',
      (_) => GameWidget(game: BasicSpriteExample()),
      codeLink: baseLink('sprites/basic_sprite_example.dart'),
      info: BasicSpriteExample.description,
    )
    ..add(
      'Base64 Sprite',
      (_) => GameWidget(game: Base64SpriteExample()),
      codeLink: baseLink('sprites/base64_sprite_example.dart'),
      info: Base64SpriteExample.description,
    )
    ..add(
      'SpriteSheet',
      (_) => GameWidget(game: SpriteSheetExample()),
      codeLink: baseLink('sprites/sprite_sheet_example.dart'),
      info: SpriteSheetExample.description,
    )
    ..add(
      'SpriteBatch',
      (_) => GameWidget(game: SpriteBatchExample()),
      codeLink: baseLink('sprites/sprite_batch_example.dart'),
      info: SpriteBatchExample.description,
    )
    ..add(
      'SpriteBatch Auto Load',
      (_) => GameWidget(game: SpriteBatchLoadExample()),
      codeLink: baseLink('sprites/sprite_batch_load_example.dart'),
      info: SpriteBatchLoadExample.description,
    )
    ..add(
      'SpriteGroup',
      (_) => GameWidget(game: SpriteGroupExample()),
      codeLink: baseLink('sprites/sprite_group_example.dart'),
      info: SpriteGroupExample.description,
    );
}

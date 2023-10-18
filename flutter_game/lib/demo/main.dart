import 'package:dashbook/dashbook.dart';
import 'platform/stub_provider.dart' if (dart.library.html) 'platform/web_provider.dart';
import 'stories/animations/animations.dart';
import 'stories/bridge_libraries/audio/audio.dart';
import 'stories/bridge_libraries/flame_forge2d/flame_forge2d.dart';
import 'stories/bridge_libraries/flame_forge2d/joints/constant_volume_joint.dart';
import 'stories/bridge_libraries/flame_forge2d/joints/distance_joint.dart';
import 'stories/bridge_libraries/flame_forge2d/joints/friction_joint.dart';
import 'stories/bridge_libraries/flame_forge2d/joints/gear_joint.dart';
import 'stories/bridge_libraries/flame_forge2d/joints/motor_joint.dart';
import 'stories/bridge_libraries/flame_forge2d/joints/mouse_joint.dart';
import 'stories/bridge_libraries/flame_forge2d/joints/prismatic_joint.dart';
import 'stories/bridge_libraries/flame_forge2d/joints/pulley_joint.dart';
import 'stories/bridge_libraries/flame_forge2d/joints/revolute_joint.dart';
import 'stories/bridge_libraries/flame_forge2d/joints/rope_joint.dart';
import 'stories/bridge_libraries/flame_forge2d/joints/weld_joint.dart';
import 'stories/bridge_libraries/flame_isolate/isolate.dart';
import 'stories/bridge_libraries/flame_lottie/lottie.dart';
import 'stories/bridge_libraries/flame_spine/flame_spine.dart';
import 'stories/camera_and_viewport/camera_and_viewport.dart';
import 'stories/collision_detection/collision_detection.dart';
import 'stories/components/components.dart';
import 'stories/effects/effects.dart';
import 'stories/experimental/experimental.dart';
import 'stories/games/games.dart';
import 'stories/image/image.dart';
import 'stories/input/input.dart';
import 'stories/layout/layout.dart';
import 'stories/parallax/parallax.dart';
import 'stories/rendering/rendering.dart';
import 'stories/sprites/sprites.dart';
import 'stories/structure/structure.dart';
import 'stories/svg/svg.dart';
import 'stories/system/system.dart';
import 'stories/tiled/tiled.dart';
import 'stories/utils/utils.dart';
import 'stories/widgets/widgets.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  final page = PageProviderImpl().getPage();

  final routes = <String, FlameGame Function()>{
    'constant_volume_joint': ConstantVolumeJointExample.new,
    'distance_joint': DistanceJointExample.new,
    'friction_joint': FrictionJointExample.new,
    'gear_joint': GearJointExample.new,
    'motor_joint': MotorJointExample.new,
    'mouse_joint': MouseJointExample.new,
    'pulley_joint': PulleyJointExample.new,
    'prismatic_joint': PrismaticJointExample.new,
    'revolute_joint': RevoluteJointExample.new,
    'rope_joint': RopeJointExample.new,
    'weld_joint': WeldJointExample.new,
  };
  final game = routes[page]?.call();
  if (game != null) {
    runApp(GameWidget(game: game));
  } else {
    runAsDashbook();
  }
}

void runAsDashbook() {
  final dashbook = Dashbook(
    title: 'Flame Examples',
    theme: ThemeData.dark(),
  );

  // Some small sample games
  // addGameStories(dashbook);

  // Show some different ways of structuring games
  addStructureStories(dashbook);

  // Feature examples
  addAudioStories(dashbook);
  addAnimationStories(dashbook);
  addCameraAndViewportStories(dashbook);
  addCollisionDetectionStories(dashbook);
  addComponentsStories(dashbook);
  addEffectsStories(dashbook);
  addExperimentalStories(dashbook);
  addInputStories(dashbook);
  addLayoutStories(dashbook);
  addParallaxStories(dashbook);
  addRenderingStories(dashbook);
  addTiledStories(dashbook);
  addSpritesStories(dashbook);
  addSvgStories(dashbook);
  addSystemStories(dashbook);
  addUtilsStories(dashbook);
  addWidgetsStories(dashbook);
  addImageStories(dashbook);

  // Bridge package examples
  addForge2DStories(dashbook);
  addFlameIsolateExample(dashbook);
  addFlameLottieExample(dashbook);
  addFlameSpineExamples(dashbook);

  runApp(dashbook);
}

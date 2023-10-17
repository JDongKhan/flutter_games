import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class ZoomExample extends FlameGame {
  static const String description = '''
    On web: use scroll to zoom in and out.\n
    On mobile: use scale gesture to zoom in and out.
  ''';

  ZoomExample({
    required Vector2 viewportResolution,
  }) : super(
          camera: CameraComponent.withFixedResolution(
            width: viewportResolution.x,
            height: viewportResolution.y,
          ),
        );

  @override
  Future<void> onLoad() async {
    final flameSprite = await loadSprite('flame.png');
    final player = SpriteComponent(
      sprite: flameSprite,
      size: Vector2(149, 211),
      position: Vector2(200, 200),
    )
      ..anchor = Anchor.center
      ..debugMode = true;
    world.add(player);

    //地图背景
    final buttonComponent = ButtonComponent(
      button: RectangleComponent(
        size: size,
        paint: Paint()
          ..color = Colors.orange
          ..style = PaintingStyle.stroke,
      ),
      buttonDown: RectangleComponent(
        size: size,
        paint: Paint()
          ..color = Colors.orange
          ..style = PaintingStyle.stroke,
      ),
      position: Vector2(0, 0),
      onPressed: () {},
    )..debugMode = true;
    world.add(buttonComponent);
  }

  void clampZoom() {
    camera.viewfinder.zoom = camera.viewfinder.zoom.clamp(0.05, 3.0);
  }

  static const zoomPerScrollUnit = 0.02;

  @override
  void onScroll(PointerScrollInfo info) {
    camera.viewfinder.zoom += info.scrollDelta.global.y.sign * zoomPerScrollUnit;
    clampZoom();
  }

  late double startZoom;

  @override
  void onScaleStart(_) {
    startZoom = camera.viewfinder.zoom;
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    final currentScale = info.scale.global;
    if (!currentScale.isIdentity()) {
      camera.viewfinder.zoom = startZoom * currentScale.y;
      clampZoom();
    } else {
      final delta = info.delta.global;
      camera.viewfinder.position.translate(-delta.x, -delta.y);
    }
  }
}

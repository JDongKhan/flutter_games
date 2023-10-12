import 'dart:ui';

import 'package:flame/game.dart';

import '../../component/tank/default_tank.dart';
import '../../component/tank/tank_factory.dart';
import '../../controller/controller_listener.dart';

///负责管理玩家tank
mixin PlayerTankTheater on FlameGame implements TankController {
  PlayerTank? _player;
  PlayerTank? get player => _player;

  ///初始化玩家
  void initPlayer(Vector2 canvasSize) {
    final Size bgSize = canvasSize.toSize();

    final TankModelBuilder playerBuilder =
        TankModelBuilder(id: DateTime.now().millisecondsSinceEpoch, bodySpritePath: 'tank/t_body_blue.webp', turretSpritePath: 'tank/t_turret_blue.webp', activeSize: bgSize);

    _player ??= TankFactory.buildPlayerTank(playerBuilder.build(), Offset(bgSize.width / 2, bgSize.height / 2));
    _player?.deposit();
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    if (_player == null) {
      initPlayer(canvasSize);
    }
    _player?.onGameResize(canvasSize);
    super.onGameResize(canvasSize);
  }

  @override
  void render(Canvas canvas) {
    _player?.render(canvas);
    super.render(canvas);
  }

  @override
  void update(double dt) {
    _player?.update(dt);
    super.update(dt);
  }

  ///点击开火
  @override
  void fireButtonTriggered() {
    _player?.fireButtonTriggered();
  }

  ///坦克旋转
  @override
  void bodyAngleChanged(Offset newAngle) {
    _player?.bodyAngleChanged(newAngle);
  }

  ///炮台旋转
  @override
  void turretAngleChanged(Offset newAngle) {
    _player?.turretAngleChanged(newAngle);
  }
}

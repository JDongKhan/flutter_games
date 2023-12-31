import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../controller/controller_listener.dart';
import '../../game/tank_game.dart';
import 'base_tank.dart';
import 'bullet/bullet.dart';
import 'tank_model.dart';

///电脑
class ComputerTank extends DefaultTank with HasGameRef {
  factory ComputerTank.green({
    required int id,
    required Offset birthPosition,
    required TankModel config,
  }) {
    return ComputerTank(id: id, birthPosition: birthPosition, config: config, bullet: ComputerBullet.green(tankId: id, activeSize: config.activeSize));
  }

  factory ComputerTank.sand({
    required int id,
    required Offset birthPosition,
    required TankModel config,
  }) {
    return ComputerTank(id: id, birthPosition: birthPosition, config: config, bullet: ComputerBullet.sand(tankId: id, activeSize: config.activeSize));
  }

  ComputerTank({
    required int id,
    required Offset birthPosition,
    required TankModel config,
    required this.bullet,
  }) : super(id: id, birthPosition: birthPosition, config: config);

  ///用于生成随机路线
  static final Random random = Random();

  ///活动边界
  static final double activeBorderLow = 0.01, activeBorderUp = 1 - activeBorderLow;

  ///最大单向移动距离
  static const double maxMovedDistance = 100;

  BaseBullet bullet;

  ///移动的距离
  double movedDis = 0;

  Timer? _timer;

  ///生成随机路径
  void _generateNewTarget() {
    final double x = random.nextDouble().clamp(activeBorderLow, activeBorderUp) * config.activeSize.width;
    final double y = random.nextDouble().clamp(activeBorderLow, activeBorderUp) * config.activeSize.height;

    targetOffset = Offset(x, y);

    final Offset vector = targetOffset - position;
    targetBodyAngle = vector.direction;
    targetTurretAngle = vector.direction;
  }

  @override
  void onMount() {
    TankGame tankGame = gameRef as TankGame;
    double t = 1 / (tankGame.level + 1);
    _timer ??= Timer(t, repeat: true, onTick: fire);
    _generateNewTarget();
    super.onMount();
  }

  @override
  void update(double dt) {
    _timer?.update(dt);
    super.update(dt);
  }

  @override
  void onRemove() {
    _timer?.stop();
    super.onRemove();
  }

  @override
  void move(double t) {
    if (targetBodyAngle != null) {
      movedDis += speed * t;
      if (movedDis < maxMovedDistance) {
        super.move(t);
      } else {
        movedDis = 0;
        _generateNewTarget();
      }
    }
  }

  int getScore() {
    return 10;
  }

  @override
  BaseBullet getBullet() => bullet.copyWith(position: getBulletFirePosition(), angle: getBulletFireAngle());
}

///玩家
class PlayerTank extends DefaultTank with Notifier, HasGameRef implements TankController {
  PlayerTank({required int id, required Offset birthPosition, required TankModel config})
      : bullet = PlayerBullet(tankId: id, activeSize: config.activeSize),
        super(id: id, birthPosition: birthPosition, config: config);

  final PlayerBullet bullet;

  @override
  BaseBullet getBullet() => bullet.copyWith(position: getBulletFirePosition(), angle: getBulletFireAngle());

  ///得分
  int _score = 0;
  int get score => _score;
  set score(v) {
    _score = v;
    //难度级别
    TankGame tankGame = gameRef as TankGame;
    if (v > 1000) {
      tankGame.level = 3;
    } else if (v > 500) {
      tankGame.level = 2;
    } else if (v > 100) {
      tankGame.level = 1;
    }
    notifyListeners();
  }

  @override
  void bodyAngleChanged(Offset newAngle) {
    if (newAngle == Offset.zero) {
      targetBodyAngle = null;
    } else {
      targetBodyAngle = newAngle.direction; //范围（pi,-pi）
    }
  }

  @override
  void fireButtonTriggered() {
    fire();
  }

  @override
  void turretAngleChanged(Offset newAngle) {
    if (newAngle == Offset.zero) {
      targetTurretAngle = null;
    } else {
      targetTurretAngle = newAngle.direction;
    }
  }
}

///可实例化的tank模型
///
/// * [BaseTank]实例化的基准模型，不具备业务区分能力。见[PlayerTank]和[ComputerTank]
abstract class DefaultTank extends BaseTank {
  DefaultTank({
    required int id,
    required Offset birthPosition,
    required TankModel config,
  }) : super(id: id, birthPosition: birthPosition, config: config);

  ///子弹
  final List<BaseBullet> _bullets = [];
  List<BaseBullet> get bullets => _bullets;

  ///炮弹最大数量
  final int _maxPlayerBulletNum = 20;

  ///开火
  @override
  void fire() {
    if (_bullets.length < _maxPlayerBulletNum) {
      BaseBullet bullet = getBullet();
      add(bullet);
      _bullets.add(bullet);
    }
  }

  @override
  void onChildrenChanged(Component child, ChildrenChangeType type) {
    if (type == ChildrenChangeType.removed) {
      _bullets.remove(child);
    }
    super.onChildrenChanged(child, type);
  }

  @override
  void onGameResize(Vector2 size) {
    config.activeSize = size.toSize();
    super.onGameResize(size);
  }

  @override
  void render(Canvas canvas) {
    if (!isStandBy) {
      return;
    }
    //将canvas 原点设置在tank上
    canvas.save();
    canvas.translate(position.dx, position.dy);
    drawBody(canvas);
    drawTurret(canvas);
    canvas.restore();
  }

  @override
  void update(double dt) {
    if (!isStandBy) {
      return;
    }
    rotateBody(dt);
    rotateTurret(dt);
    move(dt);
  }

  ///绘制炮体
  void drawBody(Canvas canvas) {
    canvas.rotate(bodyAngle);
    bodySprite?.renderRect(canvas, Rect.fromCenter(center: Offset.zero, width: bodySize.width, height: bodySize.height));
  }

  ///绘制炮台
  void drawTurret(Canvas canvas) {
    //旋转炮台
    canvas.rotate(turretAngle);
    // 绘制炮塔
    turretSprite?.renderRect(canvas, Rect.fromCenter(center: Offset.zero, width: turretSize.width, height: turretSize.height));
  }

  ///移动
  void move(double t) {
    if (targetBodyAngle == null) return;
    if (bodyAngle == targetBodyAngle) {
      //tank 直线时 移动速度快
      position += Offset.fromDirection(bodyAngle, speed * t); //100 是像素
    } else {
      //tank旋转时 移动速度要慢
      position += Offset.fromDirection(bodyAngle, turnSpeed * t);
    }
    //边界处理
    position = Offset(position.dx.clamp(0, config.activeSize.width), position.dy.clamp(0, config.activeSize.height));
  }

  ///旋转炮体
  void rotateBody(double t) {
    if (targetBodyAngle != null) {
      final double rotationRate = pi * t;
      if (bodyAngle < targetBodyAngle!) {
        //车体角度和目标角度差额
        if ((targetBodyAngle! - bodyAngle).abs() > pi) {
          bodyAngle -= rotationRate;
          if (bodyAngle < -pi) {
            bodyAngle += pi * 2;
          }
        } else {
          bodyAngle += rotationRate;
          if (bodyAngle > targetBodyAngle!) {
            bodyAngle = targetBodyAngle!;
          }
        }
      } else if (bodyAngle > targetBodyAngle!) {
        if ((targetBodyAngle! - bodyAngle).abs() > pi) {
          bodyAngle += rotationRate;
          if (bodyAngle > pi) {
            bodyAngle -= pi * 2;
          }
        } else {
          bodyAngle -= rotationRate;
          if (bodyAngle < targetBodyAngle!) {
            bodyAngle = targetBodyAngle!;
          }
        }
      }
    }
  }

  ///旋转炮台
  void rotateTurret(double t) {
    if (targetTurretAngle != null) {
      final double rotationRate = pi * t;
      //炮塔和车身夹角
      final double localTargetTurretAngle = targetTurretAngle! - bodyAngle;
      if (turretAngle < localTargetTurretAngle) {
        if ((localTargetTurretAngle - turretAngle).abs() > pi) {
          turretAngle -= rotationRate;
          //超出临界值，进行转换 即：小于-pi时，转换成pi之后继续累加，具体参考 笛卡尔坐标，范围是（-pi,pi）
          if (turretAngle < -pi) {
            turretAngle += pi * 2;
          }
        } else {
          turretAngle += rotationRate;
          if (turretAngle > localTargetTurretAngle) {
            turretAngle = localTargetTurretAngle;
          }
        }
      }
      if (turretAngle > localTargetTurretAngle) {
        if ((localTargetTurretAngle - turretAngle).abs() > pi) {
          turretAngle += rotationRate;
          if (turretAngle > pi) {
            turretAngle -= pi * 2;
          }
        } else {
          turretAngle -= rotationRate;
          if (turretAngle < localTargetTurretAngle) {
            turretAngle = localTargetTurretAngle;
          }
        }
      }
    }
  }

  ///坦克id
  @override
  int getTankId() => id;

  ///弹框角度
  @override
  double getBulletFireAngle() {
    double bulletAngle = bodyAngle + turretAngle;
    while (bulletAngle > pi) {
      bulletAngle -= pi * 2;
    }
    while (bulletAngle < -pi) {
      bulletAngle += pi * 2;
    }
    return bulletAngle;
  }

  ///坦克开火的位置
  @override
  Offset getBulletFirePosition() =>
      position +
      Offset.fromDirection(
        getBulletFireAngle(),
        bulletBornLoc,
      );
}

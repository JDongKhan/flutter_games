import 'dart:math';
import 'dart:ui';

import 'default_tank.dart';
import 'tank_model.dart';

///用于构建tank
class TankFactory {
  static PlayerTank buildPlayerTank(TankModel model, Offset birthPosition) {
    return PlayerTank(id: model.id, birthPosition: birthPosition, config: model);
  }

  static ComputerTank buildGreenTank(TankModel model, Offset birthPosition) {
    return ComputerTank.green(id: model.id, birthPosition: birthPosition, config: model);
  }

  static ComputerTank buildSandTank(TankModel model, Offset birthPosition) {
    return ComputerTank.sand(id: model.id, birthPosition: birthPosition, config: model);
  }
}

///[TankModel]构建器
class TankModelBuilder {
  TankModelBuilder({
    required this.id,
    required this.bodySpritePath,
    required this.turretSpritePath,
    required this.activeSize,
  });

  final int id;

  ///车体纹理
  final String bodySpritePath;

  ///炮塔纹理
  final String turretSpritePath;

  ///活动范围
  /// * 一般是地图尺寸
  Size activeSize;

  ///车体宽度
  double bodyWidth = 38;

  ///车体高度
  double bodyHeight = 32;

  ///炮塔宽度(长)
  double turretWidth = 22;

  ///炮塔高度(直径)
  double turretHeight = 6;

  ///坦克尺寸比例
  double ratio = 0.7;

  ///直线速度
  double speed = 80;

  ///转弯速度
  double turnSpeed = 40;

  ///设置活动范围
  void setActiveSize(Size size) {
    activeSize = size;
  }

  ///设置车身尺寸
  void setBodySize(double width, double height) {
    bodyWidth = width;
    bodyHeight = height;
  }

  ///设置炮塔尺寸
  void setTurretSize(double width, double height) {
    turretWidth = width;
    turretHeight = height;
  }

  ///设置tank尺寸比例
  void setTankRatio(double r) {
    ratio = r;
  }

  ///设置直线速度
  void setDirectSpeed(double s) {
    speed = s;
  }

  ///设置转弯速度
  void setTurnSpeed(double s) {
    turnSpeed = s;
  }

  TankModel build() {
    return TankModel(
      id: id,
      bodySpritePath: bodySpritePath,
      turretSpritePath: turretSpritePath,
      ratio: ratio,
      speed: speed,
      turnSpeed: turnSpeed,
      bodyWidth: bodyWidth,
      bodyHeight: bodyHeight,
      turretWidth: turretWidth,
      turretHeight: turretHeight,
      activeSize: activeSize,
    );
  }
}

///用于生产绿色tank
class GreenTankFlowLine extends ComputerTankFlowLine<ComputerTank> {
  GreenTankFlowLine(Offset depositPosition, Size activeSize) : super(depositPosition, activeSize);

  @override
  ComputerTank spawnTank() {
    final TankModelBuilder greenBuilder =
        TankModelBuilder(id: DateTime.now().millisecondsSinceEpoch, bodySpritePath: 'tank/t_body_green.webp', turretSpritePath: 'tank/t_turret_green.webp', activeSize: activeSize);
    return TankFactory.buildGreenTank(greenBuilder.build(), depositPosition);
  }
}

///用于生产黄色tank
class SandTankFlowLine extends ComputerTankFlowLine<ComputerTank> {
  SandTankFlowLine(Offset depositPosition, Size activeSize) : super(depositPosition, activeSize);

  @override
  ComputerTank spawnTank() {
    final TankModelBuilder sandBuilder =
        TankModelBuilder(id: DateTime.now().millisecondsSinceEpoch, bodySpritePath: 'tank/t_body_sand.webp', turretSpritePath: 'tank/t_turret_sand.webp', activeSize: activeSize);
    return TankFactory.buildSandTank(sandBuilder.build(), depositPosition);
  }
}

///流水线基类
/// * 用于生成电脑tank
/// * 见[ComputerTankSpawner]
abstract class ComputerTankFlowLine<T extends ComputerTank> implements ComputerTankSpawnerTrigger<T> {
  ComputerTankFlowLine(this.depositPosition, this.activeSize);

  ///活动范围
  final Size activeSize;

  ///部署位置
  final Offset depositPosition;
}

abstract class ComputerTankSpawnerTrigger<T extends ComputerTank> {
  T spawnTank();
}

///电脑生成器
/// * [PlayerTankTheater]下，tank生成的直接参与者，负责电脑的随机生成。
///
/// * [spawners]为具体[ComputerTank]的生成流水线，见[GreenTankFlowLine]和[SandTankFlowLine]
///   流水线内部的[ComputerTank]产出由[TankFactory]负责。
class ComputerTankSpawner {
  late Size size;
  Random random = Random();

  ///快速生成tank
  /// * 各生产线生成一辆tank
  /// * [plaza]为接收tank对象
  List<ComputerTank> init(Size size) {
    this.size = size;

    ///流水线
    List<ComputerTank> spawners = [];
    for (int i = 0; i < 5; i++) {
      int x = random.nextInt(size.width.toInt());
      int y = random.nextInt(size.height.toInt());
      int type = random.nextInt(2);
      ComputerTankFlowLine e = _buildTankFlowLine(type, Offset(x.toDouble(), y.toDouble()));
      spawners.add(e.spawnTank());
    }
    return spawners;
  }

  ///随机生成一辆tank
  /// * [plaza]为接收tank对象
  ComputerTank randomSpan() {
    int type = random.nextInt(2);
    int x = random.nextInt(size.width.toInt());
    int y = random.nextInt(size.height.toInt());
    ComputerTankFlowLine e = _buildTankFlowLine(type, Offset(x.toDouble(), y.toDouble()));
    return e.spawnTank();
  }

  ComputerTankFlowLine _buildTankFlowLine(int type, Offset position) {
    ComputerTankFlowLine e;
    if (type == 0) {
      e = SandTankFlowLine(position, size);
    } else {
      e = GreenTankFlowLine(position, size);
    }
    return e;
  }
}

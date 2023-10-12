import 'dart:ui';

///坦克基础配置模型
/// * 由[TankModelBuilder]负责构建
class TankModel {
  TankModel(
      {required this.id,
      required this.bodySpritePath,
      required this.turretSpritePath,
      required this.ratio,
      required this.speed,
      required this.turnSpeed,
      required this.bodyWidth,
      required this.bodyHeight,
      required this.turretWidth,
      required this.turretHeight,
      required this.activeSize});

  final int id;

  ///车体宽度
  final double bodyWidth;

  ///车体高度
  final double bodyHeight;

  ///炮塔宽度(长)
  final double turretWidth;

  ///炮塔高度(直径)
  final double turretHeight;

  ///坦克尺寸比例
  final double ratio;

  ///直线速度
  final double speed;

  ///转弯速度
  final double turnSpeed;

  ///车体纹理
  final String bodySpritePath;

  ///炮塔纹理
  final String turretSpritePath;

  ///活动范围
  /// * 一般是地图尺寸
  Size activeSize;
}

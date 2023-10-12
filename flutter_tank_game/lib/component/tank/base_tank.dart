import 'dart:ui';

import 'package:flame/sprite.dart';

import '../base_component.dart';
import 'bullet/bullet.dart';
import 'tank_factory.dart';
import 'tank_model.dart';

///tank基础模型
/// * 定义基础行为属性，外观属性依赖于[TankModel]
/// * @see [TankModelBuilder]
abstract class BaseTank extends WindowComponent {
  BaseTank({
    required int id,
    required this.config,
    required Offset birthPosition,
  }) : position = birthPosition {
    bodyRect = Rect.fromCenter(center: Offset.zero, width: bodyWidth * ratio, height: bodyHeight * ratio);
    turretRect = Rect.fromCenter(center: Offset.zero, width: turretWidth * ratio, height: turretHeight * ratio);
    init();
  }

  final TankModel config;

  ///坦克位置
  Offset position;

  ///移动到目标位置
  late Offset targetOffset;

  ///车体角度
  double bodyAngle = 0;

  ///炮塔角度
  double turretAngle = 0;

  ///车体目标角度
  /// * 为空时，说明没有角度变动
  double? targetBodyAngle;

  ///炮塔目标角度
  /// * 为空时，说明没有角度变动
  double? targetTurretAngle;

  ///炮弹出炮口位置
  double get bulletBornLoc => 18;

  ///车体尺寸
  late Rect bodyRect;

  ///炮塔尺寸
  late Rect turretRect;

  ///车体
  Sprite? bodySprite;

  ///炮塔
  Sprite? turretSprite;

  ///配置完成
  bool isStandBy = false;

  int get id => config.id;

  ///车体宽度
  double get bodyWidth => config.bodyWidth;

  ///车体高度
  double get bodyHeight => config.bodyHeight;

  ///炮塔宽度(长)
  double get turretWidth => config.turretWidth;

  ///炮塔高度(直径)
  double get turretHeight => config.turretHeight;

  ///坦克尺寸比例
  double get ratio => config.ratio;

  ///直线速度
  double get speed => config.speed;

  ///转弯速度
  double get turnSpeed => config.turnSpeed;

  ///车体纹理
  String get bodySpritePath => config.bodySpritePath;

  ///炮塔纹理
  String get turretSpritePath => config.turretSpritePath;

  Future<bool> init() async {
    bodySprite = await Sprite.load(bodySpritePath);
    turretSprite = await Sprite.load(turretSpritePath);
    isStandBy = true;
    return isStandBy;
  }

  ///开火
  void fire();

  ///隶属于的坦克
  int getTankId();

  ///获取炮弹发射位置
  Offset getBulletFirePosition();

  ///获取炮弹发射角度
  double getBulletFireAngle();

  ///获取tank所装配的炮弹
  BaseBullet getBullet();
}

import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import '../../base_component.dart';

///电脑炮弹
class ComputerBullet extends BaseBullet {
  factory ComputerBullet.green({required int tankId, required Size activeSize}) {
    return ComputerBullet('tank/bullet_green.webp', tankId: tankId, activeSize: activeSize);
  }

  factory ComputerBullet.sand({required int tankId, required Size activeSize}) {
    return ComputerBullet('tank/bullet_green.webp', tankId: tankId, activeSize: activeSize);
  }

  ComputerBullet(this.spritePath, {required int tankId, required Size activeSize}) : super(tankId: tankId, activeSize: activeSize);

  ///子弹样式文件地址
  final String spritePath;

  ///子弹区域
  @override
  Size get size => const Size(6, 4);

  @override
  Future<void> loadSprite() async {
    sprite = await Sprite.load(spritePath);
  }

  @override
  ComputerBullet copyWith({int? tankId, Size? activeSize, Offset? position, double? angle, BulletStatus status = BulletStatus.none}) {
    final ComputerBullet pb = ComputerBullet(spritePath, tankId: tankId ?? this.tankId, activeSize: activeSize ?? this.activeSize);
    pb.position = position ?? Offset.zero;
    pb.angle = angle ?? 0;
    pb.status = status;
    return pb;
  }
}

///玩家炮弹
class PlayerBullet extends BaseBullet {
  PlayerBullet({required int tankId, required Size activeSize}) : super(tankId: tankId, activeSize: activeSize);

  @override
  Size get size => const Size(8, 4);

  @override
  Future<void> loadSprite() async {
    sprite = await Sprite.load('tank/bullet_blue.webp');
  }

  @override
  PlayerBullet copyWith({int? tankId, Size? activeSize, Offset? position, double? angle, BulletStatus status = BulletStatus.none}) {
    final PlayerBullet pb = PlayerBullet(tankId: tankId ?? this.tankId, activeSize: activeSize ?? this.activeSize);
    pb.position = position ?? Offset.zero;
    pb.angle = angle ?? 0;
    pb.status = status;
    return pb;
  }
}

///炮弹状态
enum BulletStatus {
  none, //初始状态
  standBy, // 准备状态： 可参与绘制
  hit, //击中状态
  outOfBorder, //飞出边界
}

///炮弹基类
abstract class BaseBullet extends WindowComponent {
  BaseBullet({
    required this.tankId,
    required this.activeSize,
  });

  BaseBullet copyWith({
    int? tankId,
    Size? activeSize,
    Offset? position,
    double? angle,
    BulletStatus status = BulletStatus.none,
  });

  ///隶属于的tank
  final int tankId;

  ///子弹尺寸
  Size get size;

  ///位置
  Offset position = Offset.zero;

  Rect get rect => position & size;

  ///子弹皮肤
  Sprite? sprite;

  ///可活动范围
  /// * 超出判定为失效子弹
  Size activeSize;

  ///速度
  double speed = 200;

  ///角度
  double angle = 0;

  ///子弹状态
  BulletStatus status = BulletStatus.none;

  ///可移除的子弹
  bool get dismissible => status.index > 1;

  void hit() {
    status = BulletStatus.hit;
    removeFromParent();
  }

  ///加载炮弹纹理
  Future<void> loadSprite();

  @override
  FutureOr<void> onLoad() async {
    await init();
  }

  ///初始化炮弹
  Future init() async {
    await loadSprite();
    status = BulletStatus.standBy;
  }

  @override
  void onGameResize(Vector2 size) {
    activeSize = size.toSize();
    super.onGameResize(size);
  }

  @override
  void render(Canvas canvas) {
    if (dismissible) return;
    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(angle);
    sprite?.renderRect(canvas, Rect.fromCenter(center: Offset.zero, width: size.width, height: size.height));
    canvas.restore();
  }

  @override
  void update(double dt) {
    if (dismissible) return;
    position += Offset.fromDirection(angle, speed * dt);

    if (!activeSize.contains(position)) {
      status = BulletStatus.outOfBorder;
      removeFromParent();
    }
  }
}

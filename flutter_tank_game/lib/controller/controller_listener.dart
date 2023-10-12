import 'dart:ui';

///控制接口
abstract class DirectionControllerListener {
  ///车身角度变化
  void bodyAngleChanged(Offset newAngle);

  ///炮塔角度变化
  void turretAngleChanged(Offset newAngle);
}

///开火接口
abstract class ButtonControllerListener {
  ///开火按钮触发
  void fireButtonTriggered();
}

///[DirectionControllerListener]和[ButtonControllerListener]的连接器
abstract class TankController implements DirectionControllerListener, ButtonControllerListener {}

import 'package:flutter/material.dart';
import 'controller_listener.dart';
import 'widgets/fire_button.dart';
import 'widgets/joy_stick.dart';

///控制器
class ControlPanelWidget extends StatelessWidget {
  const ControlPanelWidget({Key? key, required this.tankController}) : super(key: key);

  final TankController tankController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        //发射按钮
        Row(
          children: [
            const SizedBox(width: 48),
            FireButton(buttonControllerListener: tankController),
            const Spacer(),
            FireButton(buttonControllerListener: tankController),
            const SizedBox(width: 48),
          ],
        ),
        const SizedBox(height: 20),
        //摇杆
        Row(
          children: [
            const SizedBox(width: 48),
            JoyStick(onChange: tankController.bodyAngleChanged),
            const Spacer(),
            JoyStick(onChange: tankController.turretAngleChanged),
            const SizedBox(width: 48)
          ],
        ),
        const SizedBox(height: 24)
      ],
    );
  }
}

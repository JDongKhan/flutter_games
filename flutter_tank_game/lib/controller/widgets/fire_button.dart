import 'package:flutter/material.dart';

import '../controller_listener.dart';

///开火按钮
class FireButton extends StatefulWidget {
  const FireButton({Key? key, required this.buttonControllerListener}) : super(key: key);

  final ButtonControllerListener buttonControllerListener;

  @override
  State<FireButton> createState() => _FireButtonState();
}

class _FireButtonState extends State<FireButton> {
  bool _press = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.buttonControllerListener.fireButtonTriggered,
      onTapDown: (_) {
        setState(() {
          _press = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _press = false;
        });
      },
      onTapCancel: () {
        setState(() {
          _press = false;
        });
      },
      child: Container(
        height: 64,
        width: 64,
        decoration: BoxDecoration(
          color: _press ? const Color(0x55ffffff) : const Color(0x88ffffff),
          borderRadius: BorderRadius.circular(32),
        ),
      ),
    );
  }
}

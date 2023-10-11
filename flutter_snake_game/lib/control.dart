import 'package:flutter/material.dart';

const double controlSize = 50;

class Control extends StatefulWidget {
  final IconData icon;
  final Function onTap;
  const Control({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  State<Control> createState() => _ControlState();
}

class _ControlState extends State<Control> {
  bool _press = false;
  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        setState(() {
          _press = true;
        });
      },
      onPointerUp: (_) {
        setState(() {
          _press = false;
        });
        widget.onTap.call();
      },
      child: Container(
        width: controlSize,
        height: controlSize,
        decoration: _press
            ? BoxDecoration(
                color: Colors.black.withAlpha(150),
                borderRadius: BorderRadius.circular(controlSize / 2),
              )
            : BoxDecoration(
                color: Colors.black.withAlpha(50),
                borderRadius: BorderRadius.circular(controlSize / 2),
              ),
        child: Icon(
          widget.icon,
          color: _press ? Colors.grey : Colors.white,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Snake extends StatelessWidget {
  const Snake({super.key});

  //这里可以通过服务下发不同的样式
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: Colors.yellow,
        border: Border.all(color: const Color(0xFFFFFFFF)),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

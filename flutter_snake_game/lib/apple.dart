import 'package:flutter/widgets.dart';

class Apple extends StatelessWidget {
  const Apple({super.key});

  //这里可以通过服务下发不同的样式
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: const Color(0xFFFF0000),
        border: Border.all(color: const Color(0xFFFFFFFF)),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

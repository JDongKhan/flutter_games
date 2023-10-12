import 'package:flutter/material.dart';

// 该方法用于在Dart中获取模板类型
//Type _typeOf<T>() => T;

typedef ThemeWidgetBuilder<T extends ChangeNotifier> = Widget Function(BuildContext context, T controller);

class ThemeNotifierProviderWidget<T extends ChangeNotifier> extends StatefulWidget {
  const ThemeNotifierProviderWidget({
    super.key,
    required this.data,
    required this.builder,
  });

  final ThemeWidgetBuilder builder;
  final T data;

  //定义一个便捷方法，方便子树中的widget获取共享数据
  static T? of<T>(BuildContext context) {
//    final type = _typeOf<JDInheritedProvider<T>>();
//    final provider =  context.inheritFromWidgetOfExactType(type) as JDInheritedProvider<T>;
    final provider = context.dependOnInheritedWidgetOfExactType<ThemeProvider<T>>();
    return provider?.data;
  }

  @override
  State createState() => _ThemeNotifierProviderState<T>();
}

class _ThemeNotifierProviderState<T extends ChangeNotifier> extends State<ThemeNotifierProviderWidget<T>> {
  void update() {
    //如果数据发生变化（model类调用了notifyListeners），重新构建InheritedProvider
    // ignore: always_specify_types
    setState(() {});
  }

  @override
  void didUpdateWidget(ThemeNotifierProviderWidget<T> oldWidget) {
    //当Provider更新时，如果新旧数据不"=="，则解绑旧数据监听，同时添加新数据监听
    if (widget.data != oldWidget.data) {
      oldWidget.data.removeListener(update);
      widget.data.addListener(update);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    // 给model添加监听器
    widget.data.addListener(update);
    super.initState();
  }

  @override
  void dispose() {
    // 移除model的监听器
    widget.data.removeListener(update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeProvider<T>(
      data: widget.data,
      child: widget.builder(context, widget.data),
    );
  }
}

// 一个通用的InheritedWidget，保存任需要跨组件共享的状态
class ThemeProvider<T> extends InheritedWidget {
  const ThemeProvider({super.key, required this.data, required Widget child}) : super(child: child);

  //共享状态使用泛型
  final T data;

  @override
  bool updateShouldNotify(ThemeProvider<T> oldWidget) {
    //在此简单返回true，则每次更新都会调用依赖其的子孙节点的`didChangeDependencies`。
    return true;
  }
}

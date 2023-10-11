import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'apple.dart';
import 'control.dart';
import 'snake.dart';
import 'game_over.dart';
import 'theme/theme_controller.dart';
import 'theme/theme_widget.dart';

enum Direction { left, right, up, down }

const int pieceSize = 10;

///游戏页面
class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with TickerProviderStateMixin {
  final List<Point> _snakePiecePositions = [];
  Point _applePosition = const Point(0, 0);
  Timer? _timer;
  Direction _direction = Direction.up;
  late Size _size;
  late Point _maxCount;
  late Point _centerPoint;
  final int _speed = 500;
  int _score = 0;
  final int _initLength = 5;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _initRunningState();
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeController? controller = ThemeNotifierProviderWidget.of(context);
    return Container(
      color: controller?.backgroundColor,
      child: LayoutBuilder(
        builder: (context, cs) {
          _size = Size(cs.maxWidth, cs.maxHeight);
          _maxCount = Point(_size.width ~/ pieceSize, _size.height ~/ pieceSize);
          _centerPoint = Point(_maxCount.x % 2 == 0 ? _maxCount.x / 2 : (_maxCount.x / 2 + 1), _maxCount.y % 2 == 0 ? _maxCount.y / 2 : (_maxCount.y / 2 + 1));
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onVerticalDragUpdate: (detail) {
              if (detail.delta.dy < 0) {
                _changeDirection(Direction.up);
              } else if (detail.delta.dy > 0) {
                _changeDirection(Direction.down);
              }
            },
            onHorizontalDragUpdate: (detail) {
              if (detail.delta.dx < 0) {
                _changeDirection(Direction.left);
              } else if (detail.delta.dx > 0) {
                _changeDirection(Direction.right);
              }
            },
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                ..._drawGameState(),
                ..._buildControls(),
              ],
            ),
          );
        },
      ),
    );
  }

  ///初始化运行数据状态
  void _initRunningState() {
    _generateFirstSnakePosition();
    _generateNewApple();
    _direction = Direction.up;
    _timer = Timer.periodic(Duration(milliseconds: _speed), _onTimerTick);
  }

  ///初始化蛇进入状态
  void _generateFirstSnakePosition() {
    setState(() {
      int c = _initLength ~/ 2;
      for (int i = 0; i < _initLength; i++) {
        _snakePiecePositions.add(Point(_centerPoint.x, _centerPoint.y - (c - i)));
      }
    });
  }

  ///生成苹果的位置
  void _generateNewApple() {
    setState(() {
      Random rng = Random();
      var min = 0;
      var maxX = _size.width ~/ pieceSize;
      var maxY = _size.height ~/ pieceSize;
      var nextX = min + rng.nextInt(maxX - min);
      var nextY = min + rng.nextInt(maxY - min);
      var newApple = Point(nextX.toDouble(), nextY.toDouble());
      if (_snakePiecePositions.contains(newApple)) {
        _generateNewApple();
      } else {
        _applePosition = newApple;
      }
    });
  }

  ///定时器刷新页面
  void _onTimerTick(Timer timer) {
    //移动位置
    _move();
    //判断是否撞墙
    if (_isWallCollision()) {
      _gotoGameOver();
      return;
    }

    //撞到了自己
    if (_isSelfCollision()) {
      _gotoGameOver();
      return;
    }

    //判断有没有吃了苹果
    if (_isAppleCollision()) {
      if (_isBoardFilled()) {
        _gotoGameOver();
      } else {
        _generateNewApple();
        _grow();
      }
      return;
    }

    //改变速度
    _changeSpeed();

    //计算得分
    _score = _snakePiecePositions.length - _initLength;
  }

  ///绘制游戏状态  这里可以用canvas实现
  List<Widget> _drawGameState() {
    ///绘制蛇的位置
    List<Positioned> snakePiecesAndApple = [];
    for (var i in _snakePiecePositions) {
      snakePiecesAndApple.add(
        Positioned(
          left: i.x.toDouble() * pieceSize,
          top: i.y.toDouble() * pieceSize,
          child: const Snake(),
        ),
      );
    }

    ///绘制苹果的位置
    final apple = Positioned(
      left: _applePosition.x.toDouble() * pieceSize,
      top: _applePosition.y.toDouble() * pieceSize,
      child: const Apple(),
    );
    snakePiecesAndApple.add(apple);
    return snakePiecesAndApple;
  }

  ///成长了
  void _grow() {
    setState(() {
      _snakePiecePositions.insert(0, _getNewHeadPosition());
    });
  }

  ///移动
  void _move() {
    setState(() {
      //根据方向添加一个新的，移除最后一个
      _snakePiecePositions.insert(0, _getNewHeadPosition());
      _snakePiecePositions.removeLast();
    });
  }

  ///改变速度
  void _changeSpeed() {
    int sd = _speed - (_snakePiecePositions.length - _initLength) * 20;
    if (sd < 20) {
      sd = 20;
    }
    debugPrint('速度:$sd');
    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: sd), _onTimerTick);
  }

  ///判断是否撞墙了
  bool _isWallCollision() {
    var currentHeadPos = _snakePiecePositions.first;
    if (currentHeadPos.x < 0 || currentHeadPos.y < 0 || currentHeadPos.x > _maxCount.x || currentHeadPos.y > _maxCount.y) {
      debugPrint('撞墙了');
      return true;
    }
    return false;
  }

  ///判断有没有吃了苹果
  bool _isAppleCollision() {
    if (_snakePiecePositions.first.x == _applePosition.x && _snakePiecePositions.first.y == _applePosition.y) {
      debugPrint('吃了苹果');
      return true;
    }

    return false;
  }

  ///判断是否撞了自己
  bool _isSelfCollision() {
    Point headPoint = _snakePiecePositions.first;
    for (int i = 1; i < _snakePiecePositions.length; i++) {
      Point point = _snakePiecePositions[i];
      if (headPoint.x == point.x && headPoint.y == point.y) {
        debugPrint('撞了自己');
        return true;
      }
    }
    return false;
  }

  ///是否满了
  bool _isBoardFilled() {
    //计算总个数
    int totalPiecesThatBoardCanFit = (_size.width * _size.height) ~/ (pieceSize * pieceSize);
    if (_snakePiecePositions.length == totalPiecesThatBoardCanFit) {
      return true;
    }

    return false;
  }

  ///添加新的节点
  Point _getNewHeadPosition() {
    Point newHeadPos;
    switch (_direction) {
      case Direction.left:
        var currentHeadPos = _snakePiecePositions.first;
        newHeadPos = Point(currentHeadPos.x - 1, currentHeadPos.y);
        break;

      case Direction.right:
        var currentHeadPos = _snakePiecePositions.first;
        newHeadPos = Point(currentHeadPos.x + 1, currentHeadPos.y);
        break;

      case Direction.up:
        var currentHeadPos = _snakePiecePositions.first;
        newHeadPos = Point(currentHeadPos.x, currentHeadPos.y - 1);
        break;

      case Direction.down:
        var currentHeadPos = _snakePiecePositions.first;
        newHeadPos = Point(currentHeadPos.x, currentHeadPos.y + 1);
        break;
    }

    return newHeadPos;
  }

  ///控制按钮 跟手势一起完善丰富的交互
  List<Widget> _buildControls() {
    return [
      Positioned(
        bottom: 0,
        child: SizedBox(
          width: 180,
          height: 180,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              //左
              Positioned(
                left: 0,
                child: Control(
                  icon: Icons.arrow_left,
                  onTap: () {
                    _changeDirection(Direction.left);
                  },
                ),
              ),

              //上
              Positioned(
                top: 0,
                child: Control(
                  icon: Icons.arrow_drop_up,
                  onTap: () {
                    _changeDirection(Direction.up);
                  },
                ),
              ),

              //右
              Positioned(
                right: 0,
                child: Control(
                  icon: Icons.arrow_right,
                  onTap: () {
                    _changeDirection(Direction.right);
                  },
                ),
              ),

              //下
              Positioned(
                bottom: 0,
                child: Control(
                  icon: Icons.arrow_drop_down,
                  onTap: () {
                    _changeDirection(Direction.down);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  void _changeDirection(Direction direction) {
    //反方向不可用
    if (direction == Direction.up && _direction == Direction.down) {
      return;
    }
    if (direction == Direction.down && _direction == Direction.up) {
      return;
    }
    if (direction == Direction.left && _direction == Direction.right) {
      return;
    }
    if (direction == Direction.right && _direction == Direction.left) {
      return;
    }
    setState(() {
      _direction = direction;
    });
  }

  ///跳转到游戏结束页面
  void _gotoGameOver() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => GameOver(score: _score)));
  }
}

import 'package:flutter/cupertino.dart';

class DataManager extends ChangeNotifier {
  static DataManager instance = DataManager._();
  DataManager._();

  bool _pause = false;
  set pause(v) {
    _pause = v;
    notifyListeners();
  }

  bool get pause => _pause;

  bool _gameOver = false;
  set gameOver(v) {
    _gameOver = v;
    notifyListeners();
  }

  bool get gameOver => _gameOver;

  int _score = 0;
  int get score => _score;
  set score(v) {
    _score = v;
    //难度级别
    if (v > 1000) {
      level = 3;
    } else if (v > 500) {
      level = 2;
    } else if (v > 100) {
      level = 1;
    }
    notifyListeners();
  }

  int level = 0;

  void startGame() {
    pause = false;
    gameOver = false;
    notifyListeners();
  }
}

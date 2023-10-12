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
    notifyListeners();
  }

  void startGame() {
    pause = false;
    gameOver = false;
    notifyListeners();
  }
}

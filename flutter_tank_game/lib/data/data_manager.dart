import 'package:flutter/cupertino.dart';

class DataManager extends ChangeNotifier {
  static DataManager instance = DataManager._();
  DataManager._();

  bool _gameOver = false;
  set gameOver(v) {
    _gameOver = v;
    notifyListeners();
  }

  bool get gameOver => _gameOver;

  ///困难等级
  int level = 0;
}

import 'package:flutter/cupertino.dart';

class DataStore extends ChangeNotifier {
  static DataStore instance = DataStore._();
  DataStore._();
  Map<int, int> scores = {};

  ///获取得分
  int getScore(int? playerId) {
    if (playerId == null) {
      return 0;
    }
    return scores[playerId] ?? 0;
  }

  ///存储分数
  void putScore(int playerId, int score) {
    scores[playerId] = score;
    notifyListeners();
  }

  ///添加分数
  void addScore(int playerId, int score) {
    int s = getScore(playerId);
    s += score;
    scores[playerId] = s;
    notifyListeners();
  }
}

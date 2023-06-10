import 'package:flutter/cupertino.dart';

class GameState {
  static final GameState _instance = GameState._internal();

  bool _isUserLevel = false;
  int _levelNumber = 0;
  String _levelName = '';

  factory GameState() {
    return _instance;
  }

  GameState._internal();

  bool get getUserLevel => _isUserLevel;

  int get getLevelNumber => _levelNumber;

  String get getLevelName => _levelName;

  void setLevel({String? name, int? number}) {
    if (name != null) {
      _isUserLevel = false;
      _levelName = name;
    } else if (number != null) {
      _isUserLevel = false;
      _levelNumber = number;
    } else {
      debugPrint('Warning: You must set a level name or number');
    }
  }
}
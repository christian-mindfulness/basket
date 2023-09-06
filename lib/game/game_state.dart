import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';

import '../utils/level_options.dart';

class GameState {
  static final GameState _instance = GameState._internal();

  bool _isUserLevel = false;
  bool _isAsset = false;
  int _levelNumber = 0;
  String _levelName = '';
  Function exitCallback = (){};
  LevelOptions _levelOptions = LevelOptions(gravity: Vector2(0, 10));

  factory GameState() {
    return _instance;
  }

  GameState._internal();

  bool get getIsUserLevel => _isUserLevel;

  bool get getIsAsset => _isAsset;

  int get getLevelNumber => _levelNumber;

  String get getLevelName => _levelName;

  LevelOptions get getLevelOptions => _levelOptions;

  void setLevel({String? name, int? number}) {
    if (name != null) {
      _isUserLevel = true;
      _levelName = name;
    } else if (number != null) {
      _isUserLevel = false;
      _levelNumber = number;
    } else {
      debugPrint('Warning: You must set a level name or number');
    }
  }

  void setExitCallBack(Function callback) {
    exitCallback = callback;
  }

  void setIsAsset(bool newValue) {
    _isAsset = newValue;
  }

  void setLevelOptions(LevelOptions newOptions) {
    _levelOptions = newOptions;
  }
}
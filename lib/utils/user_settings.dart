import 'dart:math';
import 'package:basket/game/game_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSettings {
  SharedPreferences? _prefs;
  List<LevelState> levelStates = List.filled(100, LevelState.locked);

  void initialise () async {
    _prefs = await SharedPreferences.getInstance();
  }

  double? getMusicVolume() {
    return _prefs?.getDouble('musicVolume');
  }

  void setMusicVolume(double newVolume) {
    newVolume = min(max(newVolume, 0), 1);
    _prefs?.setDouble('musicVolume', newVolume);
  }

  String convertLevelStates() {
    return levelStates[0].name;
  }
}
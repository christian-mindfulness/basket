import 'dart:math';

import 'package:basket/managers/component_manager.dart';
import 'package:basket/sprites/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

import '../sprites/walls.dart';
import '../sprites/circles.dart';
import '../sprites/world.dart';

class BasketBall extends FlameGame with HasCollisionDetection, HasKeyboardHandlerComponents {

  BasketBall({super.children});
  final MyWorld _world = MyWorld();
  final Player _player = Player();
  late ComponentManager componentManager;
  int _currentLevel = 0;
  String _currentType = 'N';

  @override
  Future<void> onLoad() async {
    print(canvasSize);
    print(size);
    camera.viewport = FixedResolutionViewport(Vector2(400, 800));
    await add(_world);
    add(_player);
    overlays.removeAll(['failedOverlay', 'victoryOverlay', 'gameOverlay']);
    overlays.add('mainMenu');
    componentManager = ComponentManager();
    add(componentManager);
  }

  void mainMenu() {
    overlays.removeAll(['failedOverlay', 'victoryOverlay', 'gameOverlay', 'tutorialOverlay']);
    overlays.add('mainMenu');
    pause();
  }

  void playerImpulse(Vector2 size) {
    _player.impulse(size);
  }

  void clearTutorialOverlay() {
    overlays.removeAll(['failedOverlay', 'victoryOverlay', 'tutorialOverlay', 'mainMenu']);
    overlays.add('gameOverlay');
    unPause();
  }

  void setLevel(int level, {String type='N'}) {
    _currentLevel = level;
    _currentType = type;
    print('Set level $type-$level');
    componentManager.clean();
    componentManager.setLevel(level, type);
    _player.resetPosition();
    if (type == 'T') {
      overlays.removeAll(['mainMenu', 'gameOverlay', 'failedOverlay', 'victoryOverlay']);
      overlays.add('tutorialOverlay');
      pause();
    } else {
      overlays.removeAll(['mainMenu', 'failedOverlay', 'victoryOverlay', 'tutorialOverlay']);
      overlays.add('gameOverlay');
      unPause();
    }
  }

  int getLevel() {
    return _currentLevel;
  }

  String getType() {
    return _currentType;
  }

  void nextLevel() {
    setLevel(_currentLevel + 1);
  }

  void replayLevel() {
    setLevel(_currentLevel, type: _currentType);
  }

  void failed() {
    overlays.removeAll(['mainMenu', 'gameOverlay', 'victoryOverlay']);
    overlays.add('failedOverlay');
    pause();
  }

  void victory() {
    if (_currentType == 'T') {
      setLevel(_currentLevel + 1, type: 'T');
    } else {
      overlays.removeAll(['mainMenu', 'gameOverlay', 'failedOverlay']);
      overlays.add('victoryOverlay');
      Future.delayed(const Duration(milliseconds: 1000), () {
        pause();
      });
    }
  }

  void pause() {
    if (! paused) {
      togglePauseState();
    }
  }

  void unPause() {
    if (paused) {
      togglePauseState();
    }
  }

  bool isPaused() {return paused;}

  void togglePauseState() {
    if (paused) {
      resumeEngine();
    } else {
      pauseEngine();
    }
  }
}
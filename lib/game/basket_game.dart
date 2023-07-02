import 'dart:convert';

import 'package:basket/managers/component_manager.dart';
import 'package:basket/sprites/player.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import '../sprites/enemies.dart';
import '../sprites/goal.dart';
import '../sprites/walls.dart';
import '../sprites/world.dart';
import '../utils/component_list.dart';
import '../utils/files.dart';
import 'game_state.dart';

class BasketBall extends FlameGame with HasCollisionDetection, HasKeyboardHandlerComponents {

  BasketBall({super.children});
  final BackgroundImage _backgroundImage = BackgroundImage();
  Player _player = Player(position: Vector2(0,0), size: Vector2(0,0), type: BallType.metal, initialized: false);
  late ComponentManager componentManager;
  Vector2 worldSize = Vector2(400, 800);
  int _currentLevel = 0;
  String _currentType = 'N';
  late final CameraComponent cameraComponent;
  late final World world;
  ComponentList componentList = ComponentList([]);
  final GameState gameState = GameState();

  @override
  Future<void> onLoad() async {
    world = World();
    cameraComponent = CameraComponent.withFixedResolution(
      world: world,
      width: worldSize.x,
      height: worldSize.y,
    );
    cameraComponent.viewfinder.anchor = Anchor.topLeft;
    addAll([world, cameraComponent]);

    print(canvasSize);
    print(size);

    reset();
    world.add(_backgroundImage);
    //componentManager = ComponentManager();
    //world.add(componentManager);
  }

  void reset() async {
    unPause();
    overlays.removeAll(['failedOverlay', 'victoryOverlay', 'gameOverlay', 'mainMenu']);
    overlays.add('gameOverlay');
    world.removeAll(componentList.getList());
    if (_player.initialized) {
      world.remove(_player);
    }
    componentList = ComponentList([]);
    await _loadLevel(gameState.getLevelName);
    world.addAll(componentList.getList());
    world.add(_player);
  }

  Future<void> _loadLevel(String levelName) async {
    print('LoadLevel: Level name = ${gameState.getLevelName}');
    if (levelName == '') {
      componentList.addAll([
        WoodWall(size: Vector2(400, 10), position: Vector2(200, 5)),
        WoodWall(size: Vector2(400, 15), position: Vector2(200, 795)),
        BrickWall(size: Vector2(10, 800), position: Vector2(5, 400)),
        BrickWall(size: Vector2(10, 800), position: Vector2(395, 400)),
        BasketGoal(size: Vector2(50, 50), position: Vector2(300, 100)),
      ]);
      _player = Player(
          position: Vector2(200, 650),
          size: Vector2(30, 30),
          type: BallType.basket,
          initialized: true,
      );
      debugPrint(componentList.toString());
    } else {
      final file = await localFile(levelName);
      String fileString = await file.readAsString();
      var json = jsonDecode(fileString);
      for (Map entry in json) {
        switch (entry['name']) {
          case 'Wood Wall': {
            componentList.add(WoodWall.fromJson(entry['values']));
          }
          break;
          case 'Brick Wall': {
            componentList.add(BrickWall.fromJson(entry['values']));
          }
          break;
          case 'Spike': {
            componentList.add(Spike.fromJson(entry['values']));
          }
          break;
          case 'Star': {
            componentList.add(Star.fromJson(entry['values']));
          }
          break;
          case 'Goal': {
            componentList.add(BasketGoal.fromJson(entry['values']));
          }
          break;
          case 'Ball': {
            _player = Player.fromJson(entry['values']);
            debugPrint('Done player $_player');
          }
          break;
          default: {
            print('Entry ${entry["name"]} not recognised');
          }
        }
        print(entry);
      }
    }
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

  void quit() {
    gameState.exitCallback();
  }
}
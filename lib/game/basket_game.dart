import 'dart:convert';

import 'package:basket/managers/component_manager.dart';
import 'package:basket/sprites/player.dart';
import 'package:basket/utils/level_options.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../sprites/basket_sprites.dart';
import '../sprites/enemies.dart';
import '../sprites/goal.dart';
import '../sprites/walls.dart';
import '../sprites/world.dart';
import '../utils/component_list.dart';
import '../utils/files.dart';
import '../utils/write_game.dart';
import 'game_state.dart';
import 'dart:developer';

class BasketBall extends FlameGame with HasCollisionDetection, HasKeyboardHandlerComponents {

  BasketBall({super.children});
  final BackgroundImage _backgroundImage = BackgroundImage();
  Player _player = Player(position: Vector2(0,0), size: Vector2(0,0), type: BallType.metal, initialized: false);
  late ComponentManager componentManager;
  Vector2 worldSize = Vector2(400, 800);
  int _currentLevel = 0;
  String _currentType = 'N';
  String _levelInfoTitle = '';
  String _levelInfoText = '';
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
        WoodWall(size: Vector2(400, 10), startPosition: Vector2(200, 5)),
        WoodWall(size: Vector2(400, 15), startPosition: Vector2(200, 795)),
        BrickWall(size: Vector2(10, 800), startPosition: Vector2(5, 400)),
        BrickWall(size: Vector2(10, 800), startPosition: Vector2(395, 400)),
        BasketGoal(size: Vector2(50, 50), startPosition: Vector2(300, 100)),
      ]);
      _player = Player(
          position: Vector2(200, 650),
          size: Vector2(30, 30),
          type: BallType.basket,
          initialized: true,
      );
      debugPrint(componentList.toString());
    } else {
      String fileString = '';
      if (gameState.getIsAsset) {
        fileString = await rootBundle.loadString('assets/levels/$levelName');
      } else {
        final file = await localFile(levelName);
        fileString = await file.readAsString();
      }
      var json = jsonDecode(fileString);
      debugPrint('Reading game from json');
      debugPrint(json.toString());
      log(json.toString());
      ReadWriteGame readWriteGame = ReadWriteGame.fromJson(json, (){}, false);
      componentList = readWriteGame.componentList;
      _player = componentList.getPlayer;
      gameState.setLevelOptions(readWriteGame.levelOptions);
      _levelInfoTitle = readWriteGame.levelInfoTitle;
      _levelInfoText = readWriteGame.levelInfoText;

      // Add all of the newly generated components to the world
      for (BasketSprite entry in componentList.getList()) {
        world.add(entry);
      }
      world.add(_player);
    }
    if (_levelInfoText == '') {
      overlays.removeAll(['mainMenu', 'failedOverlay', 'victoryOverlay', 'informationOverlay']);
      overlays.add('gameOverlay');
      unPause();
    } else {
      overlays.removeAll(['mainMenu', 'gameOverlay', 'failedOverlay', 'victoryOverlay']);
      overlays.add('informationOverlay');
      pause();
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

  void clearInformationOverlay() {
    overlays.removeAll(['failedOverlay', 'victoryOverlay', 'informationOverlay', 'mainMenu']);
    overlays.add('gameOverlay');
    unPause();
  }

  void setLevel(int level, {String type='N'}) {
    _currentLevel = level;
    _currentType = type;
    print('Set level $type-$level');
    componentManager.clean();
    componentManager.setLevel(level, type);
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

  String get getLevelInfoTitle => _levelInfoTitle;

  String get getLevelInfoText => _levelInfoText;

  LevelOptions get getLevelOptions => gameState.getLevelOptions;

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
    pauseEngine();
  }

  void unPause() {
    resumeEngine();
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
    pauseEngine();
    gameState.exitCallback();
  }
}
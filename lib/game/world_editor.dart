import 'dart:convert';
import 'dart:math';
import 'dart:developer' as developer;

import 'package:basket/game/game_state.dart';
import 'package:basket/sprites/basket_sprites.dart';
import 'package:basket/sprites/draggable.dart';
import 'package:basket/sprites/player.dart';
import 'package:basket/utils/component_list.dart';
import 'package:basket/utils/files.dart';
import 'package:basket/utils/level_options.dart';
import 'package:basket/utils/write_game.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';

import '../sprites/world.dart';
import '../utils/movement.dart';

enum Components {
  brickWall,
  woodWall,
  slime,
  trampoline,
  arrow,
  oneway,
  spike,
  star,
}

enum Operations {
  resize,
  rotate,
  delete,
  ballType,
  movement,
}

class WorldEditorGame extends FlameGame {
  late BasketSprite currentComp;
  final BackgroundImage _backgroundImage = BackgroundImage();
  late final CameraComponent cameraComponent;
  late final World world;
  Vector2 worldSize = Vector2(400, 800);
  final GameState gameState = GameState();
  late Function exitCallback;
  String _levelInfoTitle = '';
  String _levelInfoText = '';

  ComponentList componentList = ComponentList([]);

  void reset() {
    world.removeAll(componentList.getList());
    componentList = ComponentList([]);
    _loadLevel(gameState.getLevelName);
    world.addAll(componentList.getList());
  }

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
    reset();
    world.add(_backgroundImage);
    //overlays.add('editorOverlay');
  }

  void _loadLevel(String levelName) async {
    debugPrint('LoadLevel: Level name = ${gameState.getLevelName}');
    if (levelName == '') {
      componentList.addAll([
        DragWoodWall(size: Vector2(400, 10), startPosition: Vector2(200, 5), showResize: showResize),
        DragWoodWall(size: Vector2(400, 10), startPosition: Vector2(200, 795), showResize: showResize),
        DragBrickWall(size: Vector2(10, 800), startPosition: Vector2(5, 400), showResize: showResize),
        DragBrickWall(size: Vector2(10, 800), startPosition: Vector2(395, 400), showResize: showResize),
        DragBasket(size: Vector2(110, 90), startPosition: Vector2(300, 100), showResize: showResize),
        DragBall(position: Vector2(200, 650), size: Vector2(30, 30), type: BallType.basket, showResize: showResize),
      ]);
    } else {
      final file = await localFile(levelName);
      String fileString = await file.readAsString();
      var json = jsonDecode(fileString);
      ReadWriteGame readWriteGame = ReadWriteGame.fromJson(json, showResize, true);
      componentList = readWriteGame.componentList;
      gameState.setLevelOptions(readWriteGame.levelOptions);
      _levelInfoTitle = readWriteGame.levelInfoTitle;
      _levelInfoText = readWriteGame.levelInfoText;
      for (BasketSprite entry in componentList.getList()) {
        world.add(entry);
      }
    }
    currentComp = componentList.last();
  }

  BasketSprite getComponent(Components component) {
    switch (component) {
      case Components.brickWall:
        {
          return DragBrickWall(startPosition: Vector2(100, 100), size: Vector2(100, 10), showResize: showResize);
        }
      case Components.woodWall:
        {
          return DragWoodWall(startPosition: Vector2(100, 100), size: Vector2(100, 10), showResize: showResize);
        }
      case Components.spike:
        {
          return DragSpike(startPosition: Vector2(100, 100), size: Vector2(20, 50), showResize: showResize);
        }
      case Components.slime:
        {
          return DragSlime(startPosition: Vector2(100, 100), size: Vector2(100, 20), showResize: showResize);
        }
      case Components.trampoline:
        {
          return DragTrampoline(startPosition: Vector2(100, 100), size: Vector2(100, 20), showResize: showResize);
        }
      case Components.arrow:
        {
          return DragArrow(startPosition: Vector2(100, 100), size: Vector2(50, 30), showResize: showResize);
        }
      case Components.oneway:
        {
          return DragOneWayPlatform(startPosition: Vector2(100, 100), size: Vector2(100, 10), showResize: showResize);
        }
      case Components.star:
        {
          return DragStar(startPosition: Vector2(100, 100), size: Vector2(50, 50), showResize: showResize);
        }
    }
  }

  void addComponent(Components component) {
    componentList.add(getComponent(component));
    world.add(componentList.last());
  }

  double getAngle() {
    if (currentComp != null) {
      return currentComp.angle * 180 / pi;
    } else {
      return 0;
    }
  }

  void setAngle(double newAngle) {
    currentComp.angle = radians(newAngle);
    (currentComp as MovementSprite).startAngle = radians(newAngle);
  }

  Vector2 getSize() {
    if (currentComp != null) {
      return currentComp.size;
    } else {
      return Vector2(0, 0);
    }
  }

  void setSize(Vector2 size) {
    debugPrint('World editor: changing size to $size');
    currentComp.size = size;
  }

  void showResize(BasketSprite object) {
    overlays.remove('resizeOverlay');
    debugPrint('${object.size}');
    currentComp = object;
    overlays.add('resizeOverlay');
  }

  void showLevelOptionsDialogue() {
    overlays.removeAll(['resizeOverlay', 'levelOptionsOverlay']);
    overlays.add('levelOptionsOverlay');
  }

  void hideLevelOptionsDialogue() {
    overlays.remove('levelOptionsOverlay');
  }

  void loadLevel() async {
    final file = await localFile('temp');
    String result = await file.readAsString();
    debugPrint(result, wrapWidth: 100);
  }

  void startSaveRequest({required Function exit}) async {
    overlays.add('saveOverlay');
    exitCallback = exit;
  }

  void saveFile(String fName) async {
    overlays.remove('saveOverlay');
    debugPrint(fName);
    debugPrint('${componentList.getList()}');
    String levelLayout = jsonEncode(ReadWriteGame(
      componentList: componentList,
      levelOptions: gameState.getLevelOptions,
      levelInfoTitle: _levelInfoTitle,
      levelInfoText: _levelInfoText,
    ));
    final file = await localFile(fName);
    file.writeAsString(levelLayout);
    debugPrint('Have written this to file ${file.path}');
    developer.log(levelLayout);
    if (exitCallback != null) {
      exitCallback();
    }
  }

  void hideSaveOverlay() {
    overlays.remove('saveOverlay');
  }

  void setLevelInformation() {
    overlays.add('textInfoOverlay');
  }

  String get getLevelInfoTitle => _levelInfoTitle;
  String get getLevelInfoText => _levelInfoText;

  void setLevelInfoTitle(String newText) {
    _levelInfoTitle = newText;
  }

  void setLevelInfoText(String newText) {
    _levelInfoText = newText;
  }

  void hideTextInfoDialog() {
    overlays.remove('textInfoOverlay');
  }

  void hideResize() {
    overlays.remove('resizeOverlay');
  }

  void deleteComponent() {
    debugPrint('Attempting to delete $currentComp');
    world.remove(currentComp);
    componentList.remove(currentComp);
  }

  List<Operations> getOperations() {
    if (currentComp is DragBrickWall ||
        currentComp is DragWoodWall ||
        currentComp is DragSpike ||
        currentComp is DragStar ||
        currentComp is DragSlime ||
        currentComp is DragTrampoline ||
        currentComp is DragArrow
    ) {
      return [Operations.resize, Operations.rotate, Operations.delete, Operations.movement];
    } else if (currentComp is DragOneWayPlatform) {
      return [Operations.resize, Operations.rotate, Operations.delete, Operations.movement];
    } else if (currentComp is DragBall) {
      return [Operations.ballType];
    } else if (currentComp is DragBasket) {
      return [Operations.resize, Operations.rotate, Operations.movement];
    } else {
      return [Operations.resize, Operations.rotate, Operations.delete];
    }
  }

  void setBallType(BallType newType) {
    if (currentComp is DragBall) {
      (currentComp as DragBall).changeType(newType);
    } else {
      debugPrint('Warning attempt to call changeType on non-ball');
    }
  }

  BallType getBallType() {
    if (currentComp is DragBall) {
      return (currentComp as DragBall).current;
    } else {
      return BallType.basket;
    }
  }

  Movement getMovement() {
    if (currentComp is MovementSprite) {
      return (currentComp as MovementSprite).movement;
    } else {
      return Movement(allow: false, position: Vector2(0,0), time: 1, angle: 0, continuousAngle: false);
    }
  }

  void setMovement(Movement newValues) {
    debugPrint('Setting movement as $newValues');
    if (currentComp is MovementSprite) {
      (currentComp as MovementSprite).movement = newValues;
    }
  }

  String getComponentName() {
    return getCompName(currentComp);
  }

  String getElementName(Components comp) {
    var component = getComponent(comp);
    return getCompName(component);
  }

  String getCompName(BasketSprite component) {
    return component.getName();
  }

  LevelOptions getLevelOptions() {
    return gameState.getLevelOptions;
  }

  void setLevelOptions(LevelOptions levelOptions) {
    gameState.setLevelOptions(levelOptions);
  }
}

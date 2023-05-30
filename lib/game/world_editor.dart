import 'dart:convert';
import 'dart:math';

import 'package:basket/sprites/basket_sprites.dart';
import 'package:basket/sprites/draggable.dart';
import 'package:basket/sprites/player.dart';
import 'package:basket/utils/component_list.dart';
import 'package:basket/utils/files.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';

import '../sprites/world.dart';
import '../utils/movement.dart';

enum Components {
  brickWall,
  woodWall,
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

class WorldEditorGame extends FlameGame with HasDraggableComponents, HasTappableComponents {
  late BasketSprite currentComp;
  final MyWorld _world = MyWorld();
  late final CameraComponent cameraComponent;
  late final World world;
  Vector2 worldSize = Vector2(400, 800);

  ComponentList componentList = ComponentList([
    DragWoodWall(size: Vector2(400, 10), position: Vector2(200, 5)),
    DragWoodWall(size: Vector2(400, 15), position: Vector2(200, 795)),
    DragBrickWall(size: Vector2(10, 800), position: Vector2(5, 400)),
    DragBrickWall(size: Vector2(10, 800), position: Vector2(395, 400)),
    DragBasket(size: Vector2(50, 50), position: Vector2(300, 100)),
    DragBall(position: Vector2(200, 650), size: Vector2(30, 30), type: BallType.basket),
  ]);

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
    currentComp = BasketSprite(position: Vector2(0,0), size: Vector2(0,0));
    world.addAll(componentList.getList());
    world.add(_world);
    //overlays.add('editorOverlay');
  }

  BasketSprite getComponent(Components component) {
    switch (component) {
      case Components.brickWall:
        {
          return DragBrickWall(position: Vector2(100, 100), size: Vector2(10, 100));
        }
      case Components.woodWall:
        {
          return DragWoodWall(position: Vector2(100, 100), size: Vector2(10, 100));
        }
      case Components.spike:
        {
          return DragSpike(position: Vector2(100, 100), size: Vector2(10, 20));
        }
      case Components.star:
        {
          return DragStar(position: Vector2(100, 100), size: Vector2(20, 20));
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
    currentComp.angle = newAngle;
  }

  Vector2 getSize() {
    if (currentComp != null) {
      return currentComp.size;
    } else {
      return Vector2(0, 0);
    }
  }

  void setSize(Vector2 size) {
    currentComp.size = size;
  }

  void showResize(BasketSprite object) {
    overlays.remove('resizeOverlay');
    print('${object.size}');
    currentComp = object;
    overlays.add('resizeOverlay');
  }

  void showGravityDialogue() {
    print('Do nothing');
  }

  void loadLevel() async {
    final file = await localFile('temp');
    String result = await file.readAsString();
    debugPrint(result, wrapWidth: 100);
  }

  void startSaveRequest() async {
    overlays.add('saveOverlay');
  }

  void saveFile(String fName) async {
    overlays.remove('saveOverlay');
    String levelLayout = jsonEncode(componentList);
    final file = await localFile(fName);
    file.writeAsString(levelLayout);
  }

  void hideSaveOverlay() {
    overlays.remove('saveOverlay');
  }

  void hideResize() {
    overlays.remove('resizeOverlay');
  }

  void deleteComponent() {
    debugPrint('Attempting to delete $currentComp');
    componentList.remove(currentComp);
    remove(currentComp);
  }

  List<Operations> getOperations() {
    if (currentComp is DragBrickWall ||
        currentComp is DragWoodWall ||
        currentComp is DragSpike ||
        currentComp is DragStar) {
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
    if (currentComp is DragBasket) {
      return (currentComp as DragBasket).movement;
    } else if (currentComp is DragBrickWall) {
      return (currentComp as DragBrickWall).movement;
    } else if (currentComp is DragWoodWall) {
      return (currentComp as DragWoodWall).movement;
    } else if (currentComp is DragStar) {
      return (currentComp as DragStar).movement;
    } else if (currentComp is DragSpike) {
      return (currentComp as DragSpike).movement;
    } else {
      return Movement(allow: false, position: Vector2(0,0), time: 1, angle: 0);
    }
  }

  void setMovement(Movement newValues) {
    if (currentComp is DragBasket) {
      (currentComp as DragBasket).movement = newValues;
    } else if (currentComp is DragBrickWall) {
      (currentComp as DragBrickWall).movement = newValues;
    } else if (currentComp is DragWoodWall) {
      (currentComp as DragWoodWall).movement = newValues;
    } else if (currentComp is DragStar) {
      (currentComp as DragStar).movement = newValues;
    } else if (currentComp is DragSpike) {
      (currentComp as DragSpike).movement = newValues;
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
}

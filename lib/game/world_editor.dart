import 'package:basket/sprites/draggable.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';

import '../sprites/world.dart';

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
  wallType,
}

class WorldEditorGame extends FlameGame with HasDraggableComponents, HasTappableComponents {
  late PositionComponent currentComp;
  final MyWorld _world = MyWorld();
  late final CameraComponent cameraComponent;
  late final World world;
  Vector2 worldSize = Vector2(400, 800);

  List<Component> componentList = [
    DragWoodWall(size: Vector2(400, 10), position: Vector2(200, 5)),
    DragWoodWall(size: Vector2(400, 15), position: Vector2(200, 795)),
    DragBrickWall(size: Vector2(10, 800), position: Vector2(5, 400)),
    DragBrickWall(size: Vector2(10, 800), position: Vector2(395, 400)),
    DragBasket(size: Vector2(50, 50), position: Vector2(300, 100)),
    DragBall(),
  ];

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
    currentComp = PositionComponent();
    world.addAll(componentList);
    world.add(_world);
    // world.add(DragTarget());
    overlays.add('editorOverlay');
  }

  void addComponent(Components component) {
    switch (component) {
      case Components.brickWall:
        {
          componentList.add(DragBrickWall(position: Vector2(100, 100), size: Vector2(10, 100)));
          world.add(componentList.last);
        }
        break;

      case Components.woodWall:
        {
          componentList.add(DragWoodWall(position: Vector2(100, 100), size: Vector2(10, 100)));
          world.add(componentList.last);
        }
        break;
      case Components.spike:
        {
          componentList.add(DragSpike(position: Vector2(100, 100), size: Vector2(10, 20)));
          world.add(componentList.last);
        }
        break;
      case Components.star:
        {
          componentList.add(DragStar(position: Vector2(100, 100), size: Vector2(20, 20)));
          world.add(componentList.last);
        }
        break;
    }
  }

  double getAngle() {
    if (currentComp != null) {
      return currentComp.angle;
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

  void showResize(PositionComponent object) {
    overlays.remove('resizeOverlay');
    print('${object.size}');
    currentComp = object;
    overlays.add('resizeOverlay');
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
        currentComp is DragBall ||
        currentComp is DragStar) {
      return [Operations.resize, Operations.rotate, Operations.delete];
    } else {
      return [Operations.resize, Operations.rotate, Operations.delete];
    }
  }

  String getComponentName() {
    return "Brick Wall";
  }

  // List<Vector2> getCorners() {
  //   List<Vector2> corners = [];
  //   if (currentComp is DragBrickWall) {
  //     corners = (currentComp as DragBrickWall).hitBox.globalVertices();
  //   } else if (currentComp is DragWoodWall) {
  //     corners = (currentComp as DragWoodWall).hitBox.globalVertices();
  //   } else if (currentComp is DragStar) {
  //     corners = (currentComp as DragStar).hitBox.globalVertices();
  //   } else if (currentComp is DragSpike) {
  //     corners = (currentComp as DragSpike).hitBox.globalVertices();
  //   }
  //   return corners;
  // }
  //
  // Vector2 getCentre() {
  //   return currentComp.absoluteCenter;
  // }
}

/// This component is the pink-ish rectangle in the center of the game window.
/// It uses the [DragCallbacks] mixin in order to receive drag events.
class DragTarget extends PositionComponent with DragCallbacks {
  DragTarget() : super(anchor: Anchor.center);

  final _rectPaint = Paint()..color = const Color(0xffAC54BF);

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);
    size = Vector2(400, 800);
    position = size / 2;
    print(size);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), _rectPaint);
  }
}

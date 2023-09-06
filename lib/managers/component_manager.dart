import 'package:basket/game/basket_game.dart';
import 'package:basket/sprites/enemies.dart';
import 'package:basket/sprites/goal.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';

import '../sprites/walls.dart';

class ComponentManager extends Component with HasGameRef<BasketBall> {
  List<Component> objectList = [];
  
  @override
  void onMount() {
    super.onMount();
    setLevel(1, 'T');
  }

  void clean() {
    for (Component object in objectList) {
      object.removeFromParent();
    }
  }

  void setLevel(int level, String type) {
    clean();
    objectList.clear();

    if (type == 'N') {
      if (level == 1) {
        objectList.add(WoodWall(startPosition: Vector2(10, 790), size: Vector2(380, 10)));
        objectList.add(BrickWall(startPosition: Vector2(0, 0), size: Vector2(10, 800)));
        objectList.add(BrickWall(startPosition: Vector2(390, 0), size: Vector2(10, 800)));
        objectList.add(WoodWall(startPosition: Vector2(10, 620), size: Vector2(290, 10)));
        objectList.add(WoodWall(startPosition: Vector2(120, 500), size: Vector2(300, 10), startAngle: -15));
        objectList.add(WoodWall(startPosition: Vector2(10, 300), size: Vector2(290, 10)));
        objectList.add(BasketGoal(startPosition: Vector2(280, 180), size: Vector2(100, 60), startAngle: 0));
      } else {
        objectList.add(WoodWall(startPosition: Vector2(10, 790), size: Vector2(380, 10)));
        objectList.add(BrickWall(startPosition: Vector2(0, 0), size: Vector2(10, 800)));
        objectList.add(BrickWall(startPosition: Vector2(390, 0), size: Vector2(10, 800)));
        objectList.add(WoodWall(startPosition: Vector2(150, 650), size: Vector2(240, 10)));
        objectList.add(WoodWall(startPosition: Vector2(150, 650), size: Vector2(10, 40)));
        objectList.add(WoodWall(startPosition: Vector2(150, 750), size: Vector2(10, 40)));
        objectList.add(Spike(startPosition: Vector2(250, 650), size: Vector2(10, 25)));
        objectList.add(Spike(startPosition: Vector2(260, 650), size: Vector2(10, 25)));
        objectList.add(Spike(startPosition: Vector2(270, 650), size: Vector2(10, 25)));
        objectList.add(Spike(startPosition: Vector2(280, 650), size: Vector2(10, 25)));
        objectList.add(WoodWall(startPosition: Vector2(10, 500), size: Vector2(240, 10)));
        objectList.add(Star(startPosition: Vector2(110, 500), size: Vector2(20, 20)));
        objectList.add(Star(startPosition: Vector2(110, 480), size: Vector2(20, 20)));
        objectList.add(Star(startPosition: Vector2(110, 460), size: Vector2(20, 20)));
        objectList.add(WoodWall(startPosition: Vector2(150, 300), size: Vector2(240, 10)));
        objectList.add(BasketGoal(startPosition: Vector2(250, 200), size: Vector2(100, 60), startAngle: 0));
      }
    } else if (type == 'T') {
      switch (level) {
        case 1: {
          objectList.add(WoodWall(startPosition: Vector2(10, 790), size: Vector2(380, 10)));
          objectList.add(WoodWall(startPosition: Vector2(10, 0), size: Vector2(380, 10)));
          objectList.add(BrickWall(startPosition: Vector2(0, 0), size: Vector2(10, 800)));
          objectList.add(BrickWall(startPosition: Vector2(390, 0), size: Vector2(10, 800)));
          objectList.add(BasketGoal(startPosition: Vector2(250, 780), size: Vector2(100, 60), startAngle: 0));
          break;
        }

        case 2: {
          objectList.add(WoodWall(startPosition: Vector2(10, 790), size: Vector2(380, 10)));
          objectList.add(WoodWall(startPosition: Vector2(10, 0), size: Vector2(380, 10)));
          objectList.add(WoodWall(startPosition: Vector2(10, 700), size: Vector2(200, 10)));
          objectList.add(WoodWall(startPosition: Vector2(190, 600), size: Vector2(200, 10)));
          objectList.add(WoodWall(startPosition: Vector2(10, 500), size: Vector2(200, 10)));
          objectList.add(BrickWall(startPosition: Vector2(0, 0), size: Vector2(10, 800)));
          objectList.add(BrickWall(startPosition: Vector2(390, 0), size: Vector2(10, 800)));
          objectList.add(BasketGoal(startPosition: Vector2(50, 480), size: Vector2(100, 60), startAngle: 0));
          break;
        }

        case 3: {
          objectList.add(WoodWall(startPosition: Vector2(10, 790), size: Vector2(380, 10)));
          objectList.add(WoodWall(startPosition: Vector2(10, 0), size: Vector2(380, 10)));
          objectList.add(BrickWall(startPosition: Vector2(0, 0), size: Vector2(10, 800)));
          objectList.add(BrickWall(startPosition: Vector2(390, 0), size: Vector2(10, 800)));
          objectList.add(BasketGoal(startPosition: Vector2(250, 200), size: Vector2(100, 60), startAngle: 0));
          break;
        }

        case 4: {
          objectList.add(WoodWall(startPosition: Vector2(10, 790), size: Vector2(380, 10)));
          objectList.add(BrickWall(startPosition: Vector2(0, 0), size: Vector2(10, 800)));
          objectList.add(BrickWall(startPosition: Vector2(390, 0), size: Vector2(10, 800)));
          objectList.add(WoodWall(startPosition: Vector2(150, 650), size: Vector2(240, 10)));
          objectList.add(Spike(startPosition: Vector2(250, 650), size: Vector2(10, 25)));
          objectList.add(Spike(startPosition: Vector2(260, 650), size: Vector2(10, 25)));
          objectList.add(Spike(startPosition: Vector2(270, 650), size: Vector2(10, 25)));
          objectList.add(Spike(startPosition: Vector2(280, 650), size: Vector2(10, 25)));
          objectList.add(WoodWall(startPosition: Vector2(10, 500), size: Vector2(240, 10)));
          objectList.add(WoodWall(startPosition: Vector2(150, 300), size: Vector2(240, 10)));
          objectList.add(BasketGoal(startPosition: Vector2(250, 200), size: Vector2(100, 60), startAngle: 0));
          break;
        }

        default: {
          objectList.add(WoodWall(startPosition: Vector2(10, 790), size: Vector2(380, 10)));
          objectList.add(WoodWall(startPosition: Vector2(10, 0), size: Vector2(380, 10)));
          objectList.add(BrickWall(startPosition: Vector2(0, 0), size: Vector2(10, 800)));
          objectList.add(BrickWall(startPosition: Vector2(390, 0), size: Vector2(10, 800)));
          break;
        }
      }
    }
    debugPrint('$objectList');
    for (Component object in objectList) {
      add(object);
    }
  }
}
import 'package:basket/game/basket_game.dart';
import 'package:basket/sprites/enemies.dart';
import 'package:flame/components.dart';

import '../sprites/circles.dart';
import '../sprites/walls.dart';

class ComponentManager extends Component with HasGameRef<BasketBall> {
  List<Component> objectList = [];
  
  @override
  void onMount() {
    super.onMount();
    setLevel(1);
  }

  void clean() {
    for (Component object in objectList) {
      object.removeFromParent();
    }
  }

  void setLevel(int level) {
    clean();
    objectList.clear();
    if (level == 1) {
      objectList.add(Wall(position: Vector2(0, 790), size: Vector2(400, 10)));
      objectList.add(Wall(position: Vector2(0, 0), size: Vector2(10, 800)));
      objectList.add(Wall(position: Vector2(390, 0), size: Vector2(10, 800)));
      objectList.add(Wall(position: Vector2(0, 620), size: Vector2(300, 10)));
      objectList.add(Wall(position: Vector2(120, 500), size: Vector2(300, 10), angle: -15));
      objectList.add(Wall(position: Vector2(0, 300), size: Vector2(300, 10)));
      objectList.add(MyCircle(position: Vector2(300, 100), radius: 10, coefficient: 0.8));
      objectList.add(MyCircle(position: Vector2(400, 100), radius: 10, coefficient: 0.8));
      objectList.add(Wall(position: Vector2(315, 115), size: Vector2(80, 10), angle: 45, coefficient: 0.1));
      objectList.add(Wall(position: Vector2(355, 170), size: Vector2(80, 10), angle: -45, coefficient: 0.1));
    } else {
      objectList.add(Wall(position: Vector2(0, 790), size: Vector2(400, 10)));
      objectList.add(Wall(position: Vector2(0, 0), size: Vector2(10, 800)));
      objectList.add(Wall(position: Vector2(390, 0), size: Vector2(10, 800)));
      objectList.add(BrickWall(position: Vector2(200, 400), size: Vector2(200,10)));
      objectList.add(Spike(position: Vector2(50, 790), size: Vector2(20, 50)));
      objectList.add(Spike(position: Vector2(70, 790), size: Vector2(20, 50)));
      objectList.add(Spike(position: Vector2(90, 790), size: Vector2(20, 50)));
      objectList.add(Spike(position: Vector2(110, 790), size: Vector2(20, 50)));
      objectList.add(Star(position: Vector2(110, 700), size: Vector2(100, 100)));
    }
    print(objectList);
    for (Component object in objectList) {
      add(object);
    }
  }
}
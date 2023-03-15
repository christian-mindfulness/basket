import 'package:basket/sprites/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';

import '../sprites/walls.dart';
import '../sprites/circles.dart';
import '../sprites/world.dart';

class BasketBall extends FlameGame with HasCollisionDetection, HasKeyboardHandlerComponents {

  BasketBall({super.children});
  final MyWorld _world = MyWorld();
  final Player _player = Player();

  @override
  Future<void> onLoad() async {
    await add(_world);
    await add(ScreenHitbox());
    add(_player);
    overlays.add('gameOverlay');
    add(Wall(position: Vector2(0, 50), size: Vector2(100, 20)));
    //add(Wall(position: Vector2(300, 50), size: Vector2(100, 20)));
    add(Wall(position: Vector2(0, 500), size: Vector2(100, 20)));
    add(Wall(position: Vector2(300, 500), size: Vector2(100, 20)));
    add(MyCircle(position: Vector2(300, 100), radius: 10, coefficient: 0.8));
    add(MyCircle(position: Vector2(400, 100), radius: 10, coefficient: 0.8));
    add(Wall(position: Vector2(315, 115), size: Vector2(80, 10), angle: 45, coefficient: 0.1));
    add(Wall(position: Vector2(355, 170), size: Vector2(80, 10), angle: -45, coefficient: 0.1));
  }

  void playerImpulse(Vector2 size) {
    _player.impulse(size);
  }
}
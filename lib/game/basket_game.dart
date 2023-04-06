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

  @override
  Future<void> onLoad() async {
    double maxSide = min(size.x, size.y);
    print(canvasSize);
    print(size);
    camera.viewport = FixedResolutionViewport(Vector2(400, 800));
    await add(_world);
    // await add(ScreenHitbox());
    add(_player);
    overlays.add('gameOverlay');
    // add(Wall(position: Vector2(0, 790), size: Vector2(400, 10)));
    // add(Wall(position: Vector2(0, 0), size: Vector2(10, 800)));
    // add(Wall(position: Vector2(390, 0), size: Vector2(10, 800)));
    // add(Wall(position: Vector2(0, 620), size: Vector2(300, 10)));
    // add(Wall(position: Vector2(120, 500), size: Vector2(300, 10), angle: -15));
    // add(Wall(position: Vector2(0, 300), size: Vector2(300, 10)));
    // add(MyCircle(position: Vector2(300, 100), radius: 10, coefficient: 0.8));
    // add(MyCircle(position: Vector2(400, 100), radius: 10, coefficient: 0.8));
    // add(Wall(position: Vector2(315, 115), size: Vector2(80, 10), angle: 45, coefficient: 0.1));
    // add(Wall(position: Vector2(355, 170), size: Vector2(80, 10), angle: -45, coefficient: 0.1));
    componentManager = ComponentManager();
    add(componentManager);
  }

  void playerImpulse(Vector2 size) {
    _player.impulse(size);
  }

  void setLevel(int level) {
    print('Set level $level');
    componentManager.clean();
    componentManager.setLevel(level);
    _player.resetPosition();
  }

  void togglePauseState() {
    if (paused) {
      resumeEngine();
    } else {
      pauseEngine();
    }
  }
}
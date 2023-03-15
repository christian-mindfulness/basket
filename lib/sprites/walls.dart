import 'package:basket/game/basket_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';

class Wall extends SpriteComponent
    with HasGameRef<BasketBall>, CollisionCallbacks {
  final hitBox = RectangleHitbox();
  final double coefficient;

  Wall({
    super.position,
    required Vector2 size,
    this.coefficient = 0.5,
    double angle = 0
  }) : super(
    size: size,
    priority: 3,
    angle: radians(angle),
  );

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    await add(hitBox);
    sprite = await gameRef.loadSprite('game/wall.png');
  }

  double getCoefficient() {
    return coefficient;
  }
}

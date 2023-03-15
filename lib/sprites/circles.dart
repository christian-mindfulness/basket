import 'package:basket/game/basket_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class MyCircle extends SpriteComponent
    with HasGameRef<BasketBall>, CollisionCallbacks {
  final hitBox = CircleHitbox();
  final double coefficient;
  final double radius;

  MyCircle({
    super.position,
    required this.radius,
    this.coefficient = 1
  }) : super(
    size: Vector2(2*radius, 2*radius),
    priority: 2,
  );

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    await add(hitBox);
    sprite = await gameRef.loadSprite('game/blue_ball.png');
  }

  double getCoefficient() {
    return coefficient;
  }

  double getRadius() {
    return radius;
  }
}

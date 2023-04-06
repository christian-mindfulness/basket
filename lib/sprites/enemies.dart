import 'package:basket/game/basket_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Spike extends SpriteComponent
    with HasGameRef<BasketBall>, CollisionCallbacks {
  late final PolygonHitbox hitBox;
  final double coefficient;
  late final List<bool> deadlyVertices;

  Spike({
    super.position,
    required Vector2 size,
    this.coefficient = 0.7,
    double angle = 0
  }) : super(
    size: size,
    priority: 3,
    angle: radians(angle),
    anchor: Anchor.bottomLeft,
  ) {
    hitBox = PolygonHitbox([
      Vector2(0, size.y),
      Vector2(0.5 * size.x, 0),
      Vector2(size.x, size.y),
    ]);
    deadlyVertices = [false, true, false];
  }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    await add(hitBox);
    sprite = await gameRef.loadSprite('game/spike.png');
  }

  double getCoefficient() {
    return coefficient;
  }
}

class Star extends SpriteComponent with HasGameRef<BasketBall>, CollisionCallbacks {
  late final PolygonHitbox hitBox;
  final double coefficient;
  late final List<bool> deadlyVertices;

  Star({
    super.position,
    required Vector2 size,
    this.coefficient = 0.7,
    double angle = 0
  }) : super(
    size: size,
    priority: 3,
    angle: radians(angle),
    anchor: Anchor.bottomLeft,
  ) {
    hitBox = PolygonHitbox([
      Vector2(0.5 * size.x, 1.0 * size.y),
      Vector2(0.5794168018485238 * size.x, 0.6431041321077906 * size.y),
      Vector2(0.9009688679024191 * size.x, 0.8019377358048384 * size.y),
      Vector2(0.6784479339461047 * size.x, 0.5157294715892572 * size.y),
      Vector2(1.0 * size.x, 0.3568958678922095 * size.y),
      Vector2(0.6431041321077907 * size.x, 0.35689586789220945 * size.y),
      Vector2(0.7225209339563144 * size.x, 0.0 * size.y),
      Vector2(0.5 * size.x, 0.28620826421558115 * size.y),
      Vector2(0.27747906604368566 * size.x, 0.0 * size.y),
      Vector2(0.3568958678922095 * size.x, 0.35689586789220945 * size.y),
      Vector2(0.0 * size.x, 0.3568958678922094 * size.y),
      Vector2(0.32155206605389525 * size.x, 0.5157294715892572 * size.y),
      Vector2(0.09903113209758083 * size.x, 0.8019377358048382 * size.y),
      Vector2(0.42058319815147616 * size.x, 0.6431041321077905 * size.y),
    ]);
    deadlyVertices = [false, true, false];
  }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    await add(hitBox);
    sprite = await gameRef.loadSprite('game/star.png');
  }

  double getCoefficient() {
    return coefficient;
  }
}
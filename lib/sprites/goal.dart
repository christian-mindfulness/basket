import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../game/basket_game.dart';

class BasketGoal extends SpriteComponent
    with CollisionCallbacks {
  late final PolygonHitbox hitBox;
  late final CircleHitbox goalHitBox;
  final double coefficient;
  final List<bool> deadlyVertices = List.filled(38, false);

  BasketGoal({
    super.position,
    required Vector2 size,
    this.coefficient = 0.1,
    double angle = 0
  }) : super(
    size: size,
    priority: 2,
    angle: radians(angle),
    anchor: Anchor.bottomLeft,
  ) {
    goalHitBox = CircleHitbox(radius: min(size.x, size.y) / 4, position: Vector2(size.x / 2, size.y * 0.7), anchor: Anchor.center);
    hitBox = PolygonHitbox([
      Vector2(1.0 * size.x, 0.0 * size.y),
      Vector2(0.9924038765061041 * size.x, 0.1736481776669303 * size.y),
      Vector2(0.9698463103929542 * size.x, 0.34202014332566866 * size.y),
      Vector2(0.9330127018922194 * size.x, 0.5 * size.y),
      Vector2(0.883022221559489 * size.x, 0.6427876096865393 * size.y),
      Vector2(0.8213938048432696 * size.x, 0.766044443118978 * size.y),
      Vector2(0.75 * size.x, 0.8660254037844386 * size.y),
      Vector2(0.6710100716628344 * size.x, 0.9396926207859083 * size.y),
      Vector2(0.5868240888334653 * size.x, 0.984807753012208 * size.y),
      Vector2(0.5 * size.x, 1.0 * size.y),
      Vector2(0.41317591116653485 * size.x, 0.984807753012208 * size.y),
      Vector2(0.32898992833716567 * size.x, 0.9396926207859084 * size.y),
      Vector2(0.2500000000000001 * size.x, 0.8660254037844387 * size.y),
      Vector2(0.17860619515673032 * size.x, 0.766044443118978 * size.y),
      Vector2(0.11697777844051105 * size.x, 0.6427876096865395 * size.y),
      Vector2(0.06698729810778065 * size.x, 0.5 * size.y),
      Vector2(0.03015368960704584 * size.x, 0.3420201433256689 * size.y),
      Vector2(0.00759612349389599 * size.x, 0.1736481776669303 * size.y),
      Vector2(0.0 * size.x, 1.1102230246251565e-16 * size.y),
      Vector2(0.09999999999999998 * size.x, 1.1102230246251565e-16 * size.y),
      Vector2(0.10607689879511678 * size.x, 0.15628335990023723 * size.y),
      Vector2(0.12412295168563664 * size.x, 0.307818128993102 * size.y),
      Vector2(0.15358983848622448 * size.x, 0.44999999999999996 * size.y),
      Vector2(0.19358222275240883 * size.x, 0.5785088487178855 * size.y),
      Vector2(0.24288495612538424 * size.x, 0.6894399988070802 * size.y),
      Vector2(0.30000000000000004 * size.x, 0.7794228634059949 * size.y),
      Vector2(0.36319194266973254 * size.x, 0.8457233587073176 * size.y),
      Vector2(0.43054072893322787 * size.x, 0.8863269777109872 * size.y),
      Vector2(0.5 * size.x, 0.9 * size.y),
      Vector2(0.5694592710667722 * size.x, 0.8863269777109872 * size.y),
      Vector2(0.6368080573302676 * size.x, 0.8457233587073175 * size.y),
      Vector2(0.7000000000000001 * size.x, 0.7794228634059948 * size.y),
      Vector2(0.7571150438746157 * size.x, 0.6894399988070802 * size.y),
      Vector2(0.8064177772475912 * size.x, 0.5785088487178853 * size.y),
      Vector2(0.8464101615137756 * size.x, 0.44999999999999996 * size.y),
      Vector2(0.8758770483143634 * size.x, 0.3078181289931019 * size.y),
      Vector2(0.8939231012048832 * size.x, 0.15628335990023734 * size.y),
      Vector2(0.9 * size.x, 0.0 * size.y),
    ]);
  }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    await add(hitBox);
    await add(goalHitBox);
    sprite = await Sprite.load('game/basket.png');
  }

  double getCoefficient() {
    return coefficient;
  }
}

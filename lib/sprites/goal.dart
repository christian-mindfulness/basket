import 'dart:math';

import 'package:basket/sprites/basket_sprites.dart';
import 'package:basket/sprites/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../utils/clone_list.dart';
import '../utils/movement.dart';
import '../utils/time_and_velocity.dart';
import '../utils/update_position.dart';

class BasketGoal extends MovementSprite
    with CollisionCallbacks {
  late final PolygonHitbox hitBox;
  late final CircleHitbox goalHitBox;
  final Map<BallType, double> coefficient;
  final List<bool> deadlyVertices = List.filled(38, false);
  final List<Vector2> hitBoxShape = [
    Vector2(1.0, 0.0),
    Vector2(0.9924038765061041, 0.1736481776669303),
    Vector2(0.9698463103929542, 0.34202014332566866),
    Vector2(0.9330127018922194, 0.5),
    Vector2(0.883022221559489, 0.6427876096865393),
    Vector2(0.8213938048432696, 0.766044443118978),
    Vector2(0.75, 0.8660254037844386),
    Vector2(0.6710100716628344, 0.9396926207859083),
    Vector2(0.5868240888334653, 0.984807753012208),
    Vector2(0.5, 1.0),
    Vector2(0.41317591116653485, 0.984807753012208),
    Vector2(0.32898992833716567, 0.9396926207859084),
    Vector2(0.2500000000000001, 0.8660254037844387),
    Vector2(0.17860619515673032, 0.766044443118978),
    Vector2(0.11697777844051105, 0.6427876096865395),
    Vector2(0.06698729810778065, 0.5),
    Vector2(0.03015368960704584, 0.3420201433256689),
    Vector2(0.00759612349389599, 0.1736481776669303),
    Vector2(0.0, 1.1102230246251565e-16),
    Vector2(0.09999999999999998, 1.1102230246251565e-16),
    Vector2(0.10607689879511678, 0.15628335990023723),
    Vector2(0.12412295168563664, 0.307818128993102),
    Vector2(0.15358983848622448, 0.44999999999999996),
    Vector2(0.19358222275240883, 0.5785088487178855),
    Vector2(0.24288495612538424, 0.6894399988070802),
    Vector2(0.30000000000000004, 0.7794228634059949),
    Vector2(0.36319194266973254, 0.8457233587073176),
    Vector2(0.43054072893322787, 0.8863269777109872),
    Vector2(0.5, 0.9),
    Vector2(0.5694592710667722, 0.8863269777109872),
    Vector2(0.6368080573302676, 0.8457233587073175),
    Vector2(0.7000000000000001, 0.7794228634059948),
    Vector2(0.7571150438746157, 0.6894399988070802),
    Vector2(0.8064177772475912, 0.5785088487178853),
    Vector2(0.8464101615137756, 0.44999999999999996),
    Vector2(0.8758770483143634, 0.3078181289931019),
    Vector2(0.8939231012048832, 0.15628335990023734),
    Vector2(0.9, 0.0),
  ];
  late List<Vector2> oldGlobalVertices;

  BasketGoal({
    required super.startPosition,
    required super.size,
    this.coefficient = const {
      BallType.basket: 0.1,
      BallType.beach: 0.1,
      BallType.metal: 0.1,
      BallType.tennis: 0.1,
    },
    super.startAngle,
  }) : super() {
    goalHitBox = CircleHitbox(radius: min(size.x, size.y) / 4, position: Vector2(size.x / 2, size.y * 0.7), anchor: Anchor.center);
    hitBox = PolygonHitbox(hitBoxShape.map((e) => Vector2(e.x*size.x, e.y*size.y)).toList());
  }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    await add(hitBox);
    await add(goalHitBox);
    var basket = await Sprite.load('game/basket.png');
    sprites = <int, Sprite>{0: basket};
    current = 0;
  }

  @override
  void update(double dt) {
    oldGlobalVertices = cloneList(hitBox.globalVertices());
    super.update(dt);
  }

  double getCoefficient(BallType ballType) {
    return coefficient[ballType]!;
  }

  BasketGoal.fromJson(Map<String, dynamic> json) :
        coefficient = const {
          BallType.basket: 0.1,
          BallType.beach: 0.1,
          BallType.metal: 0.1,
          BallType.tennis: 0.1,
        },
        super.fromJson(json) {
    goalHitBox = CircleHitbox(radius: min(size.x, size.y) / 4, position: Vector2(size.x / 2, size.y * 0.7), anchor: Anchor.center);
    hitBox = PolygonHitbox(hitBoxShape.map((e) => Vector2(e.x*size.x, e.y*size.y)).toList());
  }

  @override
  String getName() {
    return 'Goal';
  }
}

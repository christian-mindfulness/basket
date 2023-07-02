import 'package:basket/sprites/basket_sprites.dart';
import 'package:basket/sprites/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../utils/movement.dart';

class Spike extends BasketSprite
    with CollisionCallbacks {
  late final PolygonHitbox hitBox;
  final Map<BallType, dynamic> coefficient;
  late final List<bool> deadlyVertices;
  Movement movement = Movement(
      allow: false,
      position: Vector2(0,0),
      time: 1,
      angle: 0
  );

  Spike({
    super.position,
    required Vector2 size,
    this.coefficient = const {
      BallType.basket: 0.7,
      BallType.beach: 0.7,
      BallType.metal: 0.7,
      BallType.tennis: 0.7,
    },
    double angle = 0}) :
        hitBox = PolygonHitbox([
          Vector2(0, 1),
          Vector2(0.5, 0),
          Vector2(1, 1),
        ].map((e) => Vector2(e.x*size.x, e.y*size.y)).toList()),
        deadlyVertices = [false, true, false],
        super(
        size: size,
        priority: 3,
        angle: radians(angle),
      );

  List<Vector2> getHitBox() {
    return [
      Vector2(0 * size.x, 1 * size.y),
      Vector2(0.5 * size.x, 0 * size.y),
      Vector2(1 * size.x, 1 * size.y)];
  }

  void addHitBox() async {
    try {
      remove(hitBox);
    } catch (error) {
      print('error $error');
    }
    hitBox = PolygonHitbox(getHitBox());
    await add(hitBox);
  }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    await add(hitBox);
    var spike = await Sprite.load('game/spike.png');
    sprites = <int, Sprite>{0: spike};
    current = 0;
  }

  double getCoefficient(BallType ballType) {
    return coefficient[ballType];
  }

  @override
  String getName() {
    return "Spike";
  }

  Spike.fromJson(Map<String, dynamic> json) :
        coefficient = const {
          BallType.basket: 0.7,
          BallType.beach: 0.7,
          BallType.metal: 0.7,
          BallType.tennis: 0.7,
        },
        hitBox = PolygonHitbox([
          Vector2(0, 1),
          Vector2(0.5, 0),
          Vector2(1, 1),
        ].map((e) => Vector2(e.x*json['size.x'], e.y*json['size.y'])).toList()),
        deadlyVertices = [false, true, false],
        movement = Movement.fromJson(json['movement']),
        super(position: Vector2(json['position.x'], json['position.y']),
          size: Vector2(json['size.x'], json['size.y']),
          angle: json['angle']);

  @override
  Map<String, dynamic> toJson() => {
    'position.x': position.x,
    'position.y': position.y,
    'size.x': size.x,
    'size.y': size.y,
    'angle': degrees(angle),
    'movement': movement.toJson(),
  };
}

class Star extends BasketSprite {
  final PolygonHitbox hitBox;
  final Map<BallType, double> coefficient;
  final List<bool> deadlyVertices;
  Movement movement = Movement(
      allow: false,
      position: Vector2(0,0),
      time: 1,
      angle: 0
  );

  Star({
    super.position,
    required Vector2 size,
    this.coefficient = const {
      BallType.basket: 0.7,
      BallType.beach: 0.7,
      BallType.metal: 0.7,
      BallType.tennis: 0.7,
      },
    double angle = 0}) :
        hitBox = PolygonHitbox([
          Vector2(0.5000, 1.0000),
          Vector2(0.5794, 0.6431),
          Vector2(0.9010, 0.8019),
          Vector2(0.6784, 0.5157),
          Vector2(1.0000, 0.3569),
          Vector2(0.6431, 0.3569),
          Vector2(0.7225, 0.0000),
          Vector2(0.5000, 0.2862),
          Vector2(0.2775, 0.0000),
          Vector2(0.3569, 0.3569),
          Vector2(0.0000, 0.3569),
          Vector2(0.3216, 0.5157),
          Vector2(0.0990, 0.8019),
          Vector2(0.4206, 0.6431),
        ].map((e) => Vector2(e.x*size.x, e.y*size.y)).toList()),
        deadlyVertices = List.filled(14, true),
        super(
        size: size,
        priority: 3,
        angle: radians(angle),
        );

  @override
  Future<void>? onLoad() async {
    print('onLoad');
    await super.onLoad();
    add(hitBox);
    var star = await Sprite.load('game/star.png');
    sprites = <int, Sprite>{0: star};
    current = 0;
  }

  double getCoefficient(BallType ballType) {
    return coefficient[ballType]!;
  }

  @override
  String getName() {
    return "Star";
  }

  Star.fromJson(Map<String, dynamic> json) :
        coefficient = const {
          BallType.basket: 0.7,
          BallType.beach: 0.7,
          BallType.metal: 0.7,
          BallType.tennis: 0.7,
        },
        hitBox = PolygonHitbox([
          Vector2(0.5000, 1.0000),
          Vector2(0.5794, 0.6431),
          Vector2(0.9010, 0.8019),
          Vector2(0.6784, 0.5157),
          Vector2(1.0000, 0.3569),
          Vector2(0.6431, 0.3569),
          Vector2(0.7225, 0.0000),
          Vector2(0.5000, 0.2862),
          Vector2(0.2775, 0.0000),
          Vector2(0.3569, 0.3569),
          Vector2(0.0000, 0.3569),
          Vector2(0.3216, 0.5157),
          Vector2(0.0990, 0.8019),
          Vector2(0.4206, 0.6431),
        ].map((e) => Vector2(e.x*json['size.x'], e.y*json['size.y'])).toList()),
        deadlyVertices = List.filled(14, true),
        movement = Movement.fromJson(json['movement']),
        super(position: Vector2(json['position.x'], json['position.y']),
          size: Vector2(json['size.x'], json['size.y']),
          angle: json['angle']);

  @override
  Map<String, dynamic> toJson() => {
    'position.x': position.x,
    'position.y': position.y,
    'size.x': size.x,
    'size.y': size.y,
    'angle': degrees(angle),
    'movement': movement.toJson(),
  };
}
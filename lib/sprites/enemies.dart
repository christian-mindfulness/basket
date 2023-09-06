import 'package:basket/sprites/basket_sprites.dart';
import 'package:basket/sprites/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../utils/clone_list.dart';
import '../utils/movement.dart';
import '../utils/time_and_velocity.dart';
import '../utils/update_position.dart';

class Spike extends MovementSprite
    with CollisionCallbacks {
  late final PolygonHitbox hitBox;
  final Map<BallType, dynamic> coefficient;
  late final List<bool> deadlyVertices;
  late List<Vector2> oldGlobalVertices;

  Spike({
    required super.startPosition,
    required super.size,
    this.coefficient = const {
      BallType.basket: 0.7,
      BallType.beach: 0.7,
      BallType.metal: 0.7,
      BallType.tennis: 0.7,
    },
    super.startAngle,
    }) :
        hitBox = PolygonHitbox([
          Vector2(0, 1),
          Vector2(0.5, 0),
          Vector2(1, 1),
        ].map((e) => Vector2(e.x*size.x, e.y*size.y)).toList()),
        deadlyVertices = [false, true, false],
        super();

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

  @override
  void update(double dt) {
    oldGlobalVertices = cloneList(hitBox.globalVertices());
    super.update(dt);
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
        super.fromJson(json);
}

class Star extends MovementSprite {
  final PolygonHitbox hitBox;
  final Map<BallType, double> coefficient;
  final List<bool> deadlyVertices;
  late List<Vector2> oldGlobalVertices;

  Star({
    required super.startPosition,
    required super.size,
    this.coefficient = const {
      BallType.basket: 0.7,
      BallType.beach: 0.7,
      BallType.metal: 0.7,
      BallType.tennis: 0.7,
      },
    super.startAngle = 0,
    }) :
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
        super();

  @override
  Future<void>? onLoad() async {
    print('onLoad');
    await super.onLoad();
    add(hitBox);
    var star = await Sprite.load('game/star.png');
    sprites = <int, Sprite>{0: star};
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
        super.fromJson(json);
}